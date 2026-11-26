/**************************************************************
    Script Name         : usp_MostUsedPaymentType.sql
    Purpose             : Showing the Payment Types ranked by the number of
                          Transactions, or the details of one
                          Payment Type if the Payment Type is provided
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1
****************************************************************/

USE BrightmartV2;
GO

CREATE OR ALTER PROC
usp_MostUsedPaymentType
@Payment_Type VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Payment_Type_To_Process VARCHAR(10);
	BEGIN TRY
		-- Match the input to the stored Payment_type value in transaction Table
		SELECT @Payment_Type_To_Process = OrderTransaction.PaymentType
		FROM OrderTransaction
		WHERE UPPER(OrderTransaction.PaymentType) = UPPER(LTRIM(RTRIM(@Payment_Type)));

		IF (@Payment_Type IS NOT NULL) AND (@Payment_Type_To_Process IS NULL)
			BEGIN
				SELECT 'Invalid Payment Type! Payment Type must be Cash, Card or UPI' AS [Message] 
			END
		ELSE IF NOT EXISTS (SELECT 1 FROM dbo.OrderTransaction)
			BEGIN
				SELECT 'No Transactions found' AS [Message]
			END
		ELSE IF (@Payment_Type_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.OrderTransaction WHERE PaymentType = @Payment_Type_To_Process)
			BEGIN
				SELECT 'No Transactions found for Payment Type ' + QUOTENAME(@Payment_Type,'''') AS [Message]
			END
		ELSE
			BEGIN
				WITH PaymentTypeRanked(UsageRank,PaymentType,TotalTransactions, SuccessfullTransactions, SuccessRatePercent,AmountCollected)
				AS
				(
					SELECT 
						DENSE_RANK() OVER (ORDER BY COUNT(TransactionID) DESC) AS Usage_Rank,
						PaymentType,
						COUNT(TransactionID) AS TotalTransactions,
						SUM(CASE WHEN TransactionStatus = 1 THEN 1 ELSE 0 END) AS SuccessfullTransactions,
						CAST(SUM(CASE WHEN TransactionStatus = 1 THEN 1 ELSE 0 END) * 100.0
						/ NULLIF(COUNT(TransactionID), 0) AS DECIMAL(5,2)) AS SuccessRatePercent,
						SUM(O.OrderAmount) as AmountCollected
					FROM 
					[dbo].[OrderTransaction] OT
					INNER JOIN 
					[dbo].[Order] O ON OT.OrderID = O.OrderID
					AND O.OrderStatus = 1
					GROUP BY PaymentType
				)
				SELECT 
					UsageRank,
					PaymentType,
					TotalTransactions,
					SuccessfullTransactions,
					SuccessRatePercent,
					AmountCollected
				FROM
				PaymentTypeRanked
				WHERE (@Payment_Type_To_Process IS NULL) OR (PaymentTypeRanked.PaymentType = @Payment_Type_To_Process)
				ORDER BY UsageRank, AmountCollected
			END;
	END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO


------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType

-- No Parameters (Cash, Card, UPI ranked)
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType @Payment_Type = 'UPI'

-- Only UPI row, with its Rank 
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType @Payment_Type = 'cash'

-- Lower case input -> matched to 'Cash', only Cash row shown
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType @Payment_Type = ' Card '

-- Leading / trailing spaces trimmed -> only Card row shown
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType @Payment_Type = 'Wallet'

-- Payment Type not allowed -> 'Invalid Payment Type! Payment Type must be Cash, Card or UPI'
-- RESULT : PASS

------------------------------------------------------------------------------------

EXEC Usp_MostUsedPaymentType @Payment_Type = ''

-- Empty string treated as Invalid Input
-- RESULT : PASS

------------------------------------------------------------------------------------
