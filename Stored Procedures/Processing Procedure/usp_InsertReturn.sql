/**************************************************************
    Script Name         : usp_InsertReturn.sql
    Purpose             : Inserting a Return with its Return Products for a
                          Completed Order and adding the returned
                          Products back in the Product Stock
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

IF TYPE_ID('ReturnProductType') IS NULL
	CREATE TYPE ReturnProductType AS TABLE(
		"Product_Id" VARCHAR(10) NULL,
		"Product_Return_Count" VARCHAR(10) NULL,
		"Return_Reason" VARCHAR(255) NULL
	);
GO

CREATE OR ALTER PROC
Usp_InsertReturn
@Order_Id VARCHAR(10) = NULL,
@Return_Date_Time VARCHAR(25) = NULL,
@Return_Products ReturnProductType READONLY
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Order_Id_To_Process INT
	DECLARE @Return_Date_Time_To_Process DATETIME
	DECLARE @Order_Status TINYINT
	DECLARE @Payment_Date_Time DATETIME
	DECLARE @Return_Id INT
	DECLARE @Return_Amount DECIMAL(9,2)
	DECLARE @Items_To_Process TABLE (Product_Id INT, Product_Return_Count INT, Return_Reason VARCHAR(255))
	BEGIN TRY
		BEGIN TRAN
			SET @Order_Id_To_Process = TRY_CONVERT(INT,@Order_Id)
			SET @Return_Date_Time_To_Process = CASE WHEN @Return_Date_Time IS NULL THEN GETDATE()
													WHEN LTRIM(@Return_Date_Time) = '' THEN NULL
													ELSE TRY_CONVERT(DATETIME,@Return_Date_Time,120) END

			SELECT @Order_Status = OrderStatus
			FROM [Order]
			WHERE OrderID = @Order_Id_To_Process

			SELECT @Payment_Date_Time = MAX(TransactionDateTime)
			FROM OrderTransaction
			WHERE OrderID = @Order_Id_To_Process AND TransactionStatus = 1

			INSERT INTO @Items_To_Process(Product_Id, Product_Return_Count, Return_Reason)
			SELECT TRY_CONVERT(INT,Product_Id), TRY_CONVERT(INT,Product_Return_Count), LTRIM(RTRIM(Return_Reason))
			FROM @Return_Products

			IF (@Order_Id_To_Process IS NULL) OR (@Return_Date_Time_To_Process IS NULL)
				BEGIN
					PRINT 'Invalid Input Values'
				END
			ELSE IF NOT EXISTS (SELECT 1 FROM @Items_To_Process)
				BEGIN
					PRINT 'No Products in the Return'
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process WHERE (Product_Id IS NULL) OR (Product_Return_Count IS NULL) OR (Product_Return_Count <= 0))
				BEGIN
					PRINT 'Invalid Product Id or Product Count in the Return Products'
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process WHERE (Return_Reason IS NULL) OR (Return_Reason = '') OR (LEN(Return_Reason) < 5))
				BEGIN
					PRINT 'Invalid Return Reason! Reason must have at least 5 characters'
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process WHERE PATINDEX('%  %', Return_Reason) > 0)
				BEGIN
					PRINT 'Consecutive Spaces Not Allowed! Invalid Input'
				END
			ELSE IF EXISTS (SELECT Product_Id FROM @Items_To_Process GROUP BY Product_Id HAVING COUNT(*) > 1)
				BEGIN
					PRINT 'Same Product added more than once! Increase the Product Count instead'
				END
			ELSE IF (@Order_Status IS NULL)
				BEGIN
					PRINT 'Order ' + QUOTENAME(@Order_Id,'''') + ' does not exist'
				END
			ELSE IF (@Order_Status != 1)
				BEGIN
					PRINT 'Order ' + QUOTENAME(@Order_Id,'''') + ' is not Completed! Only Paid Orders can be Returned'
				END
			ELSE IF (@Return_Date_Time_To_Process > GETDATE())
				BEGIN
					PRINT 'Return Date ' + QUOTENAME(@Return_Date_Time,'''') + ' cannot be in the Future'
				END
			ELSE IF (@Return_Date_Time_To_Process < @Payment_Date_Time)
				BEGIN
					PRINT 'Return Date cannot be before the Payment Date ' + QUOTENAME(CONVERT(VARCHAR,@Payment_Date_Time,120),'''')
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process I
							LEFT JOIN OrderProduct OP ON OP.ProductID = I.Product_Id AND OP.OrderID = @Order_Id_To_Process
							WHERE OP.ProductID IS NULL)
				BEGIN
					PRINT 'One or more Products were not bought in Order ' + QUOTENAME(@Order_Id,'''')
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process I
							JOIN OrderProduct OP ON OP.ProductID = I.Product_Id AND OP.OrderID = @Order_Id_To_Process
							WHERE I.Product_Return_Count > OP.ProductOrderCount
								- ISNULL((SELECT SUM(RP.ProductReturnCount)
										  FROM ReturnProduct RP
										  JOIN [Return] R ON R.ReturnID = RP.ReturnID
										  WHERE R.OrderID = @Order_Id_To_Process AND RP.ProductID = I.Product_Id), 0))
				BEGIN
					PRINT 'Return Count is more than the Products bought in Order ' + QUOTENAME(@Order_Id,'''')
				END
			ELSE
				BEGIN
					SELECT @Return_Amount = SUM(I.Product_Return_Count * OP.ProductPrice)
					FROM @Items_To_Process I
					JOIN OrderProduct OP ON OP.ProductID = I.Product_Id AND OP.OrderID = @Order_Id_To_Process

					SELECT @Return_Id = ISNULL(MAX(ReturnID),0) + 1
					FROM [Return] WITH (UPDLOCK, HOLDLOCK)

					INSERT INTO [Return](ReturnID, OrderID, ReturnAmount, ReturnDateTime)
						VALUES (@Return_Id, @Order_Id_To_Process, @Return_Amount, @Return_Date_Time_To_Process)

					INSERT INTO ReturnProduct(ReturnID, ProductID, ProductReturnCount, ProductPrice, ReturnReason)
					SELECT @Return_Id, I.Product_Id, I.Product_Return_Count, OP.ProductPrice, I.Return_Reason
					FROM @Items_To_Process I
					JOIN OrderProduct OP ON OP.ProductID = I.Product_Id AND OP.OrderID = @Order_Id_To_Process

					-- Returned Products are added back in the Product Stock
					UPDATE P
					SET P.ProductAvailableCount = P.ProductAvailableCount + I.Product_Return_Count
					FROM Product P
					JOIN @Items_To_Process I ON I.Product_Id = P.ProductID

					PRINT 'Return ' + QUOTENAME(CAST(@Return_Id AS VARCHAR),'''') + ' of amount ' + QUOTENAME(CAST(@Return_Amount AS VARCHAR),'''')
						+ ' for Order ' + QUOTENAME(@Order_Id,'''') + ' successfully added'
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		Print Error_Message()
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
	END CATCH
END
GO

-- Order 1 has Product 1 (Count 2), Product 5 (Count 1), Product 9 (Count 3), Paid on 10-Feb 11:35
DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('1','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Date_Time = '2026-02-15 17:00:00',
@Return_Products = @Items
GO

SELECT * FROM [Order]
SELECT * FROM OrderProduct
SELECT * FROM [Return]
SELECT * FROM ReturnProduct
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('1','1','Packet was damaged')

EXEC Usp_InsertReturn
@Return_Products = @Items

-- NULL INPUT IN ANY ONE OF THE REQUIRED CATEGORY
-- RESULT : TEST CASE 1 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('1','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = 'abc',
@Return_Products = @Items

-- Character in Order Id parameter
-- RESULT : TEST CASE 2 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('1','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Date_Time = '15/02/2026',
@Return_Products = @Items

-- Invalid Return Date
-- RESULT : TEST CASE 3 PASS
GO
------------------------------------------------------------------------------------

EXEC Usp_InsertReturn
@Order_Id = '1'

-- No Products passed in the Return
-- RESULT : TEST CASE 4 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('abc','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Character in Product Id of Return Products
-- RESULT : TEST CASE 5 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','0','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Zero Return Count in Return Products
-- RESULT : TEST CASE 6 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Empty Return Reason
-- RESULT : TEST CASE 7 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Bad')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Return Reason less than 5 characters
-- RESULT : TEST CASE 8 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Packet   was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Multiple Consecutive Spaces in the Return Reason
-- RESULT : TEST CASE 9 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Packet was damaged'), ('5','1','Wrong product given')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Same Product added more than once in Return Products
-- RESULT : TEST CASE 10 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '999',
@Return_Products = @Items

-- Order which does not exist
-- RESULT : TEST CASE 11 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('6','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '3',
@Return_Products = @Items

-- Order which is still Pending (Payment not done, Order 3 created in Feedback test cases)
-- RESULT : TEST CASE 12 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Date_Time = '2030-01-01 10:00:00',
@Return_Products = @Items

-- Return Date in the Future
-- RESULT : TEST CASE 13 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Date_Time = '2026-02-10 09:00:00',
@Return_Products = @Items

-- Return Date before the Payment Date (Order 1 Paid on 10-Feb 11:35)
-- RESULT : TEST CASE 14 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('2','1','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Product which was not bought in the Order
-- RESULT : TEST CASE 15 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('9','5','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Return Count more than the Count bought (Product 9 bought 3)
-- RESULT : TEST CASE 16 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('1','2','Packet was damaged')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

-- Return Count more than the Count left after the earlier Return (Product 1 bought 2, 1 already Returned)
-- RESULT : TEST CASE 17 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items ReturnProductType
INSERT INTO @Items VALUES ('5','1','Wrong product given'), ('9','2','Expired product')

EXEC Usp_InsertReturn
@Order_Id = '1',
@Return_Products = @Items

SELECT * FROM [Return] WHERE OrderID = 1
SELECT * FROM ReturnProduct
SELECT * FROM Product WHERE ProductID IN (1, 5, 9)

-- Multiple Products returned in one Return (Stock added back in the Product table)
-- RESULT : TEST CASE 18 PASS
GO
------------------------------------------------------------------------------------
