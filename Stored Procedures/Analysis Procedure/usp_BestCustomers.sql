/**************************************************************
    Script Name         : usp_BestCustomers.sql
    Purpose             : Showing the Customers ranked by the Total Amount
                          spent on Completed Orders
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_BestCustomers
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			RANK() OVER (ORDER BY SUM(O.OrderAmount) DESC) AS Customer_Rank,
			C.CustomerName,
			dbo.fnComputeAge(CustomerDOB) AS CustomerAge,
			SUM(O.OrderAmount) AS TotalSpent,
			COUNT(O.OrderId) AS TotalOrders,
			AVG(O.OrderAmount)  AS AverageOrderValue
		FROM [dbo].[Order] O  
		INNER JOIN [dbo].[Customer] C ON O.CustomerId = C.CustomerId
		WHERE O.OrderStatus = 1
		GROUP BY  C.CustomerName, C.CustomerEmail, C.CustomerPhone,dbo.fnComputeAge(CustomerDOB)				
	END TRY
	BEGIN CATCH
		Select 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO

EXEC Usp_BestCustomers
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_BestCustomers

-- Default
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------