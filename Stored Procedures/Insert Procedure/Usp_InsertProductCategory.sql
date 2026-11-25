/**************************************************************
    Script Name         : usp_InsertProductCategory.sql
    Purpose             : Inserting a Product Category in the product category table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
    Modified            : Version 1 
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertProductCategory
@CategoryName NVARCHAR(100) = NULL     -- wider than column so over-length input is caught, not silently truncated
AS
BEGIN
	SET NOCOUNT ON;
	SET @CategoryName = LTRIM(RTRIM(@CategoryName));
	BEGIN TRY
			IF (@CategoryName = '') OR (@CategoryName IS NULL) OR (PATINDEX('%[^a-zA-Z ]%', @CategoryName) > 0)
			OR (LEN(@CategoryName) <= 3) OR (LEN(@CategoryName) > 50)
			BEGIN
				SELECT 'INVALID Category Name (letters and spaces only, 4 to 50 characters)' AS [Message]
			END
			ELSE IF (PATINDEX('%  %', @CategoryName) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed! Invalid Input' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM ProductCategory WHERE ProductCategoryName = @CategoryName)
			BEGIN
				SELECT 'Category ' + QUOTENAME(@CategoryName,'''') + ' already exists in the Product Category Table' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO ProductCategory(ProductCategoryName)
				VALUES(@CategoryName)
				SELECT 'Category ' + QUOTENAME(@CategoryName,'''') + ' successfully added in the Product Category Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
			SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO

SELECT * FROM ProductCategory
