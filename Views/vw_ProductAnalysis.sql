/**************************************************************
    Script Name         : vw_ProductAnalysis.sql
    Purpose             : Showing the Store analysis based on all the orders
    Created By          : Zeeshan Shaikh
    Created On          : 25/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 25/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER VIEW
vw_ProductAnalysis
AS
						SELECT
							P.ProductID,
							P.ProductName,
							PC.ProductCategoryName,
							ProductSold.UnitsSold,
							ISNULL(Returned.UnitsReturned, 0) AS UnitsReturned,
							SUM(P.ProductPrice * ProductSold.UnitsSold ) - 
							SUM(P.ProductPrice * ISNULL(Returned.UnitsReturned, 0)) AS [Net Sales]
						FROM
						(-- Units sold per Product (Completed Orders only)
							SELECT
								OP.ProductID,
								SUM(OP.ProductOrderCount) AS UnitsSold
							FROM 
							dbo.OrderProduct OP
							INNER JOIN 
							dbo.[Order] O ON O.OrderID = OP.OrderID
							WHERE O.OrderStatus = 1
							GROUP BY OP.ProductID
						) AS ProductSold
						LEFT JOIN
						(-- Units returned per Product
							SELECT
								RP.ProductID,
								SUM(RP.ProductReturnCount) AS UnitsReturned
							FROM dbo.ReturnProduct RP
							GROUP BY RP.ProductID
						) AS Returned
						ON Returned.ProductID = ProductSold.ProductID
						INNER JOIN 
						dbo.[Product] P 
						ON P.ProductID = ProductSold.ProductID
						INNER JOIN 
						dbo.ProductCategory PC 
						ON PC.ProductCategoryID = P.ProductCategoryID
						GROUP BY 
						P.ProductID,
						P.ProductName,
						PC.ProductCategoryName,
						ProductSold.UnitsSold,
						ISNULL(Returned.UnitsReturned, 0)

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

SELECT * FROM vw_ProductAnalysis
ORDER BY ProductID

-- All Products
-- RESULT : Pass

------------------------------------------------------------------------------------

SELECT * FROM vw_ProductAnalysis
WHERE ProductCategoryName = 'Beverages'

-- Products from a single Category
-- RESULT : Pass

------------------------------------------------------------------------------------
SELECT TOP 10 * FROM vw_ProductAnalysis
ORDER BY [Net Sales] DESC

-- Top 10 Products based on Sales
-- RESULT : Pass

------------------------------------------------------------------------------------*/