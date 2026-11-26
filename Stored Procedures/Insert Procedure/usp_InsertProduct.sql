/**************************************************************
    Script Name         : usp_InsertProduct.sql
    Purpose             : Inserting a Product in the product table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
	Version				: Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertProduct
@ProductCategoryId     VARCHAR(5)  = NULL,   -- required (INT)
@ProductName           VARCHAR(52) = NULL,   -- required
@ProductPrice          VARCHAR(10)  = NULL,   -- required (DECIMAL)
@ProductAvailableCount VARCHAR(7)  = NULL,   -- required (INT)
@ProductIntroduceDate  VARCHAR(10)  = NULL    -- optional (DATE, yyyy-mm-dd) : defaults to today
AS
BEGIN
	SET NOCOUNT ON;

	/*---------- Convert inputs to required datatypes ----------*/
	DECLARE @vCategoryId    INT            = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ProductCategoryId)), ''));
	DECLARE @vProductName   VARCHAR(50)   = TRY_CONVERT(VARCHAR(500), NULLIF(LTRIM(RTRIM(@ProductName)), ''));
	DECLARE @vPrice         DECIMAL(7, 2) = TRY_CONVERT(DECIMAL(7, 2), NULLIF(LTRIM(RTRIM(@ProductPrice)), ''));
	DECLARE @vCount         INT            = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@ProductAvailableCount)), ''));
	DECLARE @vIntroduceDate DATE           = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@ProductIntroduceDate)), ''));
	DECLARE @vToday         DATE           = CAST(GETDATE() AS DATE);

	-- Optional date not supplied -> default to today (a supplied but invalid date stays NULL and fails below)
	IF NULLIF(LTRIM(RTRIM(@ProductIntroduceDate)), '') IS NULL
		SET @vIntroduceDate = @vToday;

	BEGIN TRY
			-- Category Id
			IF (@vCategoryId IS NULL)
			BEGIN
				SELECT 'Product Category Id is required and must be a whole number' AS [Message]
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategory WHERE ProductCategoryID = @vCategoryId AND ProductCategoryActiveStatus = 1)
			BEGIN
				SELECT 'INVALID Product Category Id - category does not exist or is inactive' AS [Message]
			END
			-- Product Name
			ELSE IF (@vProductName IS NULL)
			BEGIN
				SELECT 'Product Name is required' AS [Message]
			END
			ELSE IF (PATINDEX('%[^a-zA-Z0-9 .&-]%', @vProductName) > 0) OR (LEN(@vProductName) < 3) OR (LEN(@vProductName) > 50)
			BEGIN
				SELECT 'INVALID Product Name (letters, digits, spaces and . & - only, 3 to 50 characters)' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @vProductName) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Product Name! Invalid Input' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM dbo.[Product] WHERE ProductName = @vProductName AND ProductCategoryId = @vCategoryId)
			BEGIN
				SELECT 'Product ' + QUOTENAME(@vProductName,'''') + ' already exists in this Category' AS [Message]
			END
			-- Price
			ELSE IF (@vPrice IS NULL)
			BEGIN
				SELECT 'Product Price is required and must be a number' AS [Message]
			END
			ELSE IF (@vPrice <= 0) OR (@vPrice > 99999.99)
			BEGIN
				SELECT 'INVALID Product Price (must be greater than 0 and at most 99999.99)' AS [Message]
			END
			-- Available Count
			ELSE IF (@vCount IS NULL)
			BEGIN
				SELECT 'Product Available Count is required and must be a whole number' AS [Message]
			END
			ELSE IF (@vCount < 0)
			BEGIN
				SELECT 'INVALID Product Available Count (must be 0 or more)' AS [Message]
			END
			-- Introduce Date (optional)
			ELSE IF (@vIntroduceDate IS NULL)
			BEGIN
				SELECT 'INVALID Introduce Date - use format yyyy-mm-dd' AS [Message]
			END
			ELSE IF (@vIntroduceDate > @vToday)
			BEGIN
				SELECT 'Product Introduce Date cannot be in the future' AS [Message]
			END
			ELSE IF (@vIntroduceDate < (SELECT ProductCategoryIntroduceDate FROM dbo.ProductCategory WHERE ProductCategoryID = @vCategoryId))
			BEGIN
				SELECT 'Product Introduce Date cannot be before the Category Establish Date' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO dbo.Product(ProductCategoryId, ProductName, ProductPrice, ProductAvailableCount, ProductIntroduceDate)
				VALUES(@vCategoryId, @vProductName, @vPrice, @vCount, @vIntroduceDate)
				SELECT 'Product ' + QUOTENAME(@vProductName,'''') + ' successfully added in the Product Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.'
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO