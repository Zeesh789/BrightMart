/**************************************************************
    Script Name         : vw_StoreMonthlySales.sql
    Purpose             : Showing the Gross Sales of every Store for every Month
                          (Jan to Dec) as a PIVOT, one row per Store per Year
    Created By          : Zeeshan Shaikh
    Created On          : 25/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 25/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER VIEW vw_StoreMonthlySales
AS
	SELECT
		StoreName,
		ISNULL([1], 0)  AS [Jan],
		ISNULL([2], 0)  AS [Feb],
		ISNULL([3], 0)  AS [Mar],
		ISNULL([4], 0)  AS [Apr],
		ISNULL([5], 0)  AS [May],
		ISNULL([6], 0)  AS [Jun],
		ISNULL([7], 0)  AS [Jul],
		ISNULL([8], 0)  AS [Aug],
		ISNULL([9], 0)  AS [Sep],
		ISNULL([10], 0) AS [Oct],
		ISNULL([11], 0) AS [Nov],
		ISNULL([12], 0) AS [Dec],
		ISNULL([1], 0) + ISNULL([2], 0) + ISNULL([3], 0) + ISNULL([4], 0)
		+ ISNULL([5], 0) + ISNULL([6], 0) + ISNULL([7], 0) + ISNULL([8], 0)
		+ ISNULL([9], 0) + ISNULL([10], 0) + ISNULL([11], 0) + ISNULL([12], 0) AS YearTotal
	FROM
	(
		SELECT
		S.StoreID,
		S.StoreName,
		MONTH(O.OrderDateTime) AS SalesMonthNumber,
		O.OrderAmount
		FROM 
			dbo.Store S
		LEFT JOIN dbo.[Order] O ON O.StoreID = S.StoreID
			AND O.OrderStatus = 1
	) AS StoreSales
	PIVOT
	(
		SUM(OrderAmount)
		FOR SalesMonthNumber IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
	) AS StoreMonthlyPivot;
GO

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

SELECT * FROM vw_StoreMonthlySales
ORDER BY StoreName
-- All Stores, with Sales, Jan to Dec
-- RESULT : Pass

------------------------------------------------------------------------------------

SELECT StoreName, [Jul], [Aug], [Sep]
FROM vw_StoreMonthlySales
WHERE StoreName = 'DailyMart Andheri'

-- One Store, selected Months only
-- RESULT : Pass

------------------------------------------------------------------------------------
