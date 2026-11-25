/**************************************************************
    Script Name         : usp_MonthOverMonthSalesGrowth.sql
    Purpose             : Showing the Gross Sales of every Month compared
                          with the previous Month, for the whole chain.
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER PROC
usp_MonthOverMonthSalesGrowth
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY			
				WITH MonthOverMonth(SalesMonth,Gross_Sales,Previous_Month_Sales)
				AS
				(
					SELECT
					FORMAT(OrderDateTime, 'yyyy-MM') AS SalesMonth,
					SUM(OrderAmount) AS Gross_Sales,
					LAG(ISNULL(SUM(OrderAmount), 0)) OVER (ORDER BY FORMAT(OrderDateTime, 'yyyy-MM')) AS Previous_Month_Sales
					FROM [dbo].[Order]
					WHERE OrderStatus = 1
					GROUP BY FORMAT(OrderDateTime, 'yyyy-MM')
				),
				MonthOverMonthGross(SalesMonth,Gross_Sales,Previous_Month_Sales,SalesChange,GrowthPercent)
				AS
				(
					SELECT 
					SalesMonth,
					Gross_Sales,
					Previous_Month_Sales,
					MonthOverMonth.Gross_Sales - MonthOverMonth.Previous_Month_Sales AS Sales_Change,
					CAST((MonthOverMonth.Gross_Sales - MonthOverMonth.Previous_Month_Sales) * 100.0
					/ NULLIF(MonthOverMonth.Previous_Month_Sales, 0) AS DECIMAL(5,2)) AS Growth_Percentage
					FROM MonthOverMonth
				)
				SELECT SalesMonth,Gross_Sales,Previous_Month_Sales,SalesChange,GrowthPercent
				FROM MonthOverMonthGross
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO

EXEC Usp_MonthOverMonthSalesGrowth
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_MonthOverMonthSalesGrowth

-- Default
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

