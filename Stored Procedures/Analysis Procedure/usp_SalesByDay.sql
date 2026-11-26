/**************************************************************
    Script Name         : usp_SalesByDay.sql
    Purpose             : Showing the Gross Sales of every Day of the Week
                          (Monday to Sunday) or of one Day if the Day is provided
    Created By          : Zeeshan Shaikh
    Created On          : 17/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 17/11/26
    Modified            : Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_SalesByDay
@Day VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Day_Name VARCHAR(10);
	BEGIN TRY
		-- Match the input to a Day ('monday' = 'Monday')
		SELECT @Day_Name = CASE WHEN UPPER(LTRIM(RTRIM(@Day))) = 'MONDAY' THEN 'Monday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'TUESDAY' THEN 'Tuesday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'WEDNESDAY' THEN 'Wednesday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'THURSDAY' THEN 'Thursday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'FRIDAY' THEN 'Friday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'SATURDAY' THEN 'Saturday'
									WHEN UPPER(LTRIM(RTRIM(@Day))) = 'SUNDAY' THEN 'Sunday' END

		IF (@Day IS NOT NULL) AND (@Day_Name IS NULL)
			BEGIN
				SELECT 'Invalid Day! Day must be the full name of the Day (Monday to Sunday)' AS [Message]
			END
		ELSE IF NOT EXISTS (SELECT 1 FROM dbo.[Order] WHERE OrderStatus = 1)
			BEGIN
				SELECT  'No Sales found' AS [Message]
			END
		ELSE IF (@Day_Name IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.[Order]
								WHERE OrderStatus = 1
								AND DATENAME(WEEKDAY,OrderDateTime) = @Day_Name)
			BEGIN
				SELECT 'No Sales found for ' + QUOTENAME(@Day_Name,'''') AS [Message]
			END
		ELSE
			BEGIN
				WITH SalesByDay(SalesRank,[Day],GrossSales)
				AS
				(
					SELECT
						DENSE_RANK() OVER (ORDER BY ISNULL(SUM(OrderAmount), 0) DESC) AS SalesRank,				
						DATENAME(WEEKDAY,OrderDateTime) AS [Day],
						ISNULL(SUM(OrderAmount), 0) AS GrossSales
					FROM dbo.[Order]
					WHERE OrderStatus = 1
					GROUP BY DATENAME(WEEKDAY,OrderDateTime)
				)
				SELECT 
					SalesRank,
					[Day],
					GrossSales 
				FROM SalesByDay
				WHERE (@Day IS NULL) OR ([Day] = @Day_Name)
				ORDER BY SalesRank
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

EXEC Usp_SalesByDay

-- No Parameters (All 7 Days, Monday to Sunday, with Sales_Rank)
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = 'Sunday'

-- Only Sunday row, with its Rank 
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = 'monday'

-- Lower case input -> matched to 'Monday'
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = 'Fri'

-- Short name not allowed -> 'Invalid Day! Day must be the full name of the Day (Monday to Sunday)'
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = 'Funday'

-- Invalid Day -> 'Invalid Day! Day must be the full name of the Day (Monday to Sunday)'
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = ''

-- Empty string treated as Invalid Input
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = '  monday    '

-- Leading and trialing spaces -> matched to 'Monday'
-- RESULT : Pass

------------------------------------------------------------------------------------

EXEC Usp_SalesByDay @Day = 1

-- Entering Int into the variable -> Invalid Input
-- RESULT : Pass

------------------------------------------------------------------------------------