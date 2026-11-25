/**************************************************************
    Script Name         : usp_SalesByStore.sql
    Purpose             : Showing the Gross Sales of every Store or of
                          one Store if the Store Id is provided
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1

****************************************************************/

CREATE OR ALTER PROC
usp_SalesByStore
@Store_ID VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Store_Id_To_Process INT;
	BEGIN TRY
		SET @Store_Id_To_Process = TRY_CONVERT(INT,NULLIF(@Store_Id,''));

		IF (@Store_ID IS NOT NULL) AND (@Store_Id_To_Process IS NULL)
			BEGIN
				SELECT 'Invalid Store Id' as [Message]
			END;
		ELSE IF (@Store_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.Store WHERE StoreID = @Store_Id_To_Process)
			BEGIN
				SELECT 'Store with StoreID ' + QUOTENAME(@Store_Id,'''') + ' does not exist' AS [Message]
			END;
		ELSE
			BEGIN
				WITH SalesByStore(SalesRank,StoreID,StoreName,GrossSales,TotalOrders)
				AS
				(
					SELECT
						RANK() OVER (ORDER BY ISNULL(SUM(O.OrderAmount), 0) DESC) AS SalesRank,
						S.StoreID,
						S.StoreName,
						ISNULL(SUM(O.OrderAmount), 0) AS GrossSales,
						COUNT(O.OrderID) AS TotalOrders
					FROM dbo.Store S
					LEFT JOIN dbo.[Order] O 
					ON O.StoreID = S.StoreID AND O.OrderStatus = 1
					GROUP BY S.StoreID, S.StoreName
				)
				SELECT 
					SalesRank,
					StoreName,
					GrossSales,
					TotalOrders
				FROM
				SalesByStore
				WHERE (@Store_Id IS NULL) OR (StoreId = @Store_Id_To_Process)
				ORDER BY SalesRank
			END;
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_SalesByStore

-- No Store Id (All Stores shown)
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = ''

-- Empty Store Id - Invalid Store ID
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = '3'

-- Valid Store Id (Only Store 3 shown with its Rank in the chain)
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = 'abc'

-- Character in Store Id parameter
-- RESULT : TEST CASE 4 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = '1.5'

-- Decimal value in Store Id parameter
-- RESULT : TEST CASE 5 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = '999'

-- Store which does not exist
-- RESULT : TEST CASE 6 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByStore @Store_Id = '-1'

-- Negative Store Id
-- RESULT : TEST CASE 7 PASS

------------------------------------------------------------------------------------