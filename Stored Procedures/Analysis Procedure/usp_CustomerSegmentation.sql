/**************************************************************
    Script Name         : usp_CustomerSegmentation.sql
    Purpose             : Displaying the Customer Segmentation based on the value of the Order Placed
    Created By          : Zeeshan Shaikh
    Created On          : 16/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 16/11/26
    Modified            : Version 1
	Note				: Order Amount < 500 -> Low Sale Order
						  Order Amount >= 500 & Order Amount < 1000 ->  Medium Sale Order
						  Order Amount >= 1000 -> High Sale Order

****************************************************************/

CREATE OR ALTER PROC usp_CustomerSegmentation
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
		'Low Sale Order' As Category,
		COUNT(CASE WHEN OrderAmount < 500 THEN 1 END) AS CustomerOrdersCount
		FROM [dbo].[Order] O
		WHERE O.OrderStatus = 1

		UNION ALL

		SELECT
		'Medium Sale Order' AS Category,
		COUNT(CASE WHEN OrderAmount >= 500 AND OrderAmount < 1000 THEN 1 END) AS CustomerOrdersCount
		FROM [dbo].[Order] O
		WHERE O.OrderStatus = 1

		UNION ALL

		SELECT 
		'High Sale Order' AS Category,
		COUNT(CASE WHEN OrderAmount >= 1000 THEN 1 END) AS CustomerOrdersCount
		FROM [dbo].[Order] O
		WHERE O.OrderStatus = 1
		ORDER BY CustomerOrdersCount DESC
		

	END TRY
	BEGIN CATCH 
		SELECT
		ERROR_NUMBER() as ErrorNumber,
		ERROR_MESSAGE() as ErrorMessage,
		ERROR_PROCEDURE() as ErrorProcedure,
		ERROR_STATE() as ErrorState,
		ERROR_SEVERITY() as ErrorSeverity,
		ERROR_LINE() as ErrorLine
	END CATCH;
END;
GO

EXEC usp_CustomerSegmentation

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_CustomerSegmentation

-- Default
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------


