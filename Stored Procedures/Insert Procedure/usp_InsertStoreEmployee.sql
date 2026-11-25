/**************************************************************
    Script Name         : usp_InsertStoreEmployee.sql
    Purpose             : Inserting an Employee in the store employee table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
    Modified            : Version 2 - parameters accepted as NULL-able text,
                          converted with TRY_CONVERT into typed variables,
                          age must be 18 to 60 on join date
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertStoreEmployee
@EmployeeStoreId      NVARCHAR(50)  = NULL,   -- required (INT)
@EmployeeName         NVARCHAR(500) = NULL,   -- required
@EmployeeGender       NVARCHAR(50)  = NULL,   -- required
@EmployeeDOB          NVARCHAR(50)  = NULL,   -- required (DATE, yyyy-mm-dd)
@EmployeeEmail        NVARCHAR(500) = NULL,   -- required
@EmployeePhone        NVARCHAR(50)  = NULL,   -- required
@EmployeeGovernmentId NVARCHAR(50)  = NULL,   -- required
@EmployeeJoinDate     NVARCHAR(50)  = NULL    -- optional (DATE, yyyy-mm-dd) : defaults to today
AS
BEGIN
	SET NOCOUNT ON;

	/*---------- Convert inputs to required datatypes ----------*/
	DECLARE @vStoreId      INT          = TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(@EmployeeStoreId)), ''));
	DECLARE @vName         VARCHAR(500) = TRY_CONVERT(VARCHAR(500), NULLIF(LTRIM(RTRIM(@EmployeeName)), ''));
	DECLARE @vGender       VARCHAR(50)  = TRY_CONVERT(VARCHAR(50), NULLIF(LTRIM(RTRIM(@EmployeeGender)), ''));
	DECLARE @vDOB          DATE         = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@EmployeeDOB)), ''));
	DECLARE @vEmail        VARCHAR(500) = TRY_CONVERT(VARCHAR(500), NULLIF(LOWER(LTRIM(RTRIM(@EmployeeEmail))), ''));
	DECLARE @vPhone        VARCHAR(50)  = TRY_CONVERT(VARCHAR(50), NULLIF(LTRIM(RTRIM(@EmployeePhone)), ''));
	DECLARE @vGovernmentId VARCHAR(50)  = TRY_CONVERT(VARCHAR(50), NULLIF(UPPER(LTRIM(RTRIM(@EmployeeGovernmentId))), ''));
	DECLARE @vJoinDate     DATE         = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@EmployeeJoinDate)), ''));
	DECLARE @vToday        DATE         = CAST(GETDATE() AS DATE);
	DECLARE @vAge          INT;

	-- Optional join date not supplied -> default to today (a supplied but invalid date stays NULL and fails below)
	IF NULLIF(LTRIM(RTRIM(@EmployeeJoinDate)), '') IS NULL
		SET @vJoinDate = @vToday;

	-- Exact age in completed years on the join date
	SET @vAge = DATEDIFF(YEAR, @vDOB, @vJoinDate)
				- CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @vDOB, @vJoinDate), @vDOB) > @vJoinDate THEN 1 ELSE 0 END;

	BEGIN TRY
			-- Store Id
			IF (@vStoreId IS NULL)
			BEGIN
				SELECT 'Store Id is required and must be a whole number' AS [Message]
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM Store WHERE StoreId = @vStoreId AND StoreActiveStatus = 1)
			BEGIN
				SELECT 'INVALID Store Id - store does not exist or is inactive' AS [Message]
			END
			-- Name
			ELSE IF (@vName IS NULL)
			BEGIN
				SELECT 'Employee Name is required' AS [Message]
			END
			ELSE IF (PATINDEX('%[^a-zA-Z ]%', @vName) > 0) OR (LEN(@vName) < 3) OR (LEN(@vName) > 50)
			BEGIN
				SELECT 'INVALID Employee Name (letters and spaces only, 3 to 50 characters)' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @vName) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Employee Name! Invalid Input' AS [Message]
			END
			-- Gender
			ELSE IF (@vGender IS NULL)
			BEGIN
				SELECT 'Employee Gender is required' AS [Message]
			END
			ELSE IF (@vGender NOT IN ('Male', 'Female', 'Other'))
			BEGIN
				SELECT 'INVALID Gender (allowed: Male, Female, Other)' AS [Message]
			END
			-- Join Date (optional)
			ELSE IF (@vJoinDate IS NULL)
			BEGIN
				SELECT 'INVALID Join Date - use format yyyy-mm-dd' AS [Message]
			END
			ELSE IF (@vJoinDate > @vToday)
			BEGIN
				SELECT 'Employee Join Date cannot be in the future' AS [Message]
			END
			ELSE IF (@vJoinDate < (SELECT StoreEstablishDate FROM Store WHERE StoreId = @vStoreId))
			BEGIN
				SELECT 'Employee Join Date cannot be before the Store Establish Date' AS [Message]
			END
			-- Date of Birth (age 18 to 60 on join date)
			ELSE IF (@vDOB IS NULL)
			BEGIN
				SELECT 'Employee DOB is required and must be a valid date (yyyy-mm-dd)' AS [Message]
			END
			ELSE IF (@vAge < 18) OR (@vAge > 60)
			BEGIN
				SELECT 'INVALID DOB - employee age must be between 18 and 60 on the Join Date (age: '
					   + CAST(@vAge AS VARCHAR(10)) + ')' AS [Message]
			END
			-- Email
			ELSE IF (@vEmail IS NULL)
			BEGIN
				SELECT 'Employee Email is required' AS [Message]
			END
			ELSE IF (@vEmail NOT LIKE '%_@_%._%') OR (LEN(@vEmail) > 255) OR (CHARINDEX(' ', @vEmail) > 0)
			OR (LEN(@vEmail) - LEN(REPLACE(@vEmail, '@', '')) <> 1)
			BEGIN
				SELECT 'INVALID Email Address' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeeEmail = @vEmail)
			BEGIN
				SELECT 'Email ' + QUOTENAME(@vEmail,'''') + ' already exists in the Store Employee Table' AS [Message]
			END
			-- Phone (10 digit Indian mobile starting 6-9)
			ELSE IF (@vPhone IS NULL)
			BEGIN
				SELECT 'Employee Phone is required' AS [Message]
			END
			ELSE IF (LEN(@vPhone) <> 10) OR (PATINDEX('%[^0-9]%', @vPhone) > 0) OR (LEFT(@vPhone, 1) NOT IN ('6', '7', '8', '9'))
			BEGIN
				SELECT 'INVALID Phone Number (10 digits, starting with 6-9)' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeePhone = @vPhone)
			BEGIN
				SELECT 'Phone ' + QUOTENAME(@vPhone,'''') + ' already exists in the Store Employee Table' AS [Message]
			END
			-- Government Id
			ELSE IF (@vGovernmentId IS NULL)
			BEGIN
				SELECT 'Employee Government Id is required' AS [Message]
			END
			ELSE IF (LEN(@vGovernmentId) < 8) OR (LEN(@vGovernmentId) > 15) OR (PATINDEX('%[^A-Z0-9]%', @vGovernmentId) > 0)
			BEGIN
				SELECT 'INVALID Government Id (letters and digits only, 8 to 15 characters)' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeeGovernmentId = @vGovernmentId)
			BEGIN
				SELECT 'This Government Id already exists in the Store Employee Table' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO StoreEmployee(EmployeeStoreId, EmployeeName, EmployeeGender, EmployeeDOB, EmployeeEmail,
										  EmployeePhone, EmployeeGovernmentId, EmployeeJoinDate)
				VALUES(@vStoreId, @vName, @vGender, @vDOB, @vEmail, @vPhone, @vGovernmentId, @vJoinDate)
				SELECT 'Employee ' + QUOTENAME(@vName,'''') + ' successfully added in the Store Employee Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
		IF ERROR_NUMBER() IN (2627, 2601)
			SELECT 'Duplicate Email, Phone or Government Id - employee already exists' AS [Message]
		ELSE
			SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO