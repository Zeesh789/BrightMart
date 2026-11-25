/**************************************************************
    Script Name         : usp_RepeatedCustomers.sql
    Purpose             : Showing the Customer Details who have bought multiple times.
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1

****************************************************************/

CREATE OR ALTER PROC 
usp_RepeatedCustomers
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		SELECT 
		Customer.CustomerId,
		Customer.CustomerName,
		Customer.CustomerAge,
		Customer.[Total Orders],
		Customer.[Order Total]
		FROM 
		(
			SELECT C.CustomerId,
			C.CustomerName,
			dbo.fnComputeAge(C.CustomerDOB) AS CustomerAge,
			SUM(CASE WHEN OrderStatus = 1 THEN 1 ELSE 0 END) AS [Total Orders],
			SUM(CASE WHEN OrderStatus = 1 THEN O.OrderAmount ELSE 0 END) AS [Order Total]
			FROM
			dbo.[Order] O			
			INNER JOIN
			dbo.Customer C ON O.CustomerID = C.CustomerID
			GROUP BY C.CustomerId,C.CustomerName, dbo.fnComputeAge(C.CustomerDOB)		
		) Customer 
		WHERE [Total Orders] > 1
		ORDER BY [Total Orders] DESC ,[Order Total] DESC
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

EXEC usp_RepeatedCustomers


------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_RepeatedCustomers

-- Default
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------
