/**************************************************************
    Script Name         : usp_ProductReturnRates.sql
    Purpose             : Showing every sold Product ranked by Return Rate
                          (Units Returned out of Units Sold) OR based on Product Category
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1
               
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_ProductReturnRates
@CategoryID VARCHAR(10)  = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Category_Id_To_Process INT;
	BEGIN TRY
		SET @Category_Id_To_Process = TRY_CONVERT(INT, NULLIF(@CategoryID,''));

		IF (@CategoryID IS NOT NULL) AND (@Category_Id_To_Process IS NULL)
			BEGIN
				SELECT  'Invalid Category Id' AS [Message]
			END
		ELSE IF (@Category_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.ProductCategory WHERE ProductCategoryId = @Category_Id_To_Process)
			BEGIN
				Select 'Category ' + QUOTENAME(@CategoryID,'''') + ' does not exist' AS [Message]
			END
		ELSE IF NOT EXISTS (SELECT 1 FROM dbo.[Order] WHERE OrderStatus = 1)
			BEGIN
				SELECT 'No Sales found' AS [Message]
			END;
		ELSE
			BEGIN
				WITH ProductSold (ProductID,Units_Sold)
				AS
				(							
					SELECT
						OP.ProductID,
						SUM(OP.ProductOrderCount) AS Units_Sold
					FROM 
					dbo.OrderProduct OP
					INNER JOIN 
					dbo.[Order] O ON O.OrderId = OP.OrderId
					WHERE O.OrderStatus = 1
					GROUP BY OP.ProductId
				),
				ProductReturned(ProductID, Units_Returned)
				AS
				(
					SELECT
						RP.ProductId,
						ISNULL(SUM(RP.ProductReturnCount),0) AS Units_Returned
					FROM dbo.ReturnProduct RP
					GROUP BY RP.ProductId
				) 
				SELECT 
					P.ProductName,
					PC.ProductCategoryName,
					ProductSold.Units_Sold,
					ISNULL(ProductReturned.Units_Returned,0) AS Units_Returned,
					CAST(ISNULL(ProductReturned.Units_Returned,0) * 100.0
					/ ProductSold.Units_Sold AS DECIMAL(5,2)) AS Return_Rate_Percent
				FROM ProductSold 
				LEFT JOIN 
				ProductReturned ON ProductSold.ProductID = ProductReturned.ProductID
				INNER JOIN 
				dbo.[Product] P ON P.ProductID = ProductSold.ProductID
				INNER JOIN 
				dbo.ProductCategory PC ON PC.ProductCategoryId = P.ProductCategoryID
				WHERE (@CategoryID IS NULL) OR (PC.ProductCategoryId = @CategoryID)
				ORDER BY Return_Rate_Percent,Units_Sold DESC,Units_Returned 
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

EXEC Usp_ProductReturnRates

-- All sold Products displayed by Return Rate, never Returned Products show 0.00

-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_ProductReturnRates @CategoryID = '1'  

-- Only Products Belonging to Category 1 will be displayed by Return Rate, never Returned Products show 0.00

-- RESULT : PASS

--------------------------------------------------------------------------------------


EXEC Usp_ProductReturnRates @CategoryID =  '999'

-- Category which does not exist
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------


EXEC Usp_ProductReturnRates @CategoryID =  'ABC123'

-- Characters in Category parameter which is Invalid
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProductReturnRates @CategoryID =  ''

-- Empty String in the Parameter
-- RESULT : TEST CASE 4 PASS


