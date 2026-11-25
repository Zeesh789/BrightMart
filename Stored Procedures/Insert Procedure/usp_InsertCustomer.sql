/**************************************************************
    Script Name         : usp_InsertCustomer.sql
    Purpose             : Inserting a Customer in the customer table
    Created By          : Zeeshan Shaikh
    Created On          : 20/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 20/11/26
    Modified            : Version 2 - parameters accepted as NULL-able text,
                          converted with TRY_CONVERT into typed variables,
                          age must be 5 to 75 on register date
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_InsertCustomer
@CustomerName         NVARCHAR(50) = NULL,   -- required
@CustomerPhone        NVARCHAR(10)  = NULL,   -- required
@CustomerEmail        NVARCHAR(100) = NULL,   -- optional
@CustomerGender       NVARCHAR(10)  = NULL,   -- optional
@CustomerDOB          NVARCHAR(10)  = NULL,   -- optional (DATE, yyyy-mm-dd)
@CustomerRegisterDate NVARCHAR(12)  = NULL    -- optional (DATE, yyyy-mm-dd) : defaults to today
AS
BEGIN
	SET NOCOUNT ON;

	/*---------- Convert inputs to required datatypes ----------*/
	DECLARE @vName         VARCHAR(50) = TRY_CONVERT(VARCHAR(50), NULLIF(LTRIM(RTRIM(@CustomerName)), ''));
	DECLARE @vPhone        VARCHAR(10)  = TRY_CONVERT(VARCHAR(10), NULLIF(LTRIM(RTRIM(@CustomerPhone)), ''));
	DECLARE @vEmail        VARCHAR(100) = TRY_CONVERT(VARCHAR(100), NULLIF(LOWER(LTRIM(RTRIM(@CustomerEmail))), ''));
	DECLARE @vGender       VARCHAR(10)  = TRY_CONVERT(VARCHAR(10), NULLIF(LTRIM(RTRIM(@CustomerGender)), ''));
	DECLARE @vDOB          DATE         = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@CustomerDOB)), ''));
	DECLARE @vRegisterDate DATE         = TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(@CustomerRegisterDate)), ''));
	DECLARE @vToday        DATE         = CAST(GETDATE() AS DATE);
	DECLARE @vAge          INT;

	-- Optional register date not supplied -> default to today (a supplied but invalid date stays NULL and fails below)
	IF NULLIF(LTRIM(RTRIM(@CustomerRegisterDate)), '') IS NULL
		SET @vRegisterDate = @vToday;

	-- Exact age in completed years on the register date (NULL when DOB not given)
	SET @vAge = DATEDIFF(YEAR, @vDOB, @vRegisterDate)
				- CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @vDOB, @vRegisterDate), @vDOB) > @vRegisterDate THEN 1 ELSE 0 END;

	BEGIN TRY
			-- Name
			IF (@vName IS NULL)
			BEGIN
				SELECT 'Customer Name is required' AS [Message]
			END
			ELSE IF (PATINDEX('%[^a-zA-Z ]%', @vName) > 0) OR (LEN(@vName) < 3) OR (LEN(@vName) > 50)
			BEGIN
				SELECT 'INVALID Customer Name (letters and spaces only, 3 to 50 characters)' AS [Message]
			END
			ELSE IF (CHARINDEX('  ', @vName) > 0)
			BEGIN
				SELECT 'Consecutive Spaces Not Allowed in Customer Name! Invalid Input' AS [Message]
			END
			-- Phone (10 digit Indian mobile starting 6-9)
			ELSE IF (@vPhone IS NULL)
			BEGIN
				SELECT 'Customer Phone is required' AS [Message]
			END
			ELSE IF (LEN(@vPhone) <> 10) OR (PATINDEX('%[^0-9]%', @vPhone) > 0) OR (LEFT(@vPhone, 1) NOT IN ('6', '7', '8', '9'))
			BEGIN
				SELECT 'INVALID Phone Number (10 digits, starting with 6-9)' AS [Message]
			END
			ELSE IF EXISTS (SELECT 1 FROM Customer WHERE CustomerPhone = @vPhone AND CustomerActiveStatus = 1)
			BEGIN
				SELECT 'An active customer with Phone ' + QUOTENAME(@vPhone,'''') + ' already exists' AS [Message]
			END
			-- Email (optional)
			ELSE IF (@vEmail IS NOT NULL)
			AND ((@vEmail NOT LIKE '%_@_%._%') OR (LEN(@vEmail) > 255) OR (CHARINDEX(' ', @vEmail) > 0)
				 OR (LEN(@vEmail) - LEN(REPLACE(@vEmail, '@', '')) <> 1))
			BEGIN
				SELECT 'INVALID Email Address' AS [Message]
			END
			ELSE IF (@vEmail IS NOT NULL)
			AND EXISTS (SELECT 1 FROM Customer WHERE CustomerEmail = @vEmail AND CustomerActiveStatus = 1)
			BEGIN
				SELECT 'An active customer with Email ' + QUOTENAME(@vEmail,'''') + ' already exists' AS [Message]
			END
			-- Gender (optional)
			ELSE IF (@vGender IS NOT NULL) AND (@vGender NOT IN ('Male', 'Female', 'Other'))
			BEGIN
				SELECT 'INVALID Gender (allowed: Male, Female, Other)' AS [Message]
			END
			-- Register Date (optional)
			ELSE IF (@vRegisterDate IS NULL)
			BEGIN
				SELECT 'INVALID Register Date - use format yyyy-mm-dd' AS [Message]
			END
			ELSE IF (@vRegisterDate > @vToday)
			BEGIN
				SELECT 'Customer Register Date cannot be in the future' AS [Message]
			END
			-- DOB (optional) : supplied but not a valid date
			ELSE IF (NULLIF(LTRIM(RTRIM(@CustomerDOB)), '') IS NOT NULL) AND (@vDOB IS NULL)
			BEGIN
				SELECT 'INVALID DOB - use format yyyy-mm-dd' AS [Message]
			END
			-- DOB (optional) : age must be 5 to 75 on register date
			ELSE IF (@vDOB IS NOT NULL) AND ((@vAge < 5) OR (@vAge > 75))
			BEGIN
				SELECT 'INVALID DOB - customer age must be between 5 and 75 (age: '
					   + CAST(@vAge AS VARCHAR(10)) + ')' AS [Message]
			END
			ELSE
			BEGIN
				INSERT INTO Customer(CustomerName, CustomerEmail, CustomerPhone, CustomerGender, CustomerDOB, CustomerRegisterDate)
				VALUES(@vName, @vEmail, @vPhone, @vGender, @vDOB, @vRegisterDate)
				SELECT 'Customer ' + QUOTENAME(@vName,'''') + ' successfully added in the Customer Table with ID '
					   + CAST(SCOPE_IDENTITY() AS VARCHAR(10)) AS [Message]
			END
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.'
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH
END
GO