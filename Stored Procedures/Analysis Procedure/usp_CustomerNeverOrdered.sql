/**************************************************************
    Script Name         : usp_CustomerNeverOrdered.sql
    Purpose             : Showing the Customer details of the ones who haven't placed a completed order
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/
CREATE OR ALTER PROC
usp_CustomerNeverOrdered
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SELECT 
		C.CustomerName,
		dbo.fnComputeAge(C.CustomerDOB) AS CustomerAge,
		C.CustomerGender
		FROM
		[dbo].[Customer] C
		LEFT JOIN
		[dbo].[Order] O ON O.CustomerId = C.CustomerId
		AND O.OrderStatus = 1 AND CustomerActiveStatus = 1
		WHERE O.CustomerId IS NULL 
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

SELECT * FROM Customer

EXEC usp_CustomerNeverOrdered

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_CustomerNeverOrdered

-- Default Case
-- RESULT : Pass

------------------------------------------------------------------------------------