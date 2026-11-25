/**************************************************************
    Script Name         : usp_ProcessPayment.sql
    Purpose             : Processing the Payment of a Pending Order.
                          Every Payment attempt is saved in the
                          OrderTransaction table as Success or Failed.
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER PROC
Usp_ProcessPayment
@Order_Id VARCHAR(5) = NULL,
@Payment_Type VARCHAR(10) = NULL,
@Payment_Result VARCHAR(10) = NULL,
@Transaction_Date_Time VARCHAR(25) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Order_Id_To_Process INT
	DECLARE @Payment_Type_To_Process VARCHAR(5)
	DECLARE @Transaction_Date_Time_To_Process DATETIME
	DECLARE @Order_Amount DECIMAL(9,2)
	DECLARE @Order_Status TINYINT
	DECLARE @Order_Date_Time DATETIME
	BEGIN TRY
		BEGIN TRAN
			SET @Order_Id_To_Process = TRY_CONVERT(INT,@Order_Id)
			SET @Payment_Type_To_Process = CASE LOWER(@Payment_Type) WHEN 'cash' THEN 'Cash'
																	 WHEN 'card' THEN 'Card'
																	 WHEN 'upi' THEN 'UPI' END
			SET @Transaction_Date_Time_To_Process = CASE WHEN @Transaction_Date_Time IS NULL THEN GETDATE()
														 WHEN LTRIM(@Transaction_Date_Time) = '' THEN NULL
														 ELSE TRY_CONVERT(DATETIME,@Transaction_Date_Time,120) END

			SELECT @Order_Amount = OrderAmount, @Order_Status = OrderStatus, @Order_Date_Time = OrderDateTime
			FROM dbo.[Order]
			WHERE OrderID = @Order_Id_To_Process


			IF (@Order_Id_To_Process IS NULL) OR (@Payment_Type IS NULL) OR (@Payment_Result IS NULL)
				OR (@Payment_Type = '') OR (@Payment_Result = '') OR (@Transaction_Date_Time_To_Process IS NULL)
				BEGIN
					SELECT 'Invalid Input Values' AS [Message]
				END
			ELSE IF (@Order_Status IS NULL)
				BEGIN
					SELECT 'Order ' + QUOTENAME(@Order_Id,'''') + ' does not exist' AS [Message]
				END
			ELSE IF (@Order_Status = 1)
				BEGIN
					SELECT 'Order ' + QUOTENAME(@Order_Id,'''') + ' is already Paid' AS [Message]
				END
			ELSE IF (@Order_Status != 5)
				BEGIN
					SELECT 'Order ' + QUOTENAME(@Order_Id,'''') + ' is not Pending in the Queue' AS [Message]
				END
			ELSE IF (@Payment_Type_To_Process IS NULL)
				BEGIN
					SELECT 'Invalid Payment Type! Only Cash, Card or UPI allowed' AS [Message]
				END
			ELSE IF (LOWER(@Payment_Result) != 'success') AND (LOWER(@Payment_Result) != 'failed')
				BEGIN
					SELECT 'Invalid Payment Result! Only Success or Failed allowed' AS [Message]
				END
			ELSE IF (@Transaction_Date_Time_To_Process > GETDATE())
				BEGIN
					SELECT 'Transaction Date ' + QUOTENAME(@Transaction_Date_Time,'''') + ' cannot be in the Future' AS [Message]
				END
			ELSE IF (@Transaction_Date_Time_To_Process < @Order_Date_Time)
				BEGIN
					SELECT 'Transaction Date cannot be before the Order Date ' + QUOTENAME(CONVERT(VARCHAR,@Order_Date_Time,120),'''') AS [Message]
				END
			ELSE IF (LOWER(@Payment_Result) = 'failed')
				BEGIN
					INSERT INTO dbo.OrderTransaction(TransactionID, OrderID, PaymentType, TransactionDateTime, TransactionStatus)
						VALUES (NEWID(), @Order_Id_To_Process, @Payment_Type_To_Process, @Transaction_Date_Time_To_Process, 0)
					SELECT 'Payment Failed for Order ' + QUOTENAME(@Order_Id,'''') + '! Order is still Pending in the Queue' AS [Message]
				END
			ELSE IF EXISTS (SELECT 1 FROM OrderProduct OP
							INNER JOIN 
							dbo.Product P ON P.ProductID = OP.ProductID
							WHERE OP.OrderID = @Order_Id_To_Process
							AND P.ProductAvailableCount < OP.ProductOrderCount)
				BEGIN
					INSERT INTO dbo.OrderTransaction(TransactionID, OrderID, PaymentType, TransactionDateTime, TransactionStatus)
						VALUES (NEWID(), @Order_Id_To_Process, @Payment_Type_To_Process, @Transaction_Date_Time_To_Process, 0)
					SELECT 'Not enough Stock! Payment Failed for Order ' + QUOTENAME(@Order_Id,'''') AS [Message]
				END
			ELSE
				BEGIN
					INSERT INTO dbo.OrderTransaction(TransactionID, OrderID, PaymentType, TransactionDateTime, TransactionStatus)
						VALUES (NEWID(), @Order_Id_To_Process, @Payment_Type_To_Process, @Transaction_Date_Time_To_Process, 1)

					UPDATE dbo.[Order]
					SET OrderStatus = 1
					WHERE OrderID = @Order_Id_To_Process

					UPDATE P
					SET P.ProductAvailableCount = P.ProductAvailableCount - OP.ProductOrderCount
					FROM dbo.Product P
					INNER JOIN 
					dbo.OrderProduct OP ON OP.ProductID = P.ProductID
					WHERE OP.OrderID = @Order_Id_To_Process

					SELECT 'Payment of ' + QUOTENAME(CAST(@Order_Amount AS VARCHAR),'''') + ' Successful for Order '
						+ QUOTENAME(@Order_Id,'''') + '! Order Completed'  AS [Message]
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.'
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
		-- Failed Transaction is saved after the ROLLBACK so it is not undone
		IF EXISTS (SELECT 1 FROM dbo.[Order] WHERE OrderID = @Order_Id_To_Process AND OrderStatus = 5)
			AND (@Payment_Type_To_Process IS NOT NULL) AND (@Transaction_Date_Time_To_Process IS NOT NULL)
			BEGIN
				INSERT INTO dbo.OrderTransaction(TransactionID, OrderID, PaymentType, TransactionDateTime, TransactionStatus)
					VALUES (NEWID(), @Order_Id_To_Process, @Payment_Type_To_Process, @Transaction_Date_Time_To_Process, 0)
				SELECT 'Payment Failed for Order ' + QUOTENAME(@Order_Id,'''') + '! Order is still Pending in the Queue' AS [Message]
			END
	END CATCH
END
GO

-- Order 1 was created on 10-Feb 11:30
EXEC Usp_ProcessPayment
@Order_Id = '1',
@Payment_Type = 'UPI',
@Payment_Result = 'Success',
@Transaction_Date_Time = '2026-02-10 11:35:00'

SELECT * FROM [Order]
SELECT * FROM OrderTransaction
SELECT * FROM Product WHERE ProductID IN (1, 5, 9)

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Payment_Type = 'UPI',
@Payment_Result = 'Success'

-- NULL INPUT IN ANY ONE OF THE REQUIRED CATEGORY
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = 'abc',
@Payment_Type = 'UPI',
@Payment_Result = 'Success'

-- Character in Order Id parameter
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '999',
@Payment_Type = 'UPI',
@Payment_Result = 'Success'

-- Order which does not exist
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '1',
@Payment_Type = 'UPI',
@Payment_Result = 'Success'

-- Order which is already Paid
-- RESULT : TEST CASE 4 PASS

------------------------------------------------------------------------------------

-- Create Order 2 for the next test cases (Order Date = current date and time)
DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('2','1'), ('13','2')

EXEC Usp_CreateOrder
@Customer_Id = '2',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items
GO

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Cheque',
@Payment_Result = 'Success'

-- Invalid Payment Type
-- RESULT : TEST CASE 5 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Card',
@Payment_Result = 'Done'

-- Invalid Payment Result
-- RESULT : TEST CASE 6 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Card',
@Payment_Result = 'Success',
@Transaction_Date_Time = '2030-01-01 10:00:00'

-- Transaction Date in the Future
-- RESULT : TEST CASE 7 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Card',
@Payment_Result = 'Success',
@Transaction_Date_Time = '2026-02-01 10:00:00'

-- Transaction Date before the Order Date
-- RESULT : TEST CASE 8 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Card',
@Payment_Result = 'Failed'

SELECT * FROM OrderTransaction WHERE OrderID = 2
SELECT * FROM [Order] WHERE OrderID = 2

-- Payment Failed (Failed Transaction saved with Status 0, Order still 5, Stock not reduced)
-- RESULT : TEST CASE 9 PASS

------------------------------------------------------------------------------------

EXEC Usp_ProcessPayment
@Order_Id = '2',
@Payment_Type = 'Cash',
@Payment_Result = 'Success'

SELECT * FROM OrderTransaction WHERE OrderID = 2
SELECT * FROM [Order] WHERE OrderID = 2

-- Retry after Failed Payment (2 Transactions for Order 2 : Status 0 and Status 1)
-- RESULT : TEST CASE 10 PASS

------------------------------------------------------------------------------------
