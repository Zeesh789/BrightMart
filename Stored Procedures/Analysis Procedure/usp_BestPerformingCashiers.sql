/**************************************************************
    Script Name         : usp_BestPerformingCashiers.sql
    Purpose             : Showing the Cashiers (Employees) ranked by the number
                          of Completed Orders they handled, for all Stores or
                          for one Store if the Store Id is provided
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_BestPerformingCashiers
@Store_Id VARCHAR(4) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Store_Id_To_Process INT;
	BEGIN TRY
		SET @Store_Id_To_Process = TRY_CONVERT(INT, NULLIF(@Store_Id,''));

		IF (@Store_Id IS NOT NULL) AND (@Store_Id_To_Process IS NULL)
			BEGIN
				SELECT 'Invalid Store Id' AS [Message]
			END;
		ELSE IF (@Store_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.Store WHERE StoreID = @Store_Id_To_Process)
			BEGIN
				SELECT 'Store ' + QUOTENAME(@Store_Id,'''') + ' does not exist' AS [Message]
			END;
		ELSE IF (@Store_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.[Order] WHERE StoreID = @Store_Id_To_Process)
			BEGIN
				SELECT 'No Orders found for Store ' + QUOTENAME(@Store_Id,'''') AS [Message]
			END;
		ELSE
			BEGIN
				WITH CashierRanked(Cashier_Rank,EmployeeName,StoreName,CompletedOrders,GrossSales)
				AS
				(
					SELECT
					DENSE_RANK() OVER (ORDER BY ISNULL(SUM(OrderID),0) DESC, ISNULL(SUM(O.OrderAmount),0) DESC) AS Cashier_Rank,
					E.EmployeeName,
					S.StoreName,
					SUM(OrderID) AS CompletedOrders,
					ISNULL(SUM(O.OrderAmount),0) AS GrossSales
					FROM [dbo].[Order] O
					INNER JOIN [dbo].[Store] S ON O.StoreID = S.StoreID
					INNER JOIN [dbo].[StoreEmployee] E ON O.EmployeeStoreID = E.EmployeeID 
					AND O.OrderStatus = 1
					WHERE (@Store_Id IS NULL) OR (O.StoreID = @Store_Id_To_Process)
					GROUP BY E.EmployeeName, S.StoreID, S.StoreName
				)
				SELECT 
				Cashier_Rank,
				EmployeeName,
				StoreName,
				CompletedOrders,
				GrossSales
				FROM CashierRanked
				ORDER BY Cashier_Rank
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

EXEC usp_BestPerformingCashiers

-- No Parameters (All Employees across all Stores ranked by Completed Orders)
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_BestPerformingCashiers @Store_Id = '1'

-- Employees of only Store 1
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_BestPerformingCashiers @Store_Id = '999'

-- Store which does not exist -> 'Store '999' does not exist'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_BestPerformingCashiers @Store_Id = 'abc'

-- Non-numeric Store Id -> 'Invalid Store Id'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_BestPerformingCashiers @Store_Id = ''

-- Empty string treated as Invalid Store Id
-- RESULT : PASS

------------------------------------------------------------------------------------

