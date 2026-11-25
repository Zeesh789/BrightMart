/**************************************************************
    Script Name         : usp_InsertFeedback.sql
    Purpose             : Inserting the Store and Cashier Rating with the
                          Feedback Detail for a Completed Order in the
                          StoreCashierFeedback table
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER PROC
Usp_InsertFeedback
@Order_Id VARCHAR(10) = NULL,
@Store_Rating VARCHAR(10) = NULL,
@Cashier_Rating VARCHAR(10) = NULL,
@Feedback_Detail VARCHAR(500) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Order_Id_To_Process INT
	DECLARE @Store_Rating_To_Process INT
	DECLARE @Cashier_Rating_To_Process INT
	DECLARE @Order_Status TINYINT
	DECLARE @Feedback_Id INT
	BEGIN TRY
		BEGIN TRAN
			SET @Order_Id_To_Process = TRY_CONVERT(INT,@Order_Id)
			SET @Store_Rating_To_Process = TRY_CONVERT(INT,@Store_Rating)
			SET @Cashier_Rating_To_Process = TRY_CONVERT(INT,@Cashier_Rating)

			SELECT @Order_Status = OrderStatus
			FROM [Order]
			WHERE OrderID = @Order_Id_To_Process

			IF (@Order_Id_To_Process IS NULL) OR (@Store_Rating_To_Process IS NULL) OR (@Cashier_Rating_To_Process IS NULL)
				OR (@Feedback_Detail IS NULL)
				BEGIN
					PRINT 'Invalid Input Values'
				END
			ELSE IF (@Order_Status IS NULL)
				BEGIN
					PRINT 'Order ' + QUOTENAME(@Order_Id,'''') + ' does not exist'
				END
			ELSE IF (@Order_Status != 1)
				BEGIN
					PRINT 'Order ' + QUOTENAME(@Order_Id,'''') + ' is not Completed! Feedback can only be given after Payment'
				END
			ELSE IF (@Store_Rating_To_Process < 1) OR (@Store_Rating_To_Process > 5)
				BEGIN
					PRINT 'Invalid Store Rating! Rating must be between 1 and 5'
				END
			ELSE IF (@Cashier_Rating_To_Process < 1) OR (@Cashier_Rating_To_Process > 5)
				BEGIN
					PRINT 'Invalid Cashier Rating! Rating must be between 1 and 5'
				END
			ELSE IF (LEN(LTRIM(@Feedback_Detail)) < 5)
				BEGIN
					PRINT 'Invalid Feedback Detail! Feedback must have at least 5 characters'
				END
			ELSE IF (LEN(@Feedback_Detail) > 255)
				BEGIN
					PRINT 'Invalid Feedback Detail! Feedback cannot be more than 255 characters'
				END
			ELSE IF (PATINDEX('%  %', @Feedback_Detail) > 0)
				BEGIN
					PRINT 'Consecutive Spaces Not Allowed! Invalid Input'
				END
			ELSE IF EXISTS (SELECT 1 FROM StoreCashierFeedback WHERE OrderID = @Order_Id_To_Process)
				BEGIN
					PRINT 'Feedback for Order ' + QUOTENAME(@Order_Id,'''') + ' already exists'
				END
			ELSE
				BEGIN
					SELECT @Feedback_Id = ISNULL(MAX(FeedbackID),0) + 1
					FROM StoreCashierFeedback WITH (UPDLOCK, HOLDLOCK)

					INSERT INTO StoreCashierFeedback(FeedbackID, OrderID, StoreRating, CashierRating, FeedbackDetail)
						VALUES (@Feedback_Id, @Order_Id_To_Process, @Store_Rating_To_Process, @Cashier_Rating_To_Process,
								LTRIM(RTRIM(@Feedback_Detail)))
					PRINT 'Feedback for Order ' + QUOTENAME(@Order_Id,'''') + ' successfully added in the Feedback Table'
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		Print Error_Message()
		IF	(
				SELECT PATINDEX('%UNIQUE KEY%',ERROR_MESSAGE())
			) > 0
			BEGIN
				PRINT 'Feedback for Order ' + QUOTENAME(@Order_Id,'''') + ' already exists'
			END
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
	END CATCH
END
GO

EXEC Usp_InsertFeedback
@Order_Id = '1',
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

SELECT * FROM StoreCashierFeedback
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- NULL INPUT IN ANY ONE OF THE REQUIRED CATEGORY
-- RESULT : TEST CASE 1 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '',
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Empty String in any of the parameters
-- RESULT : TEST CASE 2 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = 'abc',
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Character in Order Id parameter
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = 'five',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Character in Store Rating parameter
-- RESULT : TEST CASE 4 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '5',
@Cashier_Rating = '4.5',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Decimal value in Cashier Rating parameter
-- RESULT : TEST CASE 5 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '999',
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Order which does not exist
-- RESULT : TEST CASE 6 PASS

------------------------------------------------------------------------------------

-- Create Order 3 (Pending) for the next test case
DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('6','1')

EXEC Usp_CreateOrder
@Customer_Id = '5',
@Store_Id = '2',
@Employee_Id = '6',
@Order_Products = @Items
GO

EXEC Usp_InsertFeedback
@Order_Id = '3',
@Store_Rating = '5',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Order which is still Pending (Payment not done)
-- RESULT : TEST CASE 7 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '0',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Store Rating less than 1
-- RESULT : TEST CASE 8 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '5',
@Cashier_Rating = '6',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Cashier Rating more than 5
-- RESULT : TEST CASE 9 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '-3',
@Cashier_Rating = '4',
@Feedback_Detail = 'Quick billing and the staff was helpful'

-- Negative Store Rating
-- RESULT : TEST CASE 10 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '4',
@Cashier_Rating = '4',
@Feedback_Detail = ''

-- Empty Feedback Detail
-- RESULT : TEST CASE 11 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '4',
@Cashier_Rating = '4',
@Feedback_Detail = 'Ok'

-- Feedback Detail less than 5 characters
-- RESULT : TEST CASE 12 PASS

------------------------------------------------------------------------------------

DECLARE @Long_Feedback VARCHAR(500) = REPLICATE('Good service ', 25)

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '4',
@Cashier_Rating = '4',
@Feedback_Detail = @Long_Feedback

-- Feedback Detail more than 255 characters
-- RESULT : TEST CASE 13 PASS
GO
------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '2',
@Store_Rating = '4',
@Cashier_Rating = '4',
@Feedback_Detail = 'Good   service'

-- Multiple Consecutive Spaces in the Feedback Detail
-- RESULT : TEST CASE 14 PASS

------------------------------------------------------------------------------------

EXEC Usp_InsertFeedback
@Order_Id = '1',
@Store_Rating = '3',
@Cashier_Rating = '3',
@Feedback_Detail = 'Second feedback for the same order'

-- Duplicate Feedback for the same Order
-- RESULT : TEST CASE 15 PASS

------------------------------------------------------------------------------------
