/**************************************************************
    Script Name         : usp_RunningSalesTotal.sql
    Purpose             : Showing the running sales total of all the orders placed
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1

****************************************************************/
CREATE OR ALTER PROC
usp_RunningSalesTotal
@Sales_Month VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Sales_Month_To_Process DATE;
	BEGIN TRY
		-- Rearrange 'MM-YYYY' into 'YYYY-MM-01' so it converts to a date
		IF (@Sales_Month LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9]')
			SET @Sales_Month_To_Process = TRY_CONVERT(DATE, RIGHT(@Sales_Month, 4) + '-' + LEFT(@Sales_Month, 2) + '-01', 23);

		IF (@Sales_Month IS NOT NULL) AND (@Sales_Month_To_Process IS NULL)
			BEGIN
				SELECT 'Invalid Month! Month must be in MM-YYYY format' AS [Message]
			END;
		ELSE IF (@Sales_Month_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM [Order]
								WHERE OrderStatus = 1
								AND OrderDateTime >= @Sales_Month_To_Process AND OrderDateTime < DATEADD(MONTH, 1, @Sales_Month_To_Process))
			BEGIN
				SELECT 'No Sales found for Month ' + QUOTENAME(@Sales_Month,'''') AS [Message]
			END;
		ELSE
			BEGIN
				SELECT
					OrderID,
					FORMAT(OrderDateTime, 'MM-yyyy') AS Sales_Month,
					OrderAmount AS Gross_Sales,
					SUM(OrderAmount) OVER (ORDER BY OrderDateTime, OrderID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
				FROM dbo.[Order]
				WHERE OrderStatus = 1
				AND ((@Sales_Month_To_Process IS NULL)
					 OR (OrderDateTime >= @Sales_Month_To_Process AND OrderDateTime < DATEADD(MONTH, 1, @Sales_Month_To_Process)))
				ORDER BY OrderDateTime, OrderID
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

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal

-- No Month (All Months shown)
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = '07-2026'

-- Valid Month (Only July 2026 shown, Running Total starts from July)
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = '9-2026'

-- Month without leading zero -> 'Invalid Month! Month must be in MM-YYYY format'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = '2026-09'

-- Month in old YYYY-MM format -> 'Invalid Month! Month must be in MM-YYYY format'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = '13-2026'

-- Month which does not exist -> 'Invalid Month! Month must be in MM-YYYY format'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = 'abc'

-- Character in Month parameter -> 'Invalid Month! Month must be in MM-YYYY format'
-- RESULT : PASS
 
------------------------------------------------------------------------------------

EXEC usp_RunningSalesTotal @Sales_Month = '01-2025'

-- Month with no Sales -> 'No Sales found for Month '01-2025''
-- RESULT : PASS

------------------------------------------------------------------------------------