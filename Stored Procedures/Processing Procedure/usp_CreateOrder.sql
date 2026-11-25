/**************************************************************
    Script Name         : usp_CreateOrder.sql
    Purpose             : Creating an Order with its Order Products and
                          adding it in the Order Queue (Status Pending)
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1

    Note                : Order Products are passed using the OrderProductType
                          Table Valued Parameter. Product Price is taken
                          from the Product table, not from the input.
                          Status values (Status table) : 0 = False,
                          1 = True, 5 = Pending. A new Order is saved as 5.
                          @Order_Date_Time is optional ('YYYY-MM-DD HH:MM:SS').
                          If not passed, the current date and time is used.
                          The Order date cannot be before the Customer
                          Register date, Store Establish date, Employee Join
                          date or Product Introduce date.
                          OrderID is generated as MAX(OrderID) + 1.
****************************************************************/

IF TYPE_ID('OrderProductType') IS NULL
	CREATE TYPE OrderProductType AS TABLE(
		"Product_Id" VARCHAR(10) NULL,
		"Product_Order_Count" VARCHAR(10) NULL
	);
GO

CREATE OR ALTER PROC
Usp_CreateOrder
@Customer_Id VARCHAR(10) = NULL,
@Store_Id VARCHAR(10) = NULL,
@Employee_Id VARCHAR(10) = NULL,
@Order_Date_Time VARCHAR(25) = NULL,
@Order_Products OrderProductType READONLY
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Customer_Id_To_Process INT
	DECLARE @Store_Id_To_Process INT
	DECLARE @Employee_Id_To_Process INT
	DECLARE @Order_Date_Time_To_Process DATETIME
	DECLARE @Order_Date DATE
	DECLARE @Order_Id INT
	DECLARE @Order_Amount DECIMAL(9,2)
	DECLARE @Items_To_Process TABLE (Product_Id INT, Product_Order_Count INT)
	BEGIN TRY
		BEGIN TRAN
			SET @Customer_Id_To_Process = TRY_CONVERT(INT,@Customer_Id)
			SET @Store_Id_To_Process = TRY_CONVERT(INT,@Store_Id)
			SET @Employee_Id_To_Process = TRY_CONVERT(INT,@Employee_Id)
			SET @Order_Date_Time_To_Process = CASE WHEN @Order_Date_Time IS NULL THEN GETDATE()
												   WHEN LTRIM(@Order_Date_Time) = '' THEN NULL
												   ELSE TRY_CONVERT(DATETIME,@Order_Date_Time,120) END
			SET @Order_Date = CAST(@Order_Date_Time_To_Process AS DATE)

			INSERT INTO @Items_To_Process(Product_Id, Product_Order_Count)
			SELECT TRY_CONVERT(INT,Product_Id), TRY_CONVERT(INT,Product_Order_Count)
			FROM @Order_Products

			IF (@Customer_Id_To_Process IS NULL) OR (@Store_Id_To_Process IS NULL) OR (@Employee_Id_To_Process IS NULL)
				OR (@Order_Date_Time_To_Process IS NULL)
				BEGIN
					PRINT 'Invalid Input Values'
				END
			ELSE IF NOT EXISTS (SELECT 1 FROM @Items_To_Process)
				BEGIN
					PRINT 'No Products in the Order'
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process WHERE (Product_Id IS NULL) OR (Product_Order_Count IS NULL) OR (Product_Order_Count <= 0))
				BEGIN
					PRINT 'Invalid Product Id or Product Count in the Order Products'
				END
			ELSE IF EXISTS (SELECT Product_Id FROM @Items_To_Process GROUP BY Product_Id HAVING COUNT(*) > 1)
				BEGIN
					PRINT 'Same Product added more than once! Increase the Product Count instead'
				END
			ELSE IF (@Order_Date_Time_To_Process > GETDATE())
				BEGIN
					PRINT 'Order Date ' + QUOTENAME(@Order_Date_Time,'''') + ' cannot be in the Future'
				END
			ELSE IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @Customer_Id_To_Process AND CustomerActiveStatus = 1)
				BEGIN
					PRINT 'Customer ' + QUOTENAME(@Customer_Id,'''') + ' does not exist or is not Active'
				END
			ELSE IF EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @Customer_Id_To_Process AND CustomerRegisterDate > @Order_Date)
				BEGIN
					PRINT 'Customer ' + QUOTENAME(@Customer_Id,'''') + ' was not Registered on ' + QUOTENAME(CONVERT(VARCHAR,@Order_Date,23),'''')
				END
			ELSE IF NOT EXISTS (SELECT 1 FROM Store WHERE StoreID = @Store_Id_To_Process AND StoreActiveStatus = 1)
				BEGIN
					PRINT 'Store ' + QUOTENAME(@Store_Id,'''') + ' does not exist or is not Active'
				END
			ELSE IF EXISTS (SELECT 1 FROM Store WHERE StoreID = @Store_Id_To_Process AND StoreEstablishDate > @Order_Date)
				BEGIN
					PRINT 'Store ' + QUOTENAME(@Store_Id,'''') + ' was not Open on ' + QUOTENAME(CONVERT(VARCHAR,@Order_Date,23),'''')
				END
			ELSE IF NOT EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeeID = @Employee_Id_To_Process AND EmployeeStoreID = @Store_Id_To_Process
								AND EmployeeActiveStatus = 1)
				BEGIN
					PRINT 'Employee ' + QUOTENAME(@Employee_Id,'''') + ' does not exist or does not work in Store ' + QUOTENAME(@Store_Id,'''')
				END
			ELSE IF EXISTS (SELECT 1 FROM StoreEmployee WHERE EmployeeID = @Employee_Id_To_Process AND EmployeeJoinDate > @Order_Date)
				BEGIN
					PRINT 'Employee ' + QUOTENAME(@Employee_Id,'''') + ' had not Joined on ' + QUOTENAME(CONVERT(VARCHAR,@Order_Date,23),'''')
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process I
							LEFT JOIN Product P ON P.ProductID = I.Product_Id AND P.ProductActiveStatus = 1
							WHERE P.ProductID IS NULL)
				BEGIN
					PRINT 'One or more Products do not exist or are not Active'
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process I
							JOIN Product P ON P.ProductID = I.Product_Id
							WHERE P.ProductIntroduceDate > @Order_Date)
				BEGIN
					PRINT 'One or more Products were not Introduced on ' + QUOTENAME(CONVERT(VARCHAR,@Order_Date,23),'''')
				END
			ELSE IF EXISTS (SELECT 1 FROM @Items_To_Process I
							JOIN Product P ON P.ProductID = I.Product_Id
							WHERE P.ProductAvailableCount < I.Product_Order_Count)
				BEGIN
					PRINT 'Not enough Stock for one or more Products'
				END
			ELSE
				BEGIN
					SELECT @Order_Amount = SUM(I.Product_Order_Count * P.ProductPrice)
					FROM @Items_To_Process I
					JOIN Product P
					ON P.ProductID = I.Product_Id

					SELECT @Order_Id = ISNULL(MAX(OrderID),0) + 1
					FROM [Order] WITH (UPDLOCK, HOLDLOCK)

					INSERT INTO [Order](OrderID, CustomerID, StoreID, EmployeeStoreID, OrderAmount, OrderStatus, OrderDateTime)
						VALUES (@Order_Id, @Customer_Id_To_Process, @Store_Id_To_Process, @Employee_Id_To_Process, @Order_Amount, 5,
								@Order_Date_Time_To_Process)

					INSERT INTO OrderProduct(OrderID, ProductID, ProductOrderCount, ProductPrice)
					SELECT @Order_Id, I.Product_Id, I.Product_Order_Count, P.ProductPrice
					FROM @Items_To_Process I
					JOIN Product P ON P.ProductID = I.Product_Id

					PRINT 'Order ' + QUOTENAME(CAST(@Order_Id AS VARCHAR),'''') + ' of amount ' + QUOTENAME(CAST(@Order_Amount AS VARCHAR),'''')
						+ ' successfully added in the Order Queue'
				END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		Print Error_Message()
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
	END CATCH
END
GO

-- Customer 1 registered 05-Feb, Employee 2 (Store 1) joined 09-Feb
DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2'), ('5','1'), ('9','3')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '2',
@Order_Date_Time = '2026-02-10 11:30:00',
@Order_Products = @Items
GO

SELECT * FROM [Order]
SELECT * FROM OrderProduct
------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- NULL INPUT IN ANY ONE OF THE REQUIRED CATEGORY
-- RESULT : TEST CASE 1 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = 'abc',
@Employee_Id = '1',
@Order_Products = @Items

-- Character in Store Id parameter
-- RESULT : TEST CASE 2 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Date_Time = '31-02-2026',
@Order_Products = @Items

-- Invalid Order Date
-- RESULT : TEST CASE 3 PASS
GO
------------------------------------------------------------------------------------

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1'

-- No Products passed in the Order
-- RESULT : TEST CASE 4 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('abc','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Character in Product Id of Order Products
-- RESULT : TEST CASE 5 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','0')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Zero Product Count in Order Products
-- RESULT : TEST CASE 6 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2.5')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Decimal Product Count in Order Products
-- RESULT : TEST CASE 7 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2'), ('1','3')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Same Product added more than once in Order Products
-- RESULT : TEST CASE 8 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Date_Time = '2030-01-01 10:00:00',
@Order_Products = @Items

-- Order Date in the Future
-- RESULT : TEST CASE 9 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '999',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Customer which does not exist
-- RESULT : TEST CASE 10 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '150',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Date_Time = '2026-06-01 10:00:00',
@Order_Products = @Items

-- Order Date before the Customer Register Date (Customer 150 registered 31-Aug)
-- RESULT : TEST CASE 11 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '999',
@Employee_Id = '1',
@Order_Products = @Items

-- Store which does not exist
-- RESULT : TEST CASE 12 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '5',
@Employee_Id = '19',
@Order_Date_Time = '2026-03-10 10:00:00',
@Order_Products = @Items

-- Order Date before the Store Establish Date (Store 5 opened 01-Apr)
-- RESULT : TEST CASE 13 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '6',
@Order_Products = @Items

-- Employee who does not work in this Store (Employee 6 works in Store 2)
-- RESULT : TEST CASE 14 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '2',
@Order_Date_Time = '2026-02-06 10:00:00',
@Order_Products = @Items

-- Order Date before the Employee Join Date (Employee 2 joined 09-Feb)
-- RESULT : TEST CASE 15 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','2'), ('999','1')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Product which does not exist in Order Products
-- RESULT : TEST CASE 16 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','1'), ('8','1')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Date_Time = '2026-03-10 10:00:00',
@Order_Products = @Items

-- Order Date before the Product Introduce Date (Product 8 introduced 16-May)
-- RESULT : TEST CASE 17 PASS
GO
------------------------------------------------------------------------------------

DECLARE @Items OrderProductType
INSERT INTO @Items VALUES ('1','500')

EXEC Usp_CreateOrder
@Customer_Id = '1',
@Store_Id = '1',
@Employee_Id = '1',
@Order_Products = @Items

-- Product Count more than the Stock available (Product 1 has 55 in Stock)
-- RESULT : TEST CASE 18 PASS
GO
------------------------------------------------------------------------------------
