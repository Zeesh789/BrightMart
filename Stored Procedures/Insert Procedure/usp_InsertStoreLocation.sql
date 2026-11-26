/**************************************************************
    Script Name         : usp_InsertStoreLocation.sql
    Purpose             : Inserting a Store Location in the store location table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
    Modified            : Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertStoreLocation
@LocationArea VARCHAR(52) = NULL,
@StoreAddress VARCHAR(202) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @LocationArea = LTRIM(RTRIM(@LocationArea));
	SET @StoreAddress = LTRIM(RTRIM(@StoreAddress));
	BEGIN TRY
			IF (@LocationArea IS NULL) OR (@LocationArea = '') OR (PATINDEX('%[^a-zA-Z0-9 ]%', @LocationArea) > 0)
			OR (LEN(@LocationArea) < 3) OR (LEN(@LocationArea) > 50)
			BEGIN
				SELECT 'INVALID Location Area (letters and spaces only, 3 to 50 characters)' AS [Message]
			END
			ELSE IF (PATINDEX('[0-9]', @LocationArea) > 0) AND (PATINDEX('[a-zA-Z]', @LocationArea) = 0)
			BEGIN
				SELECT 'Only Numbers are not Valid as Area Location. Please Enter a Valid Input' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @LocationArea) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Location Area! Invalid Input' AS [Message]
			END
			ELSE IF (@StoreAddress IS NULL) OR (@StoreAddress = '') OR (LEN(@StoreAddress) < 10) OR (LEN(@StoreAddress) > 255)
			OR (PATINDEX('%[^a-zA-Z0-9 ,./#-]%', @StoreAddress) > 0)
			BEGIN
				SELECT 'INVALID Store Address (10 to 255 characters; letters, digits, spaces and , . / # - only)' AS [Message]
			END
			ELSE IF (PATINDEX('[0-9]', @StoreAddress) > 0) AND (PATINDEX('[a-zA-Z]', @StoreAddress) = 0)
			BEGIN
				SELECT 'Only Numbers are not Valid as Store Address. Please Enter a Valid Input' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @StoreAddress) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Store Address! Invalid Input' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM dbo.StoreLocation WHERE StoreAddress = @StoreAddress)
			BEGIN
				SELECT 'This Store Address already exists in the Store Location Table' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO dbo.StoreLocation(StoreLocationArea, StoreAddress)
				VALUES(@LocationArea, @StoreAddress)
				SELECT 'Location ' + QUOTENAME(@LocationArea,'''') + ' successfully added in the Store Location Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.'
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO