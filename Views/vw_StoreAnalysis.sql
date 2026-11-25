/**************************************************************
    Script Name         : vw_StoreAnalysis.sql
    Purpose             : Showing the Store analysis based on all the orders
    Created By          : Zeeshan Shaikh
    Created On          : 25/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 25/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER VIEW vw_StoreAnalysis
AS 
	SELECT 
		S.StoreID,
		S.StoreName,
		COUNT(O.OrderID) AS Store_Orders,
		ISNULL(SUM(O.OrderAmount),0) AS Store_GrossTotal,
		ISNULL(CAST(AVG(SCF.StoreRating * 1.0) AS DECIMAL(4,2)),3) AS StoreRating
	FROM dbo.StoreCashierFeedback SCF
	INNER JOIN
	dbo.[Order] O ON O.OrderId = SCF.OrderId
	RIGHT JOIN 
	dbo.Store S ON S.StoreID = O.StoreID
	GROUP BY S.StoreID,S.StoreName
GO

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

SELECT * FROM vw_StoreAnalysis

-- All Stores 
-- RESULT : Pass

------------------------------------------------------------------------------------

SELECT StoreName,StoreRating 
FROM vw_StoreAnalysis

-- Selected Columns only
-- RESULT : Pass

-------------------------------------------------------------------------------------