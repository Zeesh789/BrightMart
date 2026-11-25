/**************************************************************
    Script Name         : usp_BestSellingProducts.sql
    Purpose             : Showing the Products ranked by the Quantity sold
    Created By          : Zeeshan Shaikh
    Created On          : 16/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 16/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER PROC
usp_BestSellingProducts
@Category_Id VARCHAR(10)  = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Category_Id_To_Process INT;
	BEGIN TRY
		SET @Category_Id_To_Process = TRY_CONVERT(INT, NULLIF(@Category_Id,''));

		IF (@Category_Id IS NOT NULL) AND (@Category_Id_To_Process IS NULL)
			BEGIN
				SELECT  'Invalid Category Id' AS [Message]
			END
		ELSE IF (@Category_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM ProductCategory WHERE ProductCategoryId = @Category_Id_To_Process)
			BEGIN
				Select 'Category ' + QUOTENAME(@Category_Id,'''') + ' does not exist' AS [Message]
			END
		ELSE
			BEGIN
				WITH ProductSales (QuantityRank, ProductName, ProductCategoryName, TotalQuantitySold, GrossSales)
				AS
				(
					SELECT
					DENSE_RANK() OVER (ORDER BY SUM(OP.ProductOrderCount) DESC) AS QuantityRank,
					P.ProductName,
					PC.ProductCategoryName,
					SUM(OP.ProductOrderCount) AS TotalQuantitySold,
					SUM(OP.ProductOrderCount * OP.ProductPrice) AS GrossSales
					FROM 
					dbo.[Order] O
					INNER JOIN dbo.OrderProduct OP ON O.OrderId = OP.OrderId
					INNER JOIN dbo.[Product] P ON OP.ProductID = P.ProductID
					INNER JOIN dbo.ProductCategory PC ON P.ProductCategoryId = PC.ProductCategoryId
					WHERE O.OrderStatus = 1
					AND ((@Category_Id IS NULL) OR (P.ProductCategoryID = @Category_Id_To_Process))
					GROUP BY P.ProductName, PC.ProductCategoryName
				) 
				SELECT 
				QuantityRank,
				ProductName,
				ProductCategoryName,
				TotalQuantitySold,
				GrossSales
				FROM ProductSales
				ORDER BY QuantityRank ASC, GrossSales DESC
			END;
	END TRY
	BEGIN CATCH
		Select 
		   ERROR_NUMBER() as ErrorNumber,
		   ERROR_MESSAGE() as ErrorMessage,
		   ERROR_PROCEDURE() as ErrorProcedure,
		   ERROR_STATE() as ErrorState,
		   ERROR_SEVERITY() as ErrorSeverity,
		   ERROR_LINE() as ErrorLine
	END CATCH;
END;
GO

EXEC usp_BestSellingProducts
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_BestSellingProducts

-- No Parameters (All sold Products ranked)
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC Usp_BestSellingProducts @Category_Id = '2'

-- Products of only Grocery Category
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------


EXEC Usp_BestSellingProducts @Category_Id = '999'

-- Category which does not exist
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------


EXEC Usp_BestSellingProducts @Category_Id = 'ABC123'

-- Characters in Category parameter which is Invalid
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC usp_BestSellingProducts @Category_Id = ''

-- Empty String in the Parameter
-- RESULT : TEST CASE 4 PASS

