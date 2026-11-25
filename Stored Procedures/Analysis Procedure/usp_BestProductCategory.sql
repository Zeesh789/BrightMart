/**************************************************************
    Script Name         : usp_BestProductCategory.sql
    Purpose             : Showing the best Product Category by Gross Sales
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER PROC
usp_BestProductCategory
@CategoryID VARCHAR(4) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CategoryIDToProcess INT;
	BEGIN TRY
		SET @CategoryIDToProcess = TRY_CONVERT(INT, NULLIF(@CategoryID,''));

		IF (@CategoryID IS NOT NULL) AND (@CategoryIDToProcess IS NULL)
			BEGIN
				SELECT 'Invalid Category Id' as [Message]
			END
		ELSE IF (@CategoryIDToProcess IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM ProductCategory WHERE ProductCategoryID = @CategoryIDToProcess)
			BEGIN
				SELECT 'Category with ProductCategoryID ' + QUOTENAME(@CategoryID,'''') + ' does not exist' AS [Message]
			END
		ELSE
		BEGIN
			WITH BestProductCategory(CategoryRank,ProductCategoryID,ProductCategoryName,GrossSales)
			AS
				(
				SELECT
					DENSE_RANK() OVER (ORDER BY SUM(OP.ProductOrderCount * OP.ProductPrice) DESC) AS CategoryRank,
					PC.ProductCategoryID,
					PC.ProductCategoryName,
					SUM(OP.ProductOrderCount * OP.ProductPrice) AS GrossSales
				FROM 
				[dbo].[Order] O
				INNER JOIN [dbo].OrderProduct OP ON O.OrderID = OP.OrderID
				INNER JOIN [Product] P ON P.ProductID = OP.ProductID
				INNER JOIN ProductCategory PC ON PC.ProductCategoryID = P.ProductCategoryID
				WHERE O.OrderStatus = 1
				GROUP BY PC.ProductCategoryId, PC.ProductCategoryName
				)
			SELECT  CategoryRank, ProductCategoryName, GrossSales
			FROM BestProductCategory
			WHERE (@CategoryID IS NULL) OR (ProductCategoryID = @CategoryIDToProcess)
			ORDER BY CategoryRank;
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

EXEC usp_BestProductCategory @CategoryID = 1

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_BestProductCategory

-- No Store Id (All Stores shown)
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC usp_BestProductCategory @CategoryID = ''

-- Empty Store Id - Invalid Store ID
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------

EXEC usp_BestProductCategory @CategoryID = '02'

-- Valid Category Id (Only Category 2 shown with its Rank in the chain)
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC usp_BestProductCategory @CategoryID = 'abc'

-- Invalid category Id (characters in the parameter)
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------