/**************************************************************
    Script Name         : usp_SalesByMonth.sql
    Purpose             : Showing the Gross Sales of every Month or of
                          one Month if the Month is provided
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1
    Note                : Month is passed in 'MM-YYYY' format (e.g. '09-2026').
****************************************************************/

CREATE OR ALTER PROC
usp_SalesByMonth
@Month VARCHAR(7) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Month_Start DATE;
	BEGIN TRY
		-- Rearrange 'MM-YYYY' into 'YYYY-MM-01' so it converts to a date
		IF (@Month LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9]')
			SET @Month_Start = TRY_CONVERT(DATE, RIGHT(@Month, 4) + '-' + LEFT(@Month, 2) + '-01', 23);

		IF (@Month IS NOT NULL) AND (@Month_Start IS NULL)
			BEGIN
				SELECT 'Invalid Month! Month must be in MM-YYYY format' AS [Message]
			END;
		ELSE IF (@Month_Start IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.[Order]
								WHERE OrderStatus = 1
								AND OrderDateTime >= @Month_Start AND OrderDateTime < DATEADD(MONTH, 1, @Month_Start))
			BEGIN
				SELECT 'No Sales found for Month ' + QUOTENAME(@Month,'''') AS [Message]
			END;
		ELSE
			BEGIN
				WITH SalesByMonth(Sales_Rank,Month_Name,Gross_Sales)
				AS
				(
					SELECT
						RANK() OVER (ORDER BY SUM(OrderAmount) DESC) AS Sales_Rank,
						FORMAT(DATEFROMPARTS(YEAR(OrderDateTime), MONTH(OrderDateTime), 1), 'MMMM yyyy') AS Month_Name,
						SUM(OrderAmount) AS Gross_Sales
					FROM dbo.[Order]
					WHERE OrderStatus = 1 
					GROUP BY DATEFROMPARTS(YEAR(OrderDateTime), MONTH(OrderDateTime), 1)
				)
				SELECT 
				Sales_Rank,
				Month_Name,
				Gross_Sales
				FROM SalesByMonth
				WHERE (@Month IS NULL) OR (Month_Name = @Month_Start)
				ORDER BY Sales_Rank,Month_Name
			END;
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO

EXEC Usp_SalesByMonth
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth

-- No Month (All Months shown)
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = '07-2026'

-- Valid Month (Only July 2026 shown with its Rank)
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = '9-2026'

-- Month without leading zero
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = '2026-09'

-- Month in wrong format
-- RESULT : TEST CASE 4 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = '13-2026'

-- Month which does not exist
-- RESULT : TEST CASE 5 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = 'abc'

-- Character in Month parameter
-- RESULT : TEST CASE 6 PASS

------------------------------------------------------------------------------------

EXEC Usp_SalesByMonth @Month = '01-2025'

-- Month with no Sales
-- RESULT : TEST CASE 7 PASS

------------------------------------------------------------------------------------


EXEC Usp_SalesByMonth @Month = ''

-- Empty String -> Treated as Invalid Month
-- RESULT : TEST CASE 7 PASS

------------------------------------------------------------------------------------
