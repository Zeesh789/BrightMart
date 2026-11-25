/**************************************************************
    Script Name         : usp_InsertStore.sql
    Purpose             : Inserting a Store in the store table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
    Modified            : Version 2 - parameters accepted as NULL-able text,
                          converted with TRY_CONVERT into typed variables
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertStore
@StoreName       NVARCHAR(500) = NULL,    -- required
@StoreLocationId NVARCHAR(50)  = NULL,    -- required (INT)
@StoreManagerId  NVARCHAR(50)  = NULL,    -- optional (INT)
@EstablishDate   NVARCHAR(50)  = NULL     -- optional (DATE, yyyy-mm-dd) : defaults to today
AS
BEGIN
	SET NOCOUNT ON;

	/*---------- Convert inputs to required datatypes ----------*/
	DECLARE @vStoreName       VARCHAR(500) = TRY_CONVERT(VARCHAR(500), NULLIF(LTRIM(RTRIM(@StoreName)), ''));
	DECLARE @vStoreLocationId INT          = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@StoreLocationId)), ''));
	DECLARE @vStoreManagerId  INT          = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@StoreManagerId)), ''));
	DECLARE @vEstablishDate   DATE         = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@EstablishDate)), ''));
	DECLARE @vToday           DATE         = CAST(GETDATE() AS DATE);

	-- Optional date not supplied -> default to today (a supplied but invalid date stays NULL and fails below)
	IF NULLIF(LTRIM(RTRIM(@EstablishDate)), '') IS NULL
		SET @vEstablishDate = @vToday;

	BEGIN TRY
			-- Store Name
			IF (@vStoreName IS NULL)
			BEGIN
				SELECT 'Store Name is required' AS [Message]
			END
			ELSE IF (PATINDEX('%[^a-zA-Z0-9 &-]%', @vStoreName) > 0) OR (LEN(@vStoreName) < 3) OR (LEN(@vStoreName) > 50)
			BEGIN
				SELECT 'INVALID Store Name (letters, digits, spaces, & and - only, 3 to 50 characters)' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @vStoreName) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Store Name! Invalid Input' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM Store WHERE StoreName = @vStoreName)
			BEGIN
				SELECT 'Store ' + QUOTENAME(@vStoreName,'''') + ' already exists in the Store Table' AS [Message]
			END
			-- Store Location Id
			ELSE IF (@vStoreLocationId IS NULL)
			BEGIN
				SELECT 'Store Location Id is required and must be a whole number' AS [Message]
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM StoreLocation WHERE StoreLocationId = @vStoreLocationId)
			BEGIN
				SELECT 'INVALID Store Location Id - location does not exist' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM Store WHERE StoreLocationId = @vStoreLocationId AND StoreActiveStatus = 1)
			BEGIN
				SELECT 'An active store already exists at Store Location Id ' + CAST(@vStoreLocationId AS VARCHAR(10)) AS [Message]
			END
			-- Store Manager Id (optional)
			ELSE IF (NULLIF(LTRIM(RTRIM(@StoreManagerId)), '') IS NOT NULL) AND (@vStoreManagerId IS NULL)
			BEGIN
				SELECT 'INVALID Store Manager Id - must be a whole number' AS [Message]
			END
			ELSE IF (@vStoreManagerId IS NOT NULL)
			AND NOT EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeeId = @vStoreManagerId AND EmployeeActiveStatus = 1)
			BEGIN
				SELECT 'INVALID Store Manager Id - employee does not exist or is inactive' AS [Message]
			END
			ELSE IF (@vStoreManagerId IS NOT NULL)
			AND EXISTS (SELECT 1 FROM Store WHERE StoreManagerId = @vStoreManagerId AND StoreActiveStatus = 1)
			BEGIN
				SELECT 'Employee ' + CAST(@vStoreManagerId AS VARCHAR(10)) + ' is already managing another active store' AS [Message]
			END
			-- Establish Date (optional)
			ELSE IF (@vEstablishDate IS NULL)
			BEGIN
				SELECT 'INVALID Establish Date - use format yyyy-mm-dd' AS [Message]
			END
			ELSE IF (@vEstablishDate > @vToday)
			BEGIN
				SELECT 'Store Establish Date cannot be in the future' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO Store(StoreName, StoreLocationId, StoreManagerId, StoreEstablishDate)
				VALUES(@vStoreName, @vStoreLocationId, @vStoreManagerId, @vEstablishDate)
				SELECT 'Store ' + QUOTENAME(@vStoreName,'''') + ' successfully added in the Store Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO