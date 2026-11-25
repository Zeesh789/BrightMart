/**************************************************************
    Script Name         : usp_TopRevenueProducts.sql
    Purpose             : Showing the products with the highest revenue generated
    Created By          : Zeeshan Shaikh
    Created On          : 17/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 17/11/26
    Modified            : Version 1

****************************************************************/
USE BrightMartV2;
GO

CREATE OR ALTER PROC
usp_TopRevenueProducts
@Category_Id VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Category_Id_To_Process INT;
	BEGIN TRY
		SET @Category_Id_To_Process = TRY_CONVERT(INT, NULLIF(@Category_Id,''));

		IF (@Category_Id IS NOT NULL) AND (@Category_Id_To_Process IS NULL)
			BEGIN
				Select 'Invalid Category Id' AS [Message]
			END;
		ELSE IF (@Category_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.ProductCategory WHERE ProductCategoryID = @Category_Id_To_Process)
			BEGIN
				Select 'Category ' + QUOTENAME(@Category_Id,'''') + ' does not exist' AS [Message]
			END;
		ELSE
			BEGIN
				WITH TopRevenueProduct(RevenueRank,ProductName,ProductCategoryName,GrossRevenue)
				AS
				(
					SELECT
						DENSE_RANK() OVER (ORDER BY SUM(OP.ProductOrderCount * OP.ProductPrice) DESC) AS RevenueRank,
						P.ProductName,
						PC.ProductCategoryName,
						SUM(OP.ProductOrderCount * OP.ProductPrice) AS GrossRevenue
					FROM dbo.[Order] O
					INNER JOIN dbo.OrderProduct OP ON O.OrderID = OP.OrderID
					INNER JOIN dbo.[Product] P ON P.ProductID = OP.ProductID
					INNER JOIN dbo.ProductCategory PC ON PC.ProductCategoryId = P.ProductCategoryId
					WHERE O.OrderStatus = 1
					AND ((@Category_Id_To_Process IS NULL) OR (P.ProductCategoryId = @Category_Id_To_Process))
					GROUP BY P.ProductName, PC.ProductCategoryName
				)
				SELECT 
				RevenueRank,
				ProductName,
				ProductCategoryName,
				GrossRevenue
				FROM TopRevenueProduct
				ORDER BY RevenueRank
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

EXEC Usp_TopRevenueProducts

-- No Parameters (All sold Products ranked by Revenue)
-- RESULT :

------------------------------------------------------------------------------------

EXEC Usp_TopRevenueProducts @Category_Id = '1'

-- Products of only Category supplied 
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_TopRevenueProducts @Category_Id = '999'

-- Category which does not exist -> 'Category '999' does not exist'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_TopRevenueProducts @Category_Id = 'abc'

-- Non-numeric Category Id -> 'Invalid Category Id'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_TopRevenueProducts @Category_Id = ''

-- Empty string treated as Invalid Category Id
-- RESULT : PASS

------------------------------------------------------------------------------------