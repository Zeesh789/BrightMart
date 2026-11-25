/**************************************************************
    Script Name         : ProcessingData_Insert.sql
    Purpose             : Populating the processing tables ([Order], OrderProduct,
                          OrderTransaction, StoreCashierFeedback, [Return],
                          ReturnProduct) using the insert procedures
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1

    Note                : Run after MasterData_Insert.sql and the 4 procedure
                          scripts. Every row is added through
                          Usp_CreateOrder, Usp_ProcessPayment,
                          Usp_InsertFeedback and Usp_InsertReturn, in
                          date and time order, so all procedure rules apply.
                          Orders     : 500 (01-Feb-2026 to 31-Oct-2026)
                          Payments   : 493 Success, 55 Failed
                                       (46 Orders had a Failed attempt,
                                        7 Orders left Pending after Failed attempts)
                          Feedback   : 493
                          Returns    : 40 (on 37 Orders)
****************************************************************/
SET NOCOUNT ON
GO

/* ---------- STEP 1 : Clear the processing tables (removes the procedure test case data)
               and put Product Stock back to the master data values ---------- */
DELETE FROM ReturnProduct
DELETE FROM [Return]
DELETE FROM StoreCashierFeedback
DELETE FROM OrderTransaction
DELETE FROM OrderProduct
DELETE FROM [Order]

UPDATE P
SET P.ProductAvailableCount = S.Stock
FROM Product P
JOIN (VALUES
(1,1000),
(2, 1000),
(3, 1000),
(4, 1000),
(5, 1000),
(6, 1000),
(7, 1000),
(8, 1000),
(9, 1000),
(10, 1000),
(11, 1000),
(12, 1000),
(13, 1000),
(14, 1000),
(15, 1000),
(16, 1000),
(17, 1000),
(18, 1000),
(19, 1000),
(20, 1000),
(21, 1000),
(22, 1000),
(23, 1000),
(24, 1000),
(25, 1000),
(26, 1000),
(27,1000),
(28, 1000),
(29, 1000),
(30, 1000),
(31,1000),
(32, 1000),
(33, 1000),
(34, 1000),
(35, 1000),
(36,1000),
(37, 1000),
(38, 1000)
) AS S (ProductID, Stock) ON S.ProductID = P.ProductID
GO

/* ---------- STEP 2 : Orders, Payments, Feedback and Returns in date and time order ---------- */
DECLARE @Items OrderProductType
DECLARE @Return_Items ReturnProductType

-- Order 1
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-05 13:31:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '1', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-05 13:37:56'

EXEC Usp_InsertFeedback @Order_Id = '1', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 2
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-06 12:55:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '2', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-06 12:58:32'

EXEC Usp_InsertFeedback @Order_Id = '2', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 3
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-07 11:02:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '3', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-07 11:08:18'

EXEC Usp_InsertFeedback @Order_Id = '3', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 4
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-07 16:37:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '4', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-07 16:48:32'

EXEC Usp_InsertFeedback @Order_Id = '4', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 5
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','1'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-09 17:11:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '5', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-09 17:21:41'

EXEC Usp_InsertFeedback @Order_Id = '5', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 6
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-10 12:35:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '6', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-10 12:40:22'

EXEC Usp_InsertFeedback @Order_Id = '6', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 7
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-11 10:32:31', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '7', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-11 10:40:26'

EXEC Usp_InsertFeedback @Order_Id = '7', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 8
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-02-13 09:41:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '8', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-13 09:47:29'

EXEC Usp_InsertFeedback @Order_Id = '8', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 9
DELETE FROM @Items
INSERT INTO @Items VALUES ('29','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-02-13 14:10:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '9', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-13 14:14:33'

EXEC Usp_InsertFeedback @Order_Id = '9', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 10
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','3'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-02-13 16:46:44', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '10', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-02-13 16:57:22'

EXEC Usp_ProcessPayment @Order_Id = '10', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-13 17:00:17'

EXEC Usp_InsertFeedback @Order_Id = '10', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 11
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','3'), ('18','3')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-14 12:52:58', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '11', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-14 12:56:39'

EXEC Usp_InsertFeedback @Order_Id = '11', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 12
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('15','2')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-02-14 18:03:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '12', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-02-14 18:06:17'

EXEC Usp_ProcessPayment @Order_Id = '12', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-14 18:07:43'

EXEC Usp_InsertFeedback @Order_Id = '12', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 13
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1'), ('33','2'), ('30','3'), ('19','3'), ('37','2')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-14 18:38:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '13', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-14 18:44:20'

EXEC Usp_InsertFeedback @Order_Id = '13', @Store_Rating = '4', @Cashier_Rating = '1', @Feedback_Detail = 'Staff was not very helpful'

-- Order 14
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('4','1'), ('35','3'), ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-14 20:02:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '14', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-14 20:08:57'

EXEC Usp_InsertFeedback @Order_Id = '14', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 15
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-02-15 15:16:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '15', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-15 15:26:37'

EXEC Usp_InsertFeedback @Order_Id = '15', @Store_Rating = '2', @Cashier_Rating = '2', @Feedback_Detail = 'Store was crowded and untidy'

-- Return for Order 4
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('15','1','Bought by mistake')
EXEC Usp_InsertReturn @Order_Id = '4', @Return_Date_Time = '2026-02-17 21:19:32', @Return_Products = @Return_Items

-- Order 16
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','2'), ('11','1'), ('30','3')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-02-18 17:02:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '16', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-18 17:08:41'

EXEC Usp_InsertFeedback @Order_Id = '16', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Okay service, can improve'

-- Return for Order 10
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('28','1','Product was damaged'), ('14','2','Seal was broken')
EXEC Usp_InsertReturn @Order_Id = '10', @Return_Date_Time = '2026-02-18 17:50:17', @Return_Products = @Return_Items

-- Order 17
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','2'), ('4','2'), ('23','2')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-02-21 10:17:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '17', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-21 10:27:28'

EXEC Usp_InsertFeedback @Order_Id = '17', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 18
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','1'), ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-21 11:56:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '18', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-21 12:01:33'

EXEC Usp_InsertFeedback @Order_Id = '18', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 19
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('23','2'), ('3','2')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-02-22 16:43:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '19', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-22 16:47:21'

EXEC Usp_InsertFeedback @Order_Id = '19', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 20
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','1'), ('20','1'), ('33','1'), ('19','2')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-02-22 21:26:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '20', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-22 21:34:59'

EXEC Usp_InsertFeedback @Order_Id = '20', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 21
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','4'), ('1','1'), ('19','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-02-23 14:58:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '21', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-23 15:00:42'

EXEC Usp_InsertFeedback @Order_Id = '21', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 22
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','4'), ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-02-24 09:12:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '22', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-24 09:17:32'

EXEC Usp_InsertFeedback @Order_Id = '22', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 23
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('4','1'), ('11','1'), ('32','4'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-02-26 14:31:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '23', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-26 14:35:21'

EXEC Usp_InsertFeedback @Order_Id = '23', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 24
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-02-27 17:44:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '24', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-02-27 17:49:22'

EXEC Usp_ProcessPayment @Order_Id = '24', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-27 17:52:17'

EXEC Usp_InsertFeedback @Order_Id = '24', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 25
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-02-28 17:53:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '25', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-02-28 17:55:48'

EXEC Usp_InsertFeedback @Order_Id = '25', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 26
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','2'), ('9','3'), ('17','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-03-01 18:23:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '26', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-03-01 18:29:02'

EXEC Usp_ProcessPayment @Order_Id = '26', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-01 18:30:25'

EXEC Usp_InsertFeedback @Order_Id = '26', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 27
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','4'), ('17','1'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-03-04 20:44:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '27', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-04 20:53:43'

EXEC Usp_InsertFeedback @Order_Id = '27', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 28
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1'), ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-05 13:17:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '28', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-05 13:26:45'

EXEC Usp_InsertFeedback @Order_Id = '28', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 29
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('13','2'), ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-06 12:16:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '29', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-06 12:19:26'

EXEC Usp_InsertFeedback @Order_Id = '29', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 30
DELETE FROM @Items
INSERT INTO @Items VALUES ('29','1'), ('18','3')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-03-07 13:43:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '30', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-07 13:53:52'

EXEC Usp_InsertFeedback @Order_Id = '30', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 31
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1'), ('10','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-03-07 17:48:13', @Order_Products = @Items

-- Order 32
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','2'), ('34','2'), ('14','2'), ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-03-07 17:49:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '31', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-03-07 17:51:18'

EXEC Usp_ProcessPayment @Order_Id = '31', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-07 17:55:18'

EXEC Usp_ProcessPayment @Order_Id = '32', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-07 17:59:12'

EXEC Usp_InsertFeedback @Order_Id = '31', @Store_Rating = '4', @Cashier_Rating = '1', @Feedback_Detail = 'Store was crowded and untidy'

EXEC Usp_InsertFeedback @Order_Id = '32', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 33
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('33','2'), ('21','1'), ('10','1'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-08 14:57:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '33', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-08 15:03:35'

EXEC Usp_InsertFeedback @Order_Id = '33', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 34
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','1'), ('10','3')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-03-08 18:41:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '34', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-08 18:45:49'

EXEC Usp_InsertFeedback @Order_Id = '34', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 35
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','3'), ('29','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-03-08 21:13:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '35', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-08 21:18:29'

EXEC Usp_InsertFeedback @Order_Id = '35', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 36
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','3'), ('12','3'), ('23','2')
EXEC Usp_CreateOrder @Customer_Id = '12', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-03-09 12:49:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '36', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-09 12:59:39'

EXEC Usp_InsertFeedback @Order_Id = '36', @Store_Rating = '5', @Cashier_Rating = '1', @Feedback_Detail = 'Average experience'

-- Order 37
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2')
EXEC Usp_CreateOrder @Customer_Id = '6', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-03-10 11:32:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '37', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-10 11:36:26'

EXEC Usp_InsertFeedback @Order_Id = '37', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Return for Order 31
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('4','1','Packet was damaged'), ('10','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '31', @Return_Date_Time = '2026-03-10 18:12:18', @Return_Products = @Return_Items

-- Order 38
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1'), ('22','2')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-03-11 09:15:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '38', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-11 09:23:45'

EXEC Usp_InsertFeedback @Order_Id = '38', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 39
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('10','2'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '12', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-03-11 09:50:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '39', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-11 09:59:43'

EXEC Usp_InsertFeedback @Order_Id = '39', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Return for Order 30
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('29','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '30', @Return_Date_Time = '2026-03-12 14:23:52', @Return_Products = @Return_Items

-- Order 40
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-12 14:58:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '40', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-12 15:05:23'

EXEC Usp_InsertFeedback @Order_Id = '40', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 41
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','1'), ('12','1'), ('28','1'), ('13','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-03-12 17:40:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '41', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-12 17:50:26'

EXEC Usp_InsertFeedback @Order_Id = '41', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Return for Order 37
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('30','1','Better price available elsewhere')
EXEC Usp_InsertReturn @Order_Id = '37', @Return_Date_Time = '2026-03-13 16:55:26', @Return_Products = @Return_Items

-- Order 42
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','2'), ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-03-13 19:19:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '42', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-13 19:28:26'

EXEC Usp_InsertFeedback @Order_Id = '42', @Store_Rating = '1', @Cashier_Rating = '4', @Feedback_Detail = 'Staff was not very helpful'

-- Order 43
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','1'), ('7','2'), ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-03-14 10:47:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '43', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-14 10:57:23'

EXEC Usp_InsertFeedback @Order_Id = '43', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 44
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1'), ('17','1'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-03-15 11:30:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '44', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-15 11:34:37'

EXEC Usp_InsertFeedback @Order_Id = '44', @Store_Rating = '2', @Cashier_Rating = '1', @Feedback_Detail = 'Store was crowded and untidy'

-- Order 45
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('11','1'), ('30','1'), ('19','2')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-03-15 17:28:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '45', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-15 17:35:36'

EXEC Usp_InsertFeedback @Order_Id = '45', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 46
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','1'), ('14','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-03-16 13:59:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '46', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-16 14:05:54'

EXEC Usp_InsertFeedback @Order_Id = '46', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 47
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '23', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-19 09:52:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '47', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-19 09:55:36'

EXEC Usp_InsertFeedback @Order_Id = '47', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 48
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('26','1'), ('10','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-03-20 14:32:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '48', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-20 14:42:38'

EXEC Usp_InsertFeedback @Order_Id = '48', @Store_Rating = '1', @Cashier_Rating = '5', @Feedback_Detail = 'Billing queue was long'

-- Order 49
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','2'), ('23','1'), ('13','1')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-03-21 13:28:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '49', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-21 13:39:02'

EXEC Usp_InsertFeedback @Order_Id = '49', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 50
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','2'), ('14','1'), ('19','2'), ('10','1')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-03-21 13:59:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '50', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-21 14:03:27'

EXEC Usp_InsertFeedback @Order_Id = '50', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 51
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1'), ('33','1'), ('19','2')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-03-21 14:33:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '51', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-21 14:37:05'

EXEC Usp_InsertFeedback @Order_Id = '51', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 52
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','4')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-03-22 11:32:50', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '52', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-22 11:43:12'

EXEC Usp_InsertFeedback @Order_Id = '52', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 53
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('32','4'), ('15','3'), ('23','1'), ('25','1')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-03-22 20:44:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '53', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-22 20:53:18'

EXEC Usp_InsertFeedback @Order_Id = '53', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 54
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','2')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-03-23 15:36:58', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '54', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-23 15:43:59'

EXEC Usp_InsertFeedback @Order_Id = '54', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 55
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('10','4')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-03-23 17:07:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '55', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-23 17:12:24'

EXEC Usp_InsertFeedback @Order_Id = '55', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 56
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','3'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '24', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-03-24 18:46:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '56', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-24 18:55:37'

EXEC Usp_InsertFeedback @Order_Id = '56', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 57
DELETE FROM @Items
INSERT INTO @Items VALUES ('25','1')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-03-24 20:40:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '57', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-24 20:46:45'

EXEC Usp_InsertFeedback @Order_Id = '57', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 58
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','3'), ('21','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-03-26 19:23:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '58', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-26 19:33:18'

EXEC Usp_InsertFeedback @Order_Id = '58', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 59
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-03-27 10:10:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '59', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-27 10:14:31'

EXEC Usp_InsertFeedback @Order_Id = '59', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 60
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-03-27 17:26:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '60', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-27 17:30:18'

EXEC Usp_InsertFeedback @Order_Id = '60', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Store was crowded and untidy'

-- Order 61
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('34','1'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-03-28 09:49:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '61', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-28 09:51:57'

EXEC Usp_InsertFeedback @Order_Id = '61', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Average experience'

-- Order 62
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('30','2'), ('20','1'), ('17','2')
EXEC Usp_CreateOrder @Customer_Id = '26', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-03-28 10:21:31', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '62', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-03-28 10:29:38'

EXEC Usp_ProcessPayment @Order_Id = '62', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-03-28 10:31:01'

EXEC Usp_ProcessPayment @Order_Id = '62', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-28 10:35:49'

EXEC Usp_InsertFeedback @Order_Id = '62', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 63
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','3')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-03-28 13:21:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '63', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-28 13:23:31'

EXEC Usp_InsertFeedback @Order_Id = '63', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 64
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('34','2'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '28', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-03-28 17:08:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '64', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-28 17:18:20'

EXEC Usp_InsertFeedback @Order_Id = '64', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 65
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('12','3'), ('6','1'), ('7','3')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-03-31 21:21:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '65', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-03-31 21:32:15'

EXEC Usp_InsertFeedback @Order_Id = '65', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 66
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-04-01 19:02:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '66', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-01 19:08:01'

EXEC Usp_InsertFeedback @Order_Id = '66', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 67
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '10', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-04-02 12:25:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '67', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-02 12:31:28'

EXEC Usp_InsertFeedback @Order_Id = '67', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 68
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('25','2')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-03 14:45:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '68', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-03 14:55:10'

EXEC Usp_InsertFeedback @Order_Id = '68', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 69
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-04-04 12:50:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '69', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-04 12:52:56'

EXEC Usp_ProcessPayment @Order_Id = '69', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-04 12:56:53'

EXEC Usp_InsertFeedback @Order_Id = '69', @Store_Rating = '4', @Cashier_Rating = '2', @Feedback_Detail = 'Billing queue was long'

-- Order 70
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','1'), ('37','2'), ('17','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-04-04 14:04:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '70', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-04 14:09:38'

EXEC Usp_InsertFeedback @Order_Id = '70', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 71
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('10','4')
EXEC Usp_CreateOrder @Customer_Id = '6', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-04-04 17:33:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '71', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-04 17:40:33'

EXEC Usp_InsertFeedback @Order_Id = '71', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 72
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('19','1')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-04-04 21:12:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '72', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-04 21:17:59'

EXEC Usp_InsertFeedback @Order_Id = '72', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 73
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','2'), ('18','1'), ('27','1'), ('10','4'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-04-05 13:03:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '73', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-05 13:05:33'

EXEC Usp_ProcessPayment @Order_Id = '73', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-05 13:08:49'

EXEC Usp_InsertFeedback @Order_Id = '73', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 74
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','3'), ('14','1'), ('16','4')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-04-06 09:39:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '74', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-06 09:46:28'

EXEC Usp_InsertFeedback @Order_Id = '74', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 75
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','4'), ('34','2')
EXEC Usp_CreateOrder @Customer_Id = '30', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-04-06 14:39:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '75', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-06 14:50:27'

EXEC Usp_InsertFeedback @Order_Id = '75', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 76
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-04-06 21:12:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '76', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-06 21:19:21'

EXEC Usp_InsertFeedback @Order_Id = '76', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 77
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('6','1'), ('7','1'), ('11','4')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-04-07 16:38:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '77', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-07 16:45:41'

EXEC Usp_InsertFeedback @Order_Id = '77', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 78
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','2'), ('34','1'), ('13','3')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-04-09 17:45:44', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '78', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-09 17:52:54'

EXEC Usp_InsertFeedback @Order_Id = '78', @Store_Rating = '4', @Cashier_Rating = '2', @Feedback_Detail = 'Some products were out of place'

-- Order 79
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1'), ('32','1'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-04-10 12:38:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '79', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-10 12:45:57'

EXEC Usp_InsertFeedback @Order_Id = '79', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 80
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '30', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-04-11 14:53:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '80', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-11 14:56:11'

EXEC Usp_InsertFeedback @Order_Id = '80', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 81
DELETE FROM @Items
INSERT INTO @Items VALUES ('25','2')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-04-11 21:08:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '81', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-11 21:15:18'

EXEC Usp_InsertFeedback @Order_Id = '81', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 82
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('30','1')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-12 09:02:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '82', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-12 09:12:55'

EXEC Usp_InsertFeedback @Order_Id = '82', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 83
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('13','2'), ('21','1'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-04-12 18:59:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '83', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-12 19:08:59'

EXEC Usp_InsertFeedback @Order_Id = '83', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 84
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('32','1'), ('37','2')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-04-12 19:45:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '84', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-12 19:51:38'

EXEC Usp_InsertFeedback @Order_Id = '84', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 85
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('6','2')
EXEC Usp_CreateOrder @Customer_Id = '23', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-04-13 19:08:11', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '85', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-13 19:12:33'

EXEC Usp_InsertFeedback @Order_Id = '85', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 86
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-04-13 19:46:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '86', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-13 19:55:26'

EXEC Usp_InsertFeedback @Order_Id = '86', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 87
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('17','1'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-04-14 17:49:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '87', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-14 17:58:22'

EXEC Usp_InsertFeedback @Order_Id = '87', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 88
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '35', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-04-15 12:19:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '88', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-15 12:21:54'

EXEC Usp_InsertFeedback @Order_Id = '88', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 89
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','1')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-04-16 11:13:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '89', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-16 11:17:38'

EXEC Usp_InsertFeedback @Order_Id = '89', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 90
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','2'), ('20','2'), ('11','2'), ('23','2')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-04-16 20:24:58', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '90', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-16 20:34:08'

EXEC Usp_InsertFeedback @Order_Id = '90', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 91
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('17','1'), ('13','1'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-04-17 15:00:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '91', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-17 15:03:46'

EXEC Usp_InsertFeedback @Order_Id = '91', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 92
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','3')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-17 19:16:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '92', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-17 19:26:28'

EXEC Usp_ProcessPayment @Order_Id = '92', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-17 19:31:12'

EXEC Usp_ProcessPayment @Order_Id = '92', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-17 19:33:43'

EXEC Usp_InsertFeedback @Order_Id = '92', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 93
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','3'), ('17','2')
EXEC Usp_CreateOrder @Customer_Id = '40', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-04-17 19:50:11', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '93', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-17 19:54:51'

EXEC Usp_InsertFeedback @Order_Id = '93', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 94
DELETE FROM @Items
INSERT INTO @Items VALUES ('3','1'), ('22','1'), ('36','1'), ('28','3')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-04-18 15:06:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '94', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-18 15:14:42'

-- Order 95
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','2'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-18 15:21:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '95', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-18 15:28:15'

EXEC Usp_InsertFeedback @Order_Id = '94', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 96
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','4'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '29', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-04-18 15:35:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '96', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-18 15:45:36'

EXEC Usp_InsertFeedback @Order_Id = '96', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

EXEC Usp_InsertFeedback @Order_Id = '95', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 97
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','2'), ('28','2'), ('19','1')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-04-19 11:47:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '97', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-19 11:54:28'

EXEC Usp_InsertFeedback @Order_Id = '97', @Store_Rating = '5', @Cashier_Rating = '1', @Feedback_Detail = 'Okay service, can improve'

-- Order 98
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-04-19 16:46:41', @Order_Products = @Items

-- Order 99
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('23','1'), ('18','3')
EXEC Usp_CreateOrder @Customer_Id = '31', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-19 16:51:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '98', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-19 16:51:34'

EXEC Usp_InsertFeedback @Order_Id = '98', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

EXEC Usp_ProcessPayment @Order_Id = '99', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-19 17:01:03'

EXEC Usp_InsertFeedback @Order_Id = '99', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 100
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-04-19 17:22:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '100', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-19 17:31:01'

EXEC Usp_InsertFeedback @Order_Id = '100', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Return for Order 87
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('17','1','Duplicate purchase'), ('36','1','Colour faded after first wash')
EXEC Usp_InsertReturn @Order_Id = '87', @Return_Date_Time = '2026-04-20 09:57:22', @Return_Products = @Return_Items

-- Return for Order 99
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('23','1','Packet was damaged'), ('18','2','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '99', @Return_Date_Time = '2026-04-20 21:45:03', @Return_Products = @Return_Items

-- Return for Order 91
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('13','1','Packet was damaged')
EXEC Usp_InsertReturn @Order_Id = '91', @Return_Date_Time = '2026-04-21 18:18:46', @Return_Products = @Return_Items

-- Order 101
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('7','2'), ('25','2')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-04-21 21:02:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '101', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-21 21:06:56'

EXEC Usp_InsertFeedback @Order_Id = '101', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 102
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','1'), ('12','3'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '26', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-04-22 15:58:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '102', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-22 16:08:07'

EXEC Usp_InsertFeedback @Order_Id = '102', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 103
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1'), ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '35', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-04-23 09:06:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '103', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 09:10:33'

EXEC Usp_InsertFeedback @Order_Id = '103', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 104
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-04-23 15:24:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '104', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-23 15:32:48'

EXEC Usp_ProcessPayment @Order_Id = '104', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 15:34:00'

EXEC Usp_InsertFeedback @Order_Id = '104', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 105
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('31','1'), ('5','3'), ('2','1'), ('9','3')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-04-23 17:01:06', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '105', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 17:03:54'

EXEC Usp_InsertFeedback @Order_Id = '105', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 106
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('35','3')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-04-23 19:32:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '106', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 19:40:43'

-- Order 107
DELETE FROM @Items
INSERT INTO @Items VALUES ('3','2'), ('30','1')
EXEC Usp_CreateOrder @Customer_Id = '30', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-04-23 19:46:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '107', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 19:53:32'

EXEC Usp_InsertFeedback @Order_Id = '106', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_InsertFeedback @Order_Id = '107', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 108
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('29','1'), ('14','2'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-23 21:13:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '108', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-04-23 21:18:54'

EXEC Usp_ProcessPayment @Order_Id = '108', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-23 21:20:11'

EXEC Usp_InsertFeedback @Order_Id = '108', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 109
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '29', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-04-25 16:25:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '109', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-25 16:35:57'

EXEC Usp_InsertFeedback @Order_Id = '109', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Return for Order 90
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('11','2','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '90', @Return_Date_Time = '2026-04-25 21:43:08', @Return_Products = @Return_Items

-- Order 110
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-04-26 14:29:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '110', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-26 14:35:31'

EXEC Usp_InsertFeedback @Order_Id = '110', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 111
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('11','1'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-04-26 17:48:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '111', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-26 17:56:40'

EXEC Usp_InsertFeedback @Order_Id = '111', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 112
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1'), ('32','1'), ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-04-28 11:45:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '112', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-28 11:49:32'

EXEC Usp_InsertFeedback @Order_Id = '112', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 113
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('36','2')
EXEC Usp_CreateOrder @Customer_Id = '18', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-04-29 11:55:52', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '113', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-29 12:03:20'

EXEC Usp_InsertFeedback @Order_Id = '113', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 114
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('30','1'), ('18','4')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-04-29 21:20:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '114', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-29 21:28:39'

EXEC Usp_InsertFeedback @Order_Id = '114', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 115
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('7','2')
EXEC Usp_CreateOrder @Customer_Id = '6', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-04-30 13:39:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '115', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-04-30 13:47:18'

EXEC Usp_InsertFeedback @Order_Id = '115', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 116
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('17','2'), ('16','4'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-05-02 14:34:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '116', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-02 14:38:53'

EXEC Usp_InsertFeedback @Order_Id = '116', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 117
DELETE FROM @Items
INSERT INTO @Items VALUES ('24','1'), ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-05-03 17:23:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '117', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-03 17:28:08'

EXEC Usp_InsertFeedback @Order_Id = '117', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 118
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1')
EXEC Usp_CreateOrder @Customer_Id = '24', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-04 18:09:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '118', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-04 18:15:24'

EXEC Usp_InsertFeedback @Order_Id = '118', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 119
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-05-05 11:04:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '119', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-05 11:12:29'

EXEC Usp_InsertFeedback @Order_Id = '119', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 120
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','3')
EXEC Usp_CreateOrder @Customer_Id = '41', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-05-07 10:34:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '120', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-05-07 10:39:19'

EXEC Usp_ProcessPayment @Order_Id = '120', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-05-07 10:42:24'

EXEC Usp_ProcessPayment @Order_Id = '120', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-07 10:47:21'

EXEC Usp_InsertFeedback @Order_Id = '120', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 121
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-05-07 14:01:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '121', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-07 14:10:19'

EXEC Usp_InsertFeedback @Order_Id = '121', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 122
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '31', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-05-09 10:45:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '122', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-09 10:55:27'

EXEC Usp_InsertFeedback @Order_Id = '122', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 123
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-05-09 20:15:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '123', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-09 20:20:20'

EXEC Usp_InsertFeedback @Order_Id = '123', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 124
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-05-09 20:37:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '124', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-09 20:39:31'

EXEC Usp_InsertFeedback @Order_Id = '124', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 125
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('22','2'), ('3','1'), ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-10 10:46:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '125', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-10 10:52:56'

EXEC Usp_InsertFeedback @Order_Id = '125', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 126
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-10 11:39:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '126', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-10 11:44:09'

EXEC Usp_InsertFeedback @Order_Id = '126', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 127
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','3'), ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '23', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-10 14:26:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '127', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-05-10 14:34:43'

EXEC Usp_ProcessPayment @Order_Id = '127', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-10 14:38:15'

EXEC Usp_InsertFeedback @Order_Id = '127', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 128
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('23','1'), ('10','1'), ('17','1'), ('21','3')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-10 17:05:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '128', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-10 17:16:00'

EXEC Usp_InsertFeedback @Order_Id = '128', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 129
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','3')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-05-10 19:03:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '129', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-10 19:09:31'

EXEC Usp_InsertFeedback @Order_Id = '129', @Store_Rating = '3', @Cashier_Rating = '1', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 130
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-05-11 21:22:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '130', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-11 21:31:16'

EXEC Usp_InsertFeedback @Order_Id = '130', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 131
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1'), ('7','1'), ('30','2')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-05-12 18:46:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '131', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-12 18:57:05'

EXEC Usp_InsertFeedback @Order_Id = '131', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 132
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-13 09:13:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '132', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-13 09:16:08'

EXEC Usp_InsertFeedback @Order_Id = '132', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 133
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-13 10:28:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '133', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-13 10:34:11'

EXEC Usp_InsertFeedback @Order_Id = '133', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 134
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','4'), ('20','2')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-05-13 19:07:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '134', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-13 19:12:20'

EXEC Usp_InsertFeedback @Order_Id = '134', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 135
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('30','2'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-05-13 20:35:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '135', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-13 20:37:38'

-- Order 136
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('25','1'), ('13','2'), ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-13 20:59:20', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '135', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

EXEC Usp_ProcessPayment @Order_Id = '136', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-13 21:07:11'

EXEC Usp_InsertFeedback @Order_Id = '136', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 137
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('21','2')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-05-14 13:52:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '137', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-14 13:57:44'

EXEC Usp_InsertFeedback @Order_Id = '137', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 138
DELETE FROM @Items
INSERT INTO @Items VALUES ('25','2'), ('18','1'), ('23','1'), ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-05-14 17:25:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '138', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-14 17:35:34'

EXEC Usp_InsertFeedback @Order_Id = '138', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 139
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('16','2'), ('22','1'), ('11','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '28', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-05-15 17:33:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '139', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-15 17:36:43'

EXEC Usp_InsertFeedback @Order_Id = '139', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 140
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1'), ('2','2'), ('28','3')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-05-15 21:15:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '140', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-05-15 21:17:58'

EXEC Usp_ProcessPayment @Order_Id = '140', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-15 21:22:01'

EXEC Usp_InsertFeedback @Order_Id = '140', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 141
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '53', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-05-16 13:27:08', @Order_Products = @Items

-- Order 142
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('7','2'), ('10','1')
EXEC Usp_CreateOrder @Customer_Id = '10', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-05-16 13:30:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '142', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-16 13:35:01'

EXEC Usp_ProcessPayment @Order_Id = '141', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-16 13:35:33'

EXEC Usp_InsertFeedback @Order_Id = '142', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

EXEC Usp_InsertFeedback @Order_Id = '141', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 143
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-16 14:44:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '143', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-16 14:55:17'

EXEC Usp_InsertFeedback @Order_Id = '143', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 144
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','4'), ('16','1')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-16 19:20:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '144', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-16 19:28:25'

EXEC Usp_InsertFeedback @Order_Id = '144', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 145
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-05-17 18:23:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '145', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-17 18:25:33'

EXEC Usp_InsertFeedback @Order_Id = '145', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 146
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-05-18 14:12:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '146', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-18 14:19:28'

EXEC Usp_InsertFeedback @Order_Id = '146', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 147
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','3'), ('18','2'), ('26','1'), ('37','3'), ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '39', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-05-22 17:24:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '147', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-22 17:34:45'

EXEC Usp_InsertFeedback @Order_Id = '147', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 148
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','2'), ('23','1'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '24', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-05-23 09:15:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '148', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-23 09:24:56'

EXEC Usp_InsertFeedback @Order_Id = '148', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 149
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('13','4'), ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-23 16:08:52', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '149', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-23 16:15:05'

EXEC Usp_InsertFeedback @Order_Id = '149', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 150
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('17','1'), ('13','4')
EXEC Usp_CreateOrder @Customer_Id = '54', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-05-23 19:07:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '150', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-23 19:18:30'

EXEC Usp_InsertFeedback @Order_Id = '150', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 151
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-24 09:58:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '151', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-24 10:03:36'

EXEC Usp_InsertFeedback @Order_Id = '151', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Okay service, can improve'

-- Order 152
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '52', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-05-24 13:35:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '152', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-24 13:38:25'

EXEC Usp_InsertFeedback @Order_Id = '152', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 153
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('18','2'), ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-05-24 16:07:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '153', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-24 16:13:59'

EXEC Usp_InsertFeedback @Order_Id = '153', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 154
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','2'), ('22','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-05-24 20:20:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '154', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-24 20:29:22'

EXEC Usp_InsertFeedback @Order_Id = '154', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 155
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','4'), ('12','2'), ('33','2'), ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '56', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-05-25 10:55:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '155', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-25 10:58:38'

EXEC Usp_InsertFeedback @Order_Id = '155', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 156
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-05-25 21:17:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '156', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-25 21:25:41'

EXEC Usp_InsertFeedback @Order_Id = '156', @Store_Rating = '4', @Cashier_Rating = '1', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 157
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-05-26 12:25:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '157', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-26 12:31:30'

EXEC Usp_InsertFeedback @Order_Id = '157', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 158
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','1'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-05-26 20:23:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '158', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-26 20:26:36'

EXEC Usp_InsertFeedback @Order_Id = '158', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 159
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1'), ('8','3'), ('19','2'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-05-27 11:53:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '159', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-27 12:01:33'

EXEC Usp_InsertFeedback @Order_Id = '159', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 160
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '63', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-05-27 13:14:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '160', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-27 13:16:16'

EXEC Usp_InsertFeedback @Order_Id = '160', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 161
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1'), ('20','3')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-05-27 17:52:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '161', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-27 17:56:39'

EXEC Usp_InsertFeedback @Order_Id = '161', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 162
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('2','2'), ('25','2'), ('23','1'), ('4','2')
EXEC Usp_CreateOrder @Customer_Id = '41', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-05-28 18:30:44', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '162', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-28 18:39:53'

EXEC Usp_InsertFeedback @Order_Id = '162', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 163
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('25','2'), ('31','2'), ('36','1')
EXEC Usp_CreateOrder @Customer_Id = '29', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-05-29 15:02:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '163', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-29 15:08:55'

EXEC Usp_InsertFeedback @Order_Id = '163', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 164
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','2')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-05-29 16:10:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '164', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-29 16:20:35'

EXEC Usp_InsertFeedback @Order_Id = '164', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Billing queue was long'

-- Order 165
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-05-29 20:24:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '165', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-29 20:33:59'

EXEC Usp_InsertFeedback @Order_Id = '165', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 166
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '64', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-05-30 11:20:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '166', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-30 11:28:11'

EXEC Usp_InsertFeedback @Order_Id = '166', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 167
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '31', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-05-31 10:25:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '167', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-31 10:34:30'

EXEC Usp_InsertFeedback @Order_Id = '167', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 168
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-05-31 15:49:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '168', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-31 15:56:17'

EXEC Usp_InsertFeedback @Order_Id = '168', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 169
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '66', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-05-31 16:38:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '169', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-31 16:45:54'

EXEC Usp_InsertFeedback @Order_Id = '169', @Store_Rating = '4', @Cashier_Rating = '1', @Feedback_Detail = 'Staff was not very helpful'

-- Order 170
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3')
EXEC Usp_CreateOrder @Customer_Id = '65', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-05-31 19:44:44', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '170', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-05-31 19:54:58'

EXEC Usp_InsertFeedback @Order_Id = '170', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 171
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('8','4'), ('14','2'), ('15','3')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-06-02 11:29:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '171', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-02 11:33:02'

EXEC Usp_InsertFeedback @Order_Id = '171', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 172
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('7','2')
EXEC Usp_CreateOrder @Customer_Id = '58', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-06-02 14:34:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '172', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-02 14:38:52'

EXEC Usp_InsertFeedback @Order_Id = '172', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 173
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '68', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-06-04 09:54:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '173', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-04 10:00:41'

EXEC Usp_InsertFeedback @Order_Id = '173', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 174
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('9','2'), ('18','2'), ('33','2'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '70', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-06-04 15:19:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '174', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-04 15:24:33'

EXEC Usp_InsertFeedback @Order_Id = '174', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Okay service, can improve'

-- Order 175
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('3','3'), ('4','1'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-06-05 11:20:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '175', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-05 11:30:33'

EXEC Usp_InsertFeedback @Order_Id = '175', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 176
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2')
EXEC Usp_CreateOrder @Customer_Id = '23', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-06-05 13:18:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '176', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-05 13:23:02'

EXEC Usp_InsertFeedback @Order_Id = '176', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Return for Order 161
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('20','1','Bought by mistake')
EXEC Usp_InsertReturn @Order_Id = '161', @Return_Date_Time = '2026-06-05 20:55:39', @Return_Products = @Return_Items

-- Order 177
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '51', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-06-06 12:17:56', @Order_Products = @Items

-- Order 178
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('26','2'), ('17','1'), ('11','1'), ('38','3')
EXEC Usp_CreateOrder @Customer_Id = '49', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-06-06 12:24:52', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '177', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-06 12:27:27'

EXEC Usp_ProcessPayment @Order_Id = '178', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-06 12:32:59'

EXEC Usp_ProcessPayment @Order_Id = '178', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-06 12:36:26'

EXEC Usp_InsertFeedback @Order_Id = '177', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '178', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Return for Order 169
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('8','1','Seal was broken')
EXEC Usp_InsertReturn @Order_Id = '169', @Return_Date_Time = '2026-06-06 21:21:54', @Return_Products = @Return_Items

-- Order 179
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-06-07 10:09:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '179', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-07 10:17:06'

EXEC Usp_InsertFeedback @Order_Id = '179', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 180
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '50', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-06-07 16:01:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '180', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-07 16:06:02'

EXEC Usp_InsertFeedback @Order_Id = '180', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Return for Order 169
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('8','1','Product was expired')
EXEC Usp_InsertReturn @Order_Id = '169', @Return_Date_Time = '2026-06-07 21:31:54', @Return_Products = @Return_Items

-- Order 181
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('23','2'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-06-08 10:13:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '181', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-08 10:22:12'

EXEC Usp_InsertFeedback @Order_Id = '181', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 182
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','3'), ('8','2'), ('26','1'), ('17','2')
EXEC Usp_CreateOrder @Customer_Id = '62', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-06-08 14:49:11', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '182', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-08 14:51:36'

EXEC Usp_InsertFeedback @Order_Id = '182', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 183
DELETE FROM @Items
INSERT INTO @Items VALUES ('31','1'), ('28','2')
EXEC Usp_CreateOrder @Customer_Id = '71', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-06-08 17:08:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '183', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-08 17:13:16'

EXEC Usp_InsertFeedback @Order_Id = '183', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Billing queue was long'

-- Order 184
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-06-08 21:30:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '184', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-08 21:40:03'

EXEC Usp_InsertFeedback @Order_Id = '184', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 185
DELETE FROM @Items
INSERT INTO @Items VALUES ('24','1'), ('28','1'), ('34','2'), ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-06-09 18:57:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '185', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-09 19:00:25'

EXEC Usp_InsertFeedback @Order_Id = '185', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 186
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('32','1')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-06-10 15:21:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '186', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-10 15:27:56'

EXEC Usp_InsertFeedback @Order_Id = '186', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 187
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3'), ('12','4'), ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '35', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-06-10 18:07:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '187', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-10 18:13:28'

EXEC Usp_InsertFeedback @Order_Id = '187', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 188
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '24', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-06-10 21:09:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '188', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-10 21:12:40'

EXEC Usp_InsertFeedback @Order_Id = '188', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 189
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '71', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-06-11 16:36:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '189', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-11 16:45:28'

-- Order 190
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1'), ('31','2'), ('32','2'), ('8','2'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '40', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-06-11 16:53:40', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '189', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

EXEC Usp_ProcessPayment @Order_Id = '190', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-11 16:57:17'

EXEC Usp_ProcessPayment @Order_Id = '190', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-11 17:00:14'

EXEC Usp_InsertFeedback @Order_Id = '190', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 191
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '39', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-06-11 18:26:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '191', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-11 18:37:34'

EXEC Usp_ProcessPayment @Order_Id = '191', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-11 18:41:21'

EXEC Usp_InsertFeedback @Order_Id = '191', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 192
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','2'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-06-12 15:30:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '192', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-12 15:38:44'

EXEC Usp_InsertFeedback @Order_Id = '192', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 193
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '13', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-06-12 16:11:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '193', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-12 16:13:50'

EXEC Usp_InsertFeedback @Order_Id = '193', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 194
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('35','1'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '56', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-06-12 18:31:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '194', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-12 18:39:16'

EXEC Usp_InsertFeedback @Order_Id = '194', @Store_Rating = '3', @Cashier_Rating = '1', @Feedback_Detail = 'Store was crowded and untidy'

-- Order 195
DELETE FROM @Items
INSERT INTO @Items VALUES ('29','1'), ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-06-13 14:18:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '195', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-13 14:26:35'

-- Order 196
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '30', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-06-13 14:53:07', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '195', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

EXEC Usp_ProcessPayment @Order_Id = '196', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-13 14:56:29'

-- Order 197
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','3'), ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '64', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-06-14 14:25:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '197', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-14 14:34:21'

EXEC Usp_InsertFeedback @Order_Id = '197', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 198
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('5','1'), ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-06-14 16:02:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '198', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-14 16:07:27'

EXEC Usp_InsertFeedback @Order_Id = '198', @Store_Rating = '1', @Cashier_Rating = '5', @Feedback_Detail = 'Average experience'

-- Return for Order 178
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('11','1','Quality not as expected')
EXEC Usp_InsertReturn @Order_Id = '178', @Return_Date_Time = '2026-06-14 17:38:26', @Return_Products = @Return_Items

-- Order 199
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '75', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-06-15 16:58:27', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '199', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-15 17:02:27'

EXEC Usp_InsertFeedback @Order_Id = '199', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 200
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('1','1')
EXEC Usp_CreateOrder @Customer_Id = '18', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-06-15 19:42:03', @Order_Products = @Items

-- Order 201
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('32','1')
EXEC Usp_CreateOrder @Customer_Id = '68', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-06-15 19:44:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '200', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-15 19:47:16'

EXEC Usp_ProcessPayment @Order_Id = '200', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-15 19:50:42'

EXEC Usp_ProcessPayment @Order_Id = '201', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-15 19:51:46'

EXEC Usp_InsertFeedback @Order_Id = '200', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Nice store, staff was helpful'

EXEC Usp_InsertFeedback @Order_Id = '201', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 202
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('27','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-06-15 21:21:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '202', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-15 21:30:21'

EXEC Usp_InsertFeedback @Order_Id = '202', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 203
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1')
EXEC Usp_CreateOrder @Customer_Id = '40', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-06-16 19:33:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '203', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-16 19:39:41'

EXEC Usp_InsertFeedback @Order_Id = '203', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Return for Order 197
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('23','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '197', @Return_Date_Time = '2026-06-16 21:14:21', @Return_Products = @Return_Items

-- Order 204
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','3')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-06-17 16:56:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '204', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-17 16:59:38'

-- Order 205
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1'), ('9','2'), ('3','1'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-06-17 17:06:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '205', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-17 17:13:00'

EXEC Usp_InsertFeedback @Order_Id = '205', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

EXEC Usp_InsertFeedback @Order_Id = '204', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 206
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','2')
EXEC Usp_CreateOrder @Customer_Id = '28', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-06-17 19:56:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '206', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-17 20:02:51'

EXEC Usp_InsertFeedback @Order_Id = '206', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 207
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('30','1'), ('14','2'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '83', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-06-18 11:03:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '207', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-18 11:08:09'

EXEC Usp_ProcessPayment @Order_Id = '207', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-18 11:11:29'

EXEC Usp_InsertFeedback @Order_Id = '207', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 208
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','4'), ('38','1')
EXEC Usp_CreateOrder @Customer_Id = '72', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-06-18 13:55:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '208', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-18 13:58:33'

EXEC Usp_InsertFeedback @Order_Id = '208', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 209
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-06-19 17:07:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '209', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-19 17:10:56'

EXEC Usp_InsertFeedback @Order_Id = '209', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Staff was not very helpful'

-- Order 210
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','1')
EXEC Usp_CreateOrder @Customer_Id = '26', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-06-20 15:56:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '210', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-20 16:01:48'

EXEC Usp_ProcessPayment @Order_Id = '210', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-20 16:04:07'

EXEC Usp_ProcessPayment @Order_Id = '210', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-20 16:05:15'

EXEC Usp_InsertFeedback @Order_Id = '210', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 211
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-06-20 18:06:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '211', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-20 18:14:01'

EXEC Usp_InsertFeedback @Order_Id = '211', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Return for Order 208
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('38','1','Colour faded after first wash'), ('9','2','Bought by mistake')
EXEC Usp_InsertReturn @Order_Id = '208', @Return_Date_Time = '2026-06-20 18:31:33', @Return_Products = @Return_Items

-- Order 212
DELETE FROM @Items
INSERT INTO @Items VALUES ('3','1'), ('6','1'), ('10','2'), ('21','2'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-06-20 21:21:56', @Order_Products = @Items

-- Order 213
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('36','2'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '52', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-06-20 21:27:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '212', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-20 21:30:09'

EXEC Usp_ProcessPayment @Order_Id = '213', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-20 21:31:23'

EXEC Usp_ProcessPayment @Order_Id = '213', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-20 21:33:44'

EXEC Usp_InsertFeedback @Order_Id = '212', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '213', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Friendly cashier'

-- Order 214
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('11','1'), ('31','1')
EXEC Usp_CreateOrder @Customer_Id = '59', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-06-21 10:01:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '214', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-21 10:11:34'

EXEC Usp_InsertFeedback @Order_Id = '214', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 215
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2')
EXEC Usp_CreateOrder @Customer_Id = '75', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-06-21 12:30:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '215', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-21 12:40:53'

EXEC Usp_InsertFeedback @Order_Id = '215', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 216
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','1'), ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '54', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-06-21 20:30:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '216', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-21 20:33:30'

EXEC Usp_ProcessPayment @Order_Id = '216', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-21 20:35:14'

EXEC Usp_InsertFeedback @Order_Id = '216', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 217
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3'), ('8','1'), ('19','3')
EXEC Usp_CreateOrder @Customer_Id = '70', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-06-23 16:57:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '217', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-23 17:06:10'

EXEC Usp_ProcessPayment @Order_Id = '217', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-23 17:09:41'

EXEC Usp_InsertFeedback @Order_Id = '217', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 218
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('8','1'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '78', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-06-24 15:50:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '218', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-24 15:58:11'

EXEC Usp_ProcessPayment @Order_Id = '218', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-24 16:01:12'

EXEC Usp_InsertFeedback @Order_Id = '218', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 219
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('3','2'), ('2','3'), ('33','2'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-06-25 12:17:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '219', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-25 12:23:06'

EXEC Usp_InsertFeedback @Order_Id = '219', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 220
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('22','1'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-06-25 16:11:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '220', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-25 16:13:33'

EXEC Usp_InsertFeedback @Order_Id = '220', @Store_Rating = '1', @Cashier_Rating = '2', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 221
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('10','2'), ('35','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-06-25 20:27:00', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '221', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-25 20:34:23'

EXEC Usp_InsertFeedback @Order_Id = '221', @Store_Rating = '2', @Cashier_Rating = '2', @Feedback_Detail = 'Staff was not very helpful'

-- Order 222
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('9','1'), ('21','2'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '49', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-06-27 10:18:04', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '222', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-27 10:27:59'

EXEC Usp_InsertFeedback @Order_Id = '222', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 223
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '72', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-06-27 11:05:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '223', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-27 11:16:02'

EXEC Usp_InsertFeedback @Order_Id = '223', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 224
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','2'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '35', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-06-27 14:28:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '224', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-27 14:31:34'

EXEC Usp_InsertFeedback @Order_Id = '224', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 225
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','1'), ('10','1'), ('12','2'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '52', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-06-27 17:41:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '225', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-27 17:48:49'

EXEC Usp_InsertFeedback @Order_Id = '225', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 226
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '85', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-06-28 12:58:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '226', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-28 13:04:25'

EXEC Usp_InsertFeedback @Order_Id = '226', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 227
DELETE FROM @Items
INSERT INTO @Items VALUES ('38','2'), ('3','1')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-06-29 09:26:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '227', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-29 09:32:41'

EXEC Usp_InsertFeedback @Order_Id = '227', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 228
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '61', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-06-29 11:55:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '228', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-06-29 12:04:50'

EXEC Usp_ProcessPayment @Order_Id = '228', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-29 12:08:15'

EXEC Usp_InsertFeedback @Order_Id = '228', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 229
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '64', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-06-30 10:16:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '229', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-30 10:25:09'

EXEC Usp_InsertFeedback @Order_Id = '229', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 230
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','2'), ('6','3'), ('8','1'), ('25','3'), ('34','3')
EXEC Usp_CreateOrder @Customer_Id = '59', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-06-30 11:28:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '230', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-06-30 11:37:31'

EXEC Usp_InsertFeedback @Order_Id = '230', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 231
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('1','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '39', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-01 13:52:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '231', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-01 13:54:59'

EXEC Usp_InsertFeedback @Order_Id = '231', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 232
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('13','3')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-07-02 15:41:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '232', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-02 15:44:02'

EXEC Usp_InsertFeedback @Order_Id = '232', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

-- Order 233
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('20','1'), ('31','2')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-07-03 13:07:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '233', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-03 13:11:26'

EXEC Usp_InsertFeedback @Order_Id = '233', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Return for Order 226
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('8','1','Seal was broken'), ('11','2','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '226', @Return_Date_Time = '2026-07-03 13:48:25', @Return_Products = @Return_Items

-- Order 234
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','4'), ('25','1')
EXEC Usp_CreateOrder @Customer_Id = '77', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-03 21:29:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '234', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-03 21:33:57'

EXEC Usp_InsertFeedback @Order_Id = '234', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 235
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('11','1'), ('37','1'), ('2','1'), ('22','2')
EXEC Usp_CreateOrder @Customer_Id = '77', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-07-04 18:39:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '235', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-04 18:46:53'

EXEC Usp_InsertFeedback @Order_Id = '235', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 236
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '23', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-07-04 19:25:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '236', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-04 19:28:58'

EXEC Usp_ProcessPayment @Order_Id = '236', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-04 19:32:35'

EXEC Usp_InsertFeedback @Order_Id = '236', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Billing queue was long'

-- Order 237
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','2'), ('7','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '87', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-07-05 11:36:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '237', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-05 11:43:45'

EXEC Usp_InsertFeedback @Order_Id = '237', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 238
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-07-05 19:29:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '238', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-05 19:32:15'

EXEC Usp_ProcessPayment @Order_Id = '238', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-05 19:34:34'

EXEC Usp_ProcessPayment @Order_Id = '238', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-05 19:39:16'

EXEC Usp_InsertFeedback @Order_Id = '238', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 239
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','2'), ('5','1'), ('16','1')
EXEC Usp_CreateOrder @Customer_Id = '71', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-07-06 12:31:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '239', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-06 12:35:27'

EXEC Usp_InsertFeedback @Order_Id = '239', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 240
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','2'), ('20','2'), ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '58', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-07-08 18:59:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '240', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-08 19:07:33'

EXEC Usp_InsertFeedback @Order_Id = '240', @Store_Rating = '1', @Cashier_Rating = '5', @Feedback_Detail = 'Billing queue was long'

-- Order 241
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','3'), ('12','1'), ('22','2')
EXEC Usp_CreateOrder @Customer_Id = '70', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-07-08 20:25:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '241', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-08 20:31:54'

EXEC Usp_InsertFeedback @Order_Id = '241', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 242
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '28', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-07-09 13:39:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '242', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-09 13:44:35'

EXEC Usp_InsertFeedback @Order_Id = '242', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 243
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('24','1')
EXEC Usp_CreateOrder @Customer_Id = '104', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-07-09 18:18:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '243', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-09 18:28:11'

EXEC Usp_InsertFeedback @Order_Id = '243', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 244
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '6', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-07-12 09:56:14', @Order_Products = @Items

-- Order 245
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('5','2'), ('11','2'), ('12','4'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '80', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-07-12 10:00:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '244', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 10:04:39'

EXEC Usp_ProcessPayment @Order_Id = '245', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 10:09:26'

EXEC Usp_InsertFeedback @Order_Id = '245', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '244', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 246
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','3'), ('8','2'), ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '90', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-07-12 12:37:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '246', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 12:44:28'

EXEC Usp_InsertFeedback @Order_Id = '246', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 247
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('23','2')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-07-12 16:10:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '247', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 16:18:40'

-- Order 248
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','2'), ('10','3')
EXEC Usp_CreateOrder @Customer_Id = '58', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-07-12 16:40:08', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '247', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_ProcessPayment @Order_Id = '248', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 16:50:11'

EXEC Usp_InsertFeedback @Order_Id = '248', @Store_Rating = '1', @Cashier_Rating = '2', @Feedback_Detail = 'Staff was not very helpful'

-- Order 249
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('34','2'), ('5','1'), ('3','3')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-07-12 21:06:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '249', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-12 21:12:21'

EXEC Usp_InsertFeedback @Order_Id = '249', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 250
DELETE FROM @Items
INSERT INTO @Items VALUES ('38','1'), ('8','2'), ('13','4')
EXEC Usp_CreateOrder @Customer_Id = '29', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-07-14 11:28:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '250', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-14 11:34:30'

EXEC Usp_InsertFeedback @Order_Id = '250', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 251
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','4'), ('8','2'), ('38','2')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-07-14 14:38:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '251', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-14 14:47:27'

EXEC Usp_InsertFeedback @Order_Id = '251', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 252
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '79', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-07-15 12:52:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '252', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-15 12:57:22'

EXEC Usp_InsertFeedback @Order_Id = '252', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 253
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('19','1'), ('37','1'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-07-15 17:59:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '253', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-15 18:05:25'

EXEC Usp_InsertFeedback @Order_Id = '253', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 254
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '51', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-16 10:04:50', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '254', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-16 10:12:39'

EXEC Usp_InsertFeedback @Order_Id = '254', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 255
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-07-16 13:25:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '255', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-16 13:31:08'

EXEC Usp_InsertFeedback @Order_Id = '255', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Average experience'

-- Order 256
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','3'), ('13','2'), ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '91', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-07-16 14:11:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '256', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-16 14:17:15'

EXEC Usp_InsertFeedback @Order_Id = '256', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 257
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('34','2')
EXEC Usp_CreateOrder @Customer_Id = '103', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-07-16 19:33:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '257', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-16 19:41:35'

EXEC Usp_InsertFeedback @Order_Id = '257', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 258
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','3')
EXEC Usp_CreateOrder @Customer_Id = '36', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-07-17 10:44:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '258', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-17 10:49:42'

EXEC Usp_InsertFeedback @Order_Id = '258', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Some products were out of place'

-- Order 259
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '64', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-07-17 17:57:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '259', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-17 18:04:55'

EXEC Usp_ProcessPayment @Order_Id = '259', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-17 18:08:29'

EXEC Usp_InsertFeedback @Order_Id = '259', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Billing was slow and the queue was long'

-- Order 260
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('9','2'), ('35','1'), ('21','1'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '107', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-07-17 21:10:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '260', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-17 21:20:07'

EXEC Usp_InsertFeedback @Order_Id = '260', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 261
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1'), ('12','2'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '47', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-07-18 09:41:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '261', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-18 09:52:00'

EXEC Usp_ProcessPayment @Order_Id = '261', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-18 09:55:01'

-- Return for Order 249
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('34','1','Duplicate purchase'), ('16','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '249', @Return_Date_Time = '2026-07-18 09:55:21', @Return_Products = @Return_Items

EXEC Usp_InsertFeedback @Order_Id = '261', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Billing queue was long'

-- Order 262
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1'), ('8','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-07-18 13:19:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '262', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-18 13:27:20'

EXEC Usp_InsertFeedback @Order_Id = '262', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 263
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('17','3')
EXEC Usp_CreateOrder @Customer_Id = '36', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-07-18 19:07:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '263', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-18 19:15:45'

EXEC Usp_InsertFeedback @Order_Id = '263', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Return for Order 259
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('20','1','Bought by mistake')
EXEC Usp_InsertReturn @Order_Id = '259', @Return_Date_Time = '2026-07-18 21:15:29', @Return_Products = @Return_Items

-- Order 264
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','1'), ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '103', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-07-19 16:51:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '264', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-19 17:01:49'

EXEC Usp_InsertFeedback @Order_Id = '264', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 265
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','1'), ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-07-19 19:09:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '265', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-19 19:16:52'

-- Order 266
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('37','1'), ('11','2'), ('36','1')
EXEC Usp_CreateOrder @Customer_Id = '105', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-07-19 19:22:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '266', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-19 19:25:10'

EXEC Usp_InsertFeedback @Order_Id = '265', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

EXEC Usp_InsertFeedback @Order_Id = '266', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 267
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','3'), ('5','1'), ('37','2'), ('8','3')
EXEC Usp_CreateOrder @Customer_Id = '81', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-07-19 20:52:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '267', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-19 20:59:19'

EXEC Usp_ProcessPayment @Order_Id = '267', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-19 21:03:10'

EXEC Usp_InsertFeedback @Order_Id = '267', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 268
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('9','1'), ('11','1'), ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '87', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-07-20 10:24:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '268', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 10:27:06'

EXEC Usp_InsertFeedback @Order_Id = '268', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 269
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','1'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '95', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-07-20 15:23:06', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '269', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 15:30:55'

EXEC Usp_InsertFeedback @Order_Id = '269', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 270
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '107', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-07-20 16:11:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '270', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 16:18:26'

EXEC Usp_InsertFeedback @Order_Id = '270', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 271
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '26', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-07-20 18:10:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '271', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 18:17:41'

-- Order 272
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('38','1'), ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '111', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-07-20 18:29:59', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '271', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_ProcessPayment @Order_Id = '272', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 18:34:19'

EXEC Usp_InsertFeedback @Order_Id = '272', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 273
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','4')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-07-20 20:17:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '273', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-20 20:19:30'

EXEC Usp_InsertFeedback @Order_Id = '273', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 274
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('12','2'), ('8','1'), ('17','1')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-07-21 15:40:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '274', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-21 15:47:11'

EXEC Usp_InsertFeedback @Order_Id = '274', @Store_Rating = '1', @Cashier_Rating = '4', @Feedback_Detail = 'Staff was not very helpful'

-- Order 275
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','2'), ('25','1'), ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-07-21 18:52:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '275', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-21 18:58:43'

EXEC Usp_InsertFeedback @Order_Id = '275', @Store_Rating = '1', @Cashier_Rating = '5', @Feedback_Detail = 'Average experience'

-- Order 276
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','2')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-07-22 09:08:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '276', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-22 09:17:38'

EXEC Usp_InsertFeedback @Order_Id = '276', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Return for Order 259
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('6','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '259', @Return_Date_Time = '2026-07-22 09:58:29', @Return_Products = @Return_Items

-- Order 277
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('18','2'), ('23','1'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-22 13:55:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '277', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-22 14:01:44'

EXEC Usp_InsertFeedback @Order_Id = '277', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 278
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1'), ('3','1'), ('32','4')
EXEC Usp_CreateOrder @Customer_Id = '111', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-07-24 15:12:50', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '278', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-24 15:17:07'

EXEC Usp_ProcessPayment @Order_Id = '278', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-24 15:21:24'

-- Return for Order 260
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('21','1','Seal was broken')
EXEC Usp_InsertReturn @Order_Id = '260', @Return_Date_Time = '2026-07-25 09:02:07', @Return_Products = @Return_Items

-- Order 279
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','3'), ('25','1')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-07-25 11:57:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '279', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-25 12:00:31'

EXEC Usp_InsertFeedback @Order_Id = '279', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

-- Order 280
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('9','2'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '57', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-25 12:21:58', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '280', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-25 12:28:34'

EXEC Usp_InsertFeedback @Order_Id = '280', @Store_Rating = '3', @Cashier_Rating = '1', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 281
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-07-25 16:04:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '281', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-25 16:13:33'

EXEC Usp_ProcessPayment @Order_Id = '281', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-07-25 16:18:04'

EXEC Usp_ProcessPayment @Order_Id = '281', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-25 16:22:16'

EXEC Usp_InsertFeedback @Order_Id = '281', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 282
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '60', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-07-25 17:56:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '282', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-25 18:05:57'

EXEC Usp_InsertFeedback @Order_Id = '282', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 283
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('30','1'), ('14','1'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-07-25 18:56:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '283', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-25 19:04:28'

EXEC Usp_InsertFeedback @Order_Id = '283', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 284
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('21','2'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-07-26 12:27:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '284', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-26 12:37:16'

EXEC Usp_InsertFeedback @Order_Id = '284', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 285
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '40', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-07-26 21:16:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '285', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-26 21:26:10'

EXEC Usp_InsertFeedback @Order_Id = '285', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 286
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('8','3'), ('30','1')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-07-27 10:22:11', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '286', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-27 10:31:13'

EXEC Usp_InsertFeedback @Order_Id = '286', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 287
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','2'), ('9','1'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-07-27 16:54:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '287', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-27 17:01:40'

EXEC Usp_InsertFeedback @Order_Id = '287', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 288
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','3')
EXEC Usp_CreateOrder @Customer_Id = '35', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-07-29 10:06:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '288', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-29 10:16:44'

EXEC Usp_InsertFeedback @Order_Id = '288', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 289
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1'), ('11','1'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-07-29 18:17:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '289', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-29 18:24:55'

EXEC Usp_InsertFeedback @Order_Id = '289', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 290
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '83', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-07-29 19:13:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '290', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-29 19:18:54'

EXEC Usp_InsertFeedback @Order_Id = '290', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 291
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1'), ('21','1'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '3', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-07-30 17:37:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '291', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-30 17:40:42'

EXEC Usp_InsertFeedback @Order_Id = '291', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 292
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '112', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-07-30 19:21:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '292', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-30 19:31:17'

-- Order 293
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','2'), ('9','1'), ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-07-30 19:45:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '293', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-30 19:52:31'

EXEC Usp_InsertFeedback @Order_Id = '292', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '293', @Store_Rating = '4', @Cashier_Rating = '1', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 294
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('12','2'), ('8','2'), ('7','2'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '36', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-07-31 19:14:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '294', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-31 19:24:10'

EXEC Usp_InsertFeedback @Order_Id = '294', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 295
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('30','1'), ('23','2'), ('35','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '73', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-07-31 21:21:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '295', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-07-31 21:30:50'

EXEC Usp_InsertFeedback @Order_Id = '295', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Some products were out of place'

-- Order 296
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('2','3'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '98', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-08-01 11:32:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '296', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 11:42:02'

EXEC Usp_InsertFeedback @Order_Id = '296', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 297
DELETE FROM @Items
INSERT INTO @Items VALUES ('31','1'), ('10','2'), ('12','3')
EXEC Usp_CreateOrder @Customer_Id = '40', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-08-01 16:49:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '297', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 16:59:43'

-- Order 298
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('32','1'), ('29','1')
EXEC Usp_CreateOrder @Customer_Id = '10', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-08-01 17:07:55', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '297', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

EXEC Usp_ProcessPayment @Order_Id = '298', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 17:17:38'

EXEC Usp_InsertFeedback @Order_Id = '298', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Store was crowded and untidy'

-- Order 299
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','3')
EXEC Usp_CreateOrder @Customer_Id = '55', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-08-01 20:00:53', @Order_Products = @Items

-- Order 300
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('2','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '78', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-08-01 20:05:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '299', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 20:11:07'

EXEC Usp_ProcessPayment @Order_Id = '300', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 20:12:47'

EXEC Usp_InsertFeedback @Order_Id = '300', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '299', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 301
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('15','1'), ('2','3'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-01 21:27:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '301', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-01 21:34:02'

EXEC Usp_InsertFeedback @Order_Id = '301', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 302
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('22','1'), ('36','2'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '74', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-08-02 12:46:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '302', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-02 12:54:15'

EXEC Usp_InsertFeedback @Order_Id = '302', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Friendly cashier'

-- Order 303
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','2'), ('14','3')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-08-03 17:02:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '303', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-03 17:10:17'

EXEC Usp_InsertFeedback @Order_Id = '303', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 304
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','2'), ('7','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '71', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-08-03 18:00:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '304', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-03 18:02:48'

EXEC Usp_InsertFeedback @Order_Id = '304', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Return for Order 279
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('30','3','Product not working')
EXEC Usp_InsertReturn @Order_Id = '279', @Return_Date_Time = '2026-08-04 16:43:31', @Return_Products = @Return_Items

-- Order 305
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('25','2'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '123', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-08-04 17:35:00', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '305', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-04 17:38:21'

EXEC Usp_InsertFeedback @Order_Id = '305', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Friendly cashier'

-- Order 306
DELETE FROM @Items
INSERT INTO @Items VALUES ('25','1')
EXEC Usp_CreateOrder @Customer_Id = '122', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-05 17:42:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '306', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-05 17:47:35'

EXEC Usp_InsertFeedback @Order_Id = '306', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 307
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','3'), ('8','1'), ('14','3')
EXEC Usp_CreateOrder @Customer_Id = '70', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-05 18:41:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '307', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-08-05 18:45:58'

-- Order 308
DELETE FROM @Items
INSERT INTO @Items VALUES ('25','1'), ('14','2'), ('6','2'), ('38','1')
EXEC Usp_CreateOrder @Customer_Id = '10', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-06 17:34:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '308', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-06 17:43:43'

EXEC Usp_InsertFeedback @Order_Id = '308', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 309
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('23','1'), ('17','1'), ('8','4'), ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-08-07 10:05:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '309', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-07 10:14:12'

EXEC Usp_InsertFeedback @Order_Id = '309', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Products were easy to find'

-- Order 310
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','3'), ('30','2'), ('9','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '52', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-07 17:35:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '310', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-07 17:44:47'

EXEC Usp_InsertFeedback @Order_Id = '310', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 311
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','1'), ('24','1')
EXEC Usp_CreateOrder @Customer_Id = '55', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-07 20:42:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '311', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-07 20:52:04'

EXEC Usp_InsertFeedback @Order_Id = '311', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 312
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '77', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-08-09 14:37:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '312', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-09 14:45:20'

EXEC Usp_InsertFeedback @Order_Id = '312', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 313
DELETE FROM @Items
INSERT INTO @Items VALUES ('38','2'), ('4','2')
EXEC Usp_CreateOrder @Customer_Id = '96', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-08-09 19:25:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '313', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-09 19:28:37'

EXEC Usp_InsertFeedback @Order_Id = '313', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 314
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','3'), ('1','1'), ('23','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '33', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-10 11:37:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '314', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-10 11:48:15'

EXEC Usp_InsertFeedback @Order_Id = '314', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 315
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '74', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-08-10 20:16:26', @Order_Products = @Items

-- Order 316
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1'), ('23','1'), ('25','2')
EXEC Usp_CreateOrder @Customer_Id = '98', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-08-10 20:19:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '315', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-10 20:26:55'

EXEC Usp_ProcessPayment @Order_Id = '316', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-08-10 20:28:27'

EXEC Usp_InsertFeedback @Order_Id = '315', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

EXEC Usp_ProcessPayment @Order_Id = '316', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-08-10 20:31:50'

-- Order 317
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('8','3')
EXEC Usp_CreateOrder @Customer_Id = '26', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-08-11 14:59:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '317', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-11 15:08:25'

EXEC Usp_InsertFeedback @Order_Id = '317', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 318
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','1'), ('8','3'), ('10','2'), ('13','4')
EXEC Usp_CreateOrder @Customer_Id = '102', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-08-12 09:58:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '318', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-12 10:06:43'

EXEC Usp_InsertFeedback @Order_Id = '318', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 319
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','2'), ('14','1'), ('20','3'), ('12','2'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-08-12 12:44:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '319', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-12 12:49:52'

EXEC Usp_InsertFeedback @Order_Id = '319', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 320
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-08-12 19:41:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '320', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-12 19:47:03'

EXEC Usp_InsertFeedback @Order_Id = '320', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

-- Order 321
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('2','3'), ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '102', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-08-12 19:56:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '321', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-12 20:03:19'

EXEC Usp_InsertFeedback @Order_Id = '321', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 322
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '75', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-08-13 17:38:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '322', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-13 17:48:36'

EXEC Usp_InsertFeedback @Order_Id = '322', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 323
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('30','1')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-08-14 11:38:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '323', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-14 11:47:03'

EXEC Usp_InsertFeedback @Order_Id = '323', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 324
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-08-14 18:06:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '324', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-14 18:12:25'

EXEC Usp_InsertFeedback @Order_Id = '324', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 325
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '110', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-08-15 10:33:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '325', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-15 10:43:21'

EXEC Usp_InsertFeedback @Order_Id = '325', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 326
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('21','1'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '87', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-08-15 11:22:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '326', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-15 11:28:45'

-- Order 327
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('18','1'), ('4','3'), ('33','1'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '127', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-08-15 11:39:04', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '327', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-15 11:42:00'

EXEC Usp_InsertFeedback @Order_Id = '326', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

EXEC Usp_InsertFeedback @Order_Id = '327', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good experience overall'

-- Order 328
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('24','1'), ('9','4'), ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-08-15 17:14:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '328', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-15 17:22:53'

EXEC Usp_InsertFeedback @Order_Id = '328', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 329
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '77', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-08-15 21:24:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '329', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-08-15 21:32:29'

EXEC Usp_ProcessPayment @Order_Id = '329', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-15 21:35:13'

EXEC Usp_InsertFeedback @Order_Id = '329', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 330
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('16','2')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-08-16 09:49:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '330', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-16 09:57:23'

EXEC Usp_InsertFeedback @Order_Id = '330', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 331
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('16','1'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '122', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-08-16 19:01:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '331', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-16 19:04:18'

EXEC Usp_InsertFeedback @Order_Id = '331', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 332
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('37','1'), ('21','3')
EXEC Usp_CreateOrder @Customer_Id = '106', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-08-17 12:22:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '332', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-17 12:25:09'

EXEC Usp_InsertFeedback @Order_Id = '332', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 333
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('33','1'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '121', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-08-17 17:26:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '333', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-17 17:34:07'

EXEC Usp_InsertFeedback @Order_Id = '333', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 334
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','3'), ('10','1'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '120', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-08-18 09:45:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '334', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-18 09:54:26'

EXEC Usp_InsertFeedback @Order_Id = '334', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 335
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-08-18 15:09:04', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '335', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-18 15:17:35'

-- Order 336
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('19','1'), ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '42', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-08-18 15:36:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '336', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-18 15:45:47'

EXEC Usp_InsertFeedback @Order_Id = '335', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

EXEC Usp_InsertFeedback @Order_Id = '336', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 337
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','2'), ('2','2')
EXEC Usp_CreateOrder @Customer_Id = '58', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-08-19 13:47:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '337', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-19 13:51:08'

EXEC Usp_InsertFeedback @Order_Id = '337', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 338
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3'), ('24','1'), ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '67', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-08-19 19:53:27', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '338', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-19 20:01:42'

EXEC Usp_InsertFeedback @Order_Id = '338', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 339
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','1'), ('15','2'), ('8','3'), ('19','2')
EXEC Usp_CreateOrder @Customer_Id = '110', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-08-20 11:49:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '339', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-20 11:55:04'

EXEC Usp_InsertFeedback @Order_Id = '339', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 340
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '105', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-08-20 14:43:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '340', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-08-20 14:49:35'

EXEC Usp_ProcessPayment @Order_Id = '340', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-20 14:51:30'

EXEC Usp_InsertFeedback @Order_Id = '340', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 341
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '2', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-20 18:22:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '341', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-20 18:29:02'

EXEC Usp_InsertFeedback @Order_Id = '341', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 342
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '113', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-08-20 20:32:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '342', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-20 20:43:05'

EXEC Usp_InsertFeedback @Order_Id = '342', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Return for Order 329
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('15','1','Quality not as expected')
EXEC Usp_InsertReturn @Order_Id = '329', @Return_Date_Time = '2026-08-21 09:27:13', @Return_Products = @Return_Items

-- Order 343
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','1'), ('4','2')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-08-21 13:57:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '343', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-21 14:02:21'

EXEC Usp_InsertFeedback @Order_Id = '343', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Return for Order 340
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('23','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '340', @Return_Date_Time = '2026-08-21 20:41:30', @Return_Products = @Return_Items

-- Order 344
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','1')
EXEC Usp_CreateOrder @Customer_Id = '74', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-08-23 09:30:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '344', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-23 09:36:11'

EXEC Usp_InsertFeedback @Order_Id = '344', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 345
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-08-23 18:17:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '345', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-23 18:23:06'

EXEC Usp_InsertFeedback @Order_Id = '345', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 346
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-08-23 18:40:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '346', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-23 18:51:07'

EXEC Usp_InsertFeedback @Order_Id = '346', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 347
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','2'), ('34','2'), ('6','3'), ('12','2'), ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '114', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-08-23 19:36:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '347', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-23 19:45:04'

EXEC Usp_InsertFeedback @Order_Id = '347', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 348
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','3'), ('14','4'), ('18','2'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-08-24 12:34:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '348', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-24 12:41:02'

EXEC Usp_InsertFeedback @Order_Id = '348', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 349
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','1'), ('36','1'), ('25','1'), ('8','2')
EXEC Usp_CreateOrder @Customer_Id = '43', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-08-24 20:10:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '349', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-24 20:12:22'

EXEC Usp_InsertFeedback @Order_Id = '349', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 350
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','2'), ('10','3'), ('32','1'), ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '128', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-08-25 17:59:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '350', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-25 18:08:34'

EXEC Usp_InsertFeedback @Order_Id = '350', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 351
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('26','1'), ('19','1'), ('24','1')
EXEC Usp_CreateOrder @Customer_Id = '1', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-08-27 12:01:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '351', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-27 12:11:31'

EXEC Usp_InsertFeedback @Order_Id = '351', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 352
DELETE FROM @Items
INSERT INTO @Items VALUES ('31','2'), ('8','3')
EXEC Usp_CreateOrder @Customer_Id = '82', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-08-28 10:14:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '352', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 10:21:18'

EXEC Usp_InsertFeedback @Order_Id = '352', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 353
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','3'), ('14','1'), ('15','2')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-08-28 12:04:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '353', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 12:13:40'

-- Order 354
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('13','4')
EXEC Usp_CreateOrder @Customer_Id = '69', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-08-28 12:14:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '354', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 12:21:01'

EXEC Usp_InsertFeedback @Order_Id = '354', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

EXEC Usp_InsertFeedback @Order_Id = '353', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 355
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('32','1'), ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-08-28 13:47:37', @Order_Products = @Items

-- Order 356
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','3'), ('20','1'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '36', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-08-28 13:49:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '355', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 13:50:07'

EXEC Usp_ProcessPayment @Order_Id = '356', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 13:59:33'

EXEC Usp_InsertFeedback @Order_Id = '356', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

EXEC Usp_InsertFeedback @Order_Id = '355', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 357
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','2'), ('12','3')
EXEC Usp_CreateOrder @Customer_Id = '66', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-08-28 21:09:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '357', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-28 21:14:23'

EXEC Usp_InsertFeedback @Order_Id = '357', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Return for Order 353
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('9','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '353', @Return_Date_Time = '2026-08-29 13:03:40', @Return_Products = @Return_Items

-- Order 358
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('8','1'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '70', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-08-29 15:13:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '358', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-29 15:23:09'

EXEC Usp_InsertFeedback @Order_Id = '358', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 359
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','4'), ('2','3')
EXEC Usp_CreateOrder @Customer_Id = '121', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-08-29 18:19:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '359', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-29 18:25:46'

EXEC Usp_InsertFeedback @Order_Id = '359', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 360
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('18','1'), ('20','1'), ('33','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '63', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-08-29 18:38:56', @Order_Products = @Items

-- Order 361
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '65', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-08-29 18:39:27', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '360', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-29 18:41:14'

EXEC Usp_ProcessPayment @Order_Id = '361', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-29 18:47:19'

EXEC Usp_InsertFeedback @Order_Id = '361', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

EXEC Usp_InsertFeedback @Order_Id = '360', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 362
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '108', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-08-30 10:10:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '362', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-30 10:18:49'

EXEC Usp_InsertFeedback @Order_Id = '362', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 363
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('4','1'), ('21','2')
EXEC Usp_CreateOrder @Customer_Id = '139', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-08-30 11:17:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '363', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-30 11:19:26'

EXEC Usp_InsertFeedback @Order_Id = '363', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 364
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '53', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-08-31 09:22:06', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '364', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-31 09:27:10'

EXEC Usp_InsertFeedback @Order_Id = '364', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 365
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '71', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-08-31 10:14:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '365', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-08-31 10:23:05'

EXEC Usp_InsertFeedback @Order_Id = '365', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Return for Order 346
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('9','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '346', @Return_Date_Time = '2026-09-01 09:25:07', @Return_Products = @Return_Items

-- Order 366
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','1'), ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '78', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-01 15:29:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '366', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-01 15:39:40'

EXEC Usp_InsertFeedback @Order_Id = '366', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 367
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('18','1'), ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '148', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-09-01 16:46:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '367', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-01 16:54:56'

EXEC Usp_InsertFeedback @Order_Id = '367', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 368
DELETE FROM @Items
INSERT INTO @Items VALUES ('38','1')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-09-02 12:49:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '368', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-02 12:52:13'

EXEC Usp_InsertFeedback @Order_Id = '368', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 369
DELETE FROM @Items
INSERT INTO @Items VALUES ('24','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-09-02 18:42:42', @Order_Products = @Items

-- Order 370
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1'), ('10','3'), ('33','3')
EXEC Usp_CreateOrder @Customer_Id = '116', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-02 18:45:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '370', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-09-02 18:47:18'

EXEC Usp_ProcessPayment @Order_Id = '370', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-02 18:51:24'

EXEC Usp_ProcessPayment @Order_Id = '369', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-02 18:53:32'

EXEC Usp_InsertFeedback @Order_Id = '370', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

EXEC Usp_InsertFeedback @Order_Id = '369', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 371
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('34','2'), ('27','1'), ('17','2'), ('29','1')
EXEC Usp_CreateOrder @Customer_Id = '96', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-09-03 11:02:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '371', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-03 11:06:35'

EXEC Usp_InsertFeedback @Order_Id = '371', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 372
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','2'), ('12','4'), ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '60', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-04 12:06:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '372', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-04 12:12:49'

EXEC Usp_InsertFeedback @Order_Id = '372', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 373
DELETE FROM @Items
INSERT INTO @Items VALUES ('26','2'), ('32','2'), ('33','1'), ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '92', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-09-04 13:34:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '373', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-04 13:42:25'

EXEC Usp_InsertFeedback @Order_Id = '373', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Return for Order 354
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('13','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '354', @Return_Date_Time = '2026-09-04 13:55:01', @Return_Products = @Return_Items

-- Order 374
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','4'), ('4','2'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '78', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-09-04 17:19:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '374', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-04 17:22:03'

EXEC Usp_InsertFeedback @Order_Id = '374', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 375
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','3'), ('37','2'), ('13','4')
EXEC Usp_CreateOrder @Customer_Id = '74', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-04 19:00:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '375', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-04 19:07:16'

EXEC Usp_InsertFeedback @Order_Id = '375', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 376
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '146', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-09-05 11:59:11', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '376', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-05 12:02:16'

EXEC Usp_InsertFeedback @Order_Id = '376', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

-- Order 377
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','3'), ('34','2')
EXEC Usp_CreateOrder @Customer_Id = '49', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-09-05 21:10:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '377', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-05 21:15:32'

EXEC Usp_InsertFeedback @Order_Id = '377', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 378
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '60', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-09-06 13:56:54', @Order_Products = @Items

-- Order 379
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('13','1'), ('9','1'), ('16','1')
EXEC Usp_CreateOrder @Customer_Id = '27', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-06 13:58:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '379', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-06 14:05:26'

EXEC Usp_ProcessPayment @Order_Id = '378', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-09-06 14:06:32'

EXEC Usp_ProcessPayment @Order_Id = '378', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-06 14:08:17'

EXEC Usp_InsertFeedback @Order_Id = '379', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_InsertFeedback @Order_Id = '378', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 380
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','3')
EXEC Usp_CreateOrder @Customer_Id = '95', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-09-06 15:28:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '380', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-06 15:35:28'

EXEC Usp_InsertFeedback @Order_Id = '380', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 381
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '57', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-09-07 13:04:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '381', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-07 13:08:21'

EXEC Usp_InsertFeedback @Order_Id = '381', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Billing queue was long'

-- Return for Order 365
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('14','2','Seal was broken')
EXEC Usp_InsertReturn @Order_Id = '365', @Return_Date_Time = '2026-09-07 17:08:05', @Return_Products = @Return_Items

-- Order 382
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','3')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-09-08 09:31:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '382', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-08 09:35:44'

EXEC Usp_InsertFeedback @Order_Id = '382', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 383
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1'), ('35','1'), ('18','1'), ('16','2'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '66', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-09-08 11:29:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '383', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-08 11:34:16'

EXEC Usp_InsertFeedback @Order_Id = '383', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 384
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('37','2'), ('17','2')
EXEC Usp_CreateOrder @Customer_Id = '146', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-09-08 13:38:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '384', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-08 13:46:34'

EXEC Usp_InsertFeedback @Order_Id = '384', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 385
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '44', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-09-09 12:52:50', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '385', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-09 12:57:34'

EXEC Usp_InsertFeedback @Order_Id = '385', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 386
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('17','1'), ('30','1'), ('16','3'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '96', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-09-09 14:00:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '386', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-09 14:04:12'

EXEC Usp_InsertFeedback @Order_Id = '386', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 387
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('1','2')
EXEC Usp_CreateOrder @Customer_Id = '105', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-09 19:18:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '387', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-09 19:20:43'

EXEC Usp_InsertFeedback @Order_Id = '387', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 388
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','2'), ('8','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '19', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-09-10 11:45:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '388', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-10 11:54:31'

EXEC Usp_InsertFeedback @Order_Id = '388', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 389
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('14','2'), ('15','2')
EXEC Usp_CreateOrder @Customer_Id = '107', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-09-10 14:34:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '389', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-10 14:43:36'

EXEC Usp_InsertFeedback @Order_Id = '389', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 390
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3')
EXEC Usp_CreateOrder @Customer_Id = '119', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-09-10 15:15:31', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '390', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-10 15:19:26'

EXEC Usp_InsertFeedback @Order_Id = '390', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 391
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','3'), ('25','1'), ('33','2'), ('18','3')
EXEC Usp_CreateOrder @Customer_Id = '121', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-11 11:16:34', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '391', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-11 11:21:45'

EXEC Usp_InsertFeedback @Order_Id = '391', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 392
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','3')
EXEC Usp_CreateOrder @Customer_Id = '10', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-09-11 13:05:17', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '392', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-11 13:07:58'

EXEC Usp_InsertFeedback @Order_Id = '392', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 393
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3'), ('21','1'), ('11','4'), ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '34', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-12 19:28:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '393', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-12 19:38:31'

EXEC Usp_InsertFeedback @Order_Id = '393', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 394
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('3','1')
EXEC Usp_CreateOrder @Customer_Id = '98', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-13 13:38:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '394', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-13 13:42:39'

EXEC Usp_InsertFeedback @Order_Id = '394', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 395
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','2'), ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '147', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-09-13 19:03:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '395', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-13 19:12:22'

EXEC Usp_InsertFeedback @Order_Id = '395', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 396
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '50', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-09-14 11:01:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '396', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-14 11:05:48'

EXEC Usp_InsertFeedback @Order_Id = '396', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 397
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','3')
EXEC Usp_CreateOrder @Customer_Id = '57', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-09-14 21:08:41', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '397', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-14 21:18:55'

EXEC Usp_InsertFeedback @Order_Id = '397', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 398
DELETE FROM @Items
INSERT INTO @Items VALUES ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '112', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-09-15 10:36:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '398', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-15 10:42:45'

EXEC Usp_InsertFeedback @Order_Id = '398', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 399
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('8','1'), ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '15', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-09-15 12:02:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '399', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-15 12:09:14'

EXEC Usp_InsertFeedback @Order_Id = '399', @Store_Rating = '2', @Cashier_Rating = '2', @Feedback_Detail = 'Staff was not very helpful'

-- Order 400
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','3'), ('35','2')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-09-16 12:35:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '400', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-16 12:38:57'

EXEC Usp_InsertFeedback @Order_Id = '400', @Store_Rating = '4', @Cashier_Rating = '2', @Feedback_Detail = 'Billing queue was long'

-- Order 401
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '16', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-16 16:28:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '401', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-16 16:37:52'

EXEC Usp_InsertFeedback @Order_Id = '401', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 402
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','3'), ('32','2'), ('18','2'), ('17','1'), ('30','3')
EXEC Usp_CreateOrder @Customer_Id = '91', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-09-16 16:45:45', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '402', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-16 16:55:36'

EXEC Usp_InsertFeedback @Order_Id = '402', @Store_Rating = '5', @Cashier_Rating = '1', @Feedback_Detail = 'Average experience'

-- Order 403
DELETE FROM @Items
INSERT INTO @Items VALUES ('17','2'), ('29','2')
EXEC Usp_CreateOrder @Customer_Id = '8', @Store_Id = '1', @Employee_Id = '2', @Order_Date_Time = '2026-09-16 20:31:47', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '403', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-16 20:40:09'

EXEC Usp_InsertFeedback @Order_Id = '403', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Return for Order 395
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('18','1','Packet was damaged')
EXEC Usp_InsertReturn @Order_Id = '395', @Return_Date_Time = '2026-09-16 21:10:22', @Return_Products = @Return_Items

-- Return for Order 398
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('35','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '398', @Return_Date_Time = '2026-09-17 14:31:45', @Return_Products = @Return_Items

-- Order 404
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '88', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-18 10:59:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '404', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-09-18 11:07:47'

EXEC Usp_ProcessPayment @Order_Id = '404', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-18 11:12:32'

EXEC Usp_InsertFeedback @Order_Id = '404', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 405
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3')
EXEC Usp_CreateOrder @Customer_Id = '135', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-09-19 10:28:05', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '405', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-19 10:33:34'

-- Order 406
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('24','2'), ('14','1'), ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '120', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-19 10:43:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '406', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-19 10:53:17'

EXEC Usp_InsertFeedback @Order_Id = '405', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '406', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Okay service, can improve'

-- Order 407
DELETE FROM @Items
INSERT INTO @Items VALUES ('31','1'), ('12','2'), ('6','3'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '21', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-19 13:56:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '407', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-19 14:00:16'

EXEC Usp_InsertFeedback @Order_Id = '407', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 408
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('15','3'), ('36','2')
EXEC Usp_CreateOrder @Customer_Id = '90', @Store_Id = '2', @Employee_Id = '6', @Order_Date_Time = '2026-09-20 10:18:52', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '408', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-20 10:29:47'

EXEC Usp_InsertFeedback @Order_Id = '408', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 409
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('35','1'), ('4','2'), ('11','2'), ('13','2')
EXEC Usp_CreateOrder @Customer_Id = '143', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-20 11:10:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '409', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-20 11:21:03'

EXEC Usp_InsertFeedback @Order_Id = '409', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 410
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('4','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '25', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-09-21 12:03:52', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '410', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-21 12:09:06'

EXEC Usp_InsertFeedback @Order_Id = '410', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 411
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '77', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-09-22 09:33:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '411', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-22 09:37:45'

EXEC Usp_InsertFeedback @Order_Id = '411', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 412
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','2'), ('4','2'), ('8','3'), ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '51', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-09-22 10:24:04', @Order_Products = @Items

-- Order 413
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('16','1'), ('27','1'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '65', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-09-22 10:33:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '412', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-22 10:34:22'

EXEC Usp_ProcessPayment @Order_Id = '413', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-22 10:37:03'

EXEC Usp_InsertFeedback @Order_Id = '412', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_InsertFeedback @Order_Id = '413', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Products were easy to find'

-- Order 414
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','1'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '128', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-09-22 15:06:50', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '414', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-22 15:09:59'

EXEC Usp_InsertFeedback @Order_Id = '414', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Order 415
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','3'), ('5','2')
EXEC Usp_CreateOrder @Customer_Id = '83', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-09-22 18:17:54', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '415', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-22 18:26:46'

EXEC Usp_InsertFeedback @Order_Id = '415', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 416
DELETE FROM @Items
INSERT INTO @Items VALUES ('5','1'), ('13','1'), ('25','2')
EXEC Usp_CreateOrder @Customer_Id = '106', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-23 13:49:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '416', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-23 13:52:34'

EXEC Usp_InsertFeedback @Order_Id = '416', @Store_Rating = '2', @Cashier_Rating = '3', @Feedback_Detail = 'Had to wait a long time at the counter'

-- Order 417
DELETE FROM @Items
INSERT INTO @Items VALUES ('29','1'), ('1','1'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '117', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-23 20:11:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '417', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-23 20:20:35'

EXEC Usp_InsertFeedback @Order_Id = '417', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 418
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1'), ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '105', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-09-23 21:03:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '418', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-23 21:13:06'

EXEC Usp_InsertFeedback @Order_Id = '418', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Billing queue was long'

-- Order 419
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('15','2'), ('33','2')
EXEC Usp_CreateOrder @Customer_Id = '39', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-24 09:27:37', @Order_Products = @Items

-- Order 420
DELETE FROM @Items
INSERT INTO @Items VALUES ('13','1'), ('9','2')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-24 09:31:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '420', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-24 09:36:01'

EXEC Usp_ProcessPayment @Order_Id = '419', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-24 09:37:17'

EXEC Usp_InsertFeedback @Order_Id = '420', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

EXEC Usp_InsertFeedback @Order_Id = '419', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 421
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','3'), ('12','1')
EXEC Usp_CreateOrder @Customer_Id = '131', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-09-24 15:31:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '421', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-09-24 15:37:46'

EXEC Usp_ProcessPayment @Order_Id = '421', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-24 15:41:22'

EXEC Usp_InsertFeedback @Order_Id = '421', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 422
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-09-24 17:26:03', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '422', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-09-24 17:28:07'

-- Order 423
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('12','1'), ('17','1')
EXEC Usp_CreateOrder @Customer_Id = '55', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-09-24 20:50:51', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '423', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-24 20:54:40'

EXEC Usp_InsertFeedback @Order_Id = '423', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 424
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '143', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-09-25 19:08:55', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '424', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-25 19:11:55'

EXEC Usp_InsertFeedback @Order_Id = '424', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 425
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','4')
EXEC Usp_CreateOrder @Customer_Id = '65', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-09-26 15:58:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '425', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-26 16:04:37'

EXEC Usp_InsertFeedback @Order_Id = '425', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 426
DELETE FROM @Items
INSERT INTO @Items VALUES ('33','2'), ('19','1'), ('14','2'), ('6','1')
EXEC Usp_CreateOrder @Customer_Id = '74', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-09-27 09:15:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '426', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 09:26:28'

EXEC Usp_InsertFeedback @Order_Id = '426', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Products were easy to find'

-- Order 427
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','3'), ('19','2'), ('17','1'), ('37','1')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-27 10:57:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '427', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 11:01:40'

EXEC Usp_InsertFeedback @Order_Id = '427', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 428
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','2'), ('26','3')
EXEC Usp_CreateOrder @Customer_Id = '83', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-09-27 12:45:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '428', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 12:53:18'

EXEC Usp_InsertFeedback @Order_Id = '428', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 429
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1')
EXEC Usp_CreateOrder @Customer_Id = '32', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-09-27 17:03:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '429', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 17:12:18'

EXEC Usp_InsertFeedback @Order_Id = '429', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 430
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1')
EXEC Usp_CreateOrder @Customer_Id = '5', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-09-27 17:31:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '430', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 17:35:15'

EXEC Usp_InsertFeedback @Order_Id = '430', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Billing queue was long'

-- Order 431
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('14','1'), ('32','2'), ('38','1')
EXEC Usp_CreateOrder @Customer_Id = '143', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-27 18:08:38', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '431', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-27 18:17:40'

EXEC Usp_InsertFeedback @Order_Id = '431', @Store_Rating = '5', @Cashier_Rating = '3', @Feedback_Detail = 'Friendly cashier'

-- Return for Order 427
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('6','2','Packet was damaged')
EXEC Usp_InsertReturn @Order_Id = '427', @Return_Date_Time = '2026-09-28 14:47:40', @Return_Products = @Return_Items

-- Order 432
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','2'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '28', @Store_Id = '2', @Employee_Id = '9', @Order_Date_Time = '2026-09-28 15:50:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '432', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-28 15:58:11'

EXEC Usp_InsertFeedback @Order_Id = '432', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 433
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('13','1')
EXEC Usp_CreateOrder @Customer_Id = '114', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-09-28 18:22:36', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '433', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-28 18:32:20'

EXEC Usp_InsertFeedback @Order_Id = '433', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 434
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','1'), ('30','1'), ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '62', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-09-29 10:18:24', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '434', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-29 10:22:40'

EXEC Usp_InsertFeedback @Order_Id = '434', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Return for Order 416
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('5','1','Seal was broken')
EXEC Usp_InsertReturn @Order_Id = '416', @Return_Date_Time = '2026-09-29 21:09:34', @Return_Products = @Return_Items

-- Return for Order 430
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('11','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '430', @Return_Date_Time = '2026-09-30 09:37:15', @Return_Products = @Return_Items

-- Order 435
DELETE FROM @Items
INSERT INTO @Items VALUES ('1','1'), ('30','2'), ('14','2')
EXEC Usp_CreateOrder @Customer_Id = '122', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-09-30 21:03:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '435', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-09-30 21:08:01'

EXEC Usp_InsertFeedback @Order_Id = '435', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 436
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','3'), ('30','2')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-01 18:41:00', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '436', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-01 18:46:57'

EXEC Usp_InsertFeedback @Order_Id = '436', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 437
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1'), ('31','2'), ('16','2'), ('18','1')
EXEC Usp_CreateOrder @Customer_Id = '22', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-10-02 11:51:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '437', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-02 12:00:01'

EXEC Usp_InsertFeedback @Order_Id = '437', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Return for Order 421
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('11','1','Bought by mistake'), ('12','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '421', @Return_Date_Time = '2026-10-02 21:43:22', @Return_Products = @Return_Items

-- Order 438
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('18','1'), ('34','1'), ('2','3')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-10-03 12:05:57', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '438', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-03 12:13:15'

EXEC Usp_InsertFeedback @Order_Id = '438', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 439
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','2'), ('22','2'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '132', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-03 16:43:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '439', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-03 16:51:29'

EXEC Usp_InsertFeedback @Order_Id = '439', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

-- Order 440
DELETE FROM @Items
INSERT INTO @Items VALUES ('11','1'), ('6','2')
EXEC Usp_CreateOrder @Customer_Id = '93', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-10-03 17:25:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '440', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-10-03 17:31:18'

-- Return for Order 420
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('9','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '420', @Return_Date_Time = '2026-10-04 12:57:01', @Return_Products = @Return_Items

-- Order 441
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '135', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-05 11:05:28', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '441', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-05 11:08:24'

EXEC Usp_InsertFeedback @Order_Id = '441', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 442
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','2'), ('13','2'), ('1','1'), ('18','2')
EXEC Usp_CreateOrder @Customer_Id = '148', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-10-05 12:51:19', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '442', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-05 12:59:03'

EXEC Usp_InsertFeedback @Order_Id = '442', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 443
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','1'), ('18','4'), ('14','1'), ('8','3'), ('34','2')
EXEC Usp_CreateOrder @Customer_Id = '11', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-05 13:24:13', @Order_Products = @Items

-- Order 444
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '12', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-10-05 13:28:43', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '443', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-05 13:29:27'

EXEC Usp_ProcessPayment @Order_Id = '444', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-05 13:37:43'

EXEC Usp_InsertFeedback @Order_Id = '443', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

EXEC Usp_InsertFeedback @Order_Id = '444', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 445
DELETE FROM @Items
INSERT INTO @Items VALUES ('28','2')
EXEC Usp_CreateOrder @Customer_Id = '50', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-10-07 09:37:42', @Order_Products = @Items

-- Order 446
DELETE FROM @Items
INSERT INTO @Items VALUES ('6','1'), ('37','1'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '61', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-10-07 09:40:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '445', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-07 09:46:05'

EXEC Usp_ProcessPayment @Order_Id = '446', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-07 09:48:20'

EXEC Usp_InsertFeedback @Order_Id = '446', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

EXEC Usp_InsertFeedback @Order_Id = '445', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Some products were out of place'

-- Order 447
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','3')
EXEC Usp_CreateOrder @Customer_Id = '69', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-10-07 20:03:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '447', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-07 20:13:11'

EXEC Usp_InsertFeedback @Order_Id = '447', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 448
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1'), ('26','1'), ('9','4'), ('2','1'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '96', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-08 14:25:12', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '448', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-08 14:29:57'

EXEC Usp_InsertFeedback @Order_Id = '448', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Good experience overall'

-- Order 449
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2'), ('34','3'), ('14','1'), ('4','2')
EXEC Usp_CreateOrder @Customer_Id = '81', @Store_Id = '1', @Employee_Id = '4', @Order_Date_Time = '2026-10-08 17:23:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '449', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-08 17:33:17'

EXEC Usp_InsertFeedback @Order_Id = '449', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Return for Order 416
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('25','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '416', @Return_Date_Time = '2026-10-09 09:50:34', @Return_Products = @Return_Items

-- Order 450
DELETE FROM @Items
INSERT INTO @Items VALUES ('34','2'), ('19','2'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '75', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-10-09 12:05:48', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '450', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-09 12:16:10'

EXEC Usp_InsertFeedback @Order_Id = '450', @Store_Rating = '4', @Cashier_Rating = '3', @Feedback_Detail = 'Good experience overall'

-- Order 451
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','1')
EXEC Usp_CreateOrder @Customer_Id = '124', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-10-09 14:48:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '451', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-09 14:51:50'

EXEC Usp_InsertFeedback @Order_Id = '451', @Store_Rating = '1', @Cashier_Rating = '5', @Feedback_Detail = 'Okay service, can improve'

-- Order 452
DELETE FROM @Items
INSERT INTO @Items VALUES ('3','1'), ('33','2'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '14', @Store_Id = '2', @Employee_Id = '8', @Order_Date_Time = '2026-10-09 21:20:35', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '452', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-09 21:24:36'

EXEC Usp_InsertFeedback @Order_Id = '452', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 453
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '131', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-10-10 20:45:21', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '453', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-10 20:55:53'

EXEC Usp_InsertFeedback @Order_Id = '453', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 454
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '11', @Order_Date_Time = '2026-10-12 14:05:39', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '454', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-12 14:13:17'

EXEC Usp_InsertFeedback @Order_Id = '454', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 455
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '149', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-12 16:15:23', @Order_Products = @Items

-- Order 456
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('29','1'), ('8','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '75', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-10-12 16:23:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '455', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-12 16:24:39'

EXEC Usp_ProcessPayment @Order_Id = '456', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-12 16:31:58'

EXEC Usp_InsertFeedback @Order_Id = '455', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

EXEC Usp_InsertFeedback @Order_Id = '456', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 457
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('37','3')
EXEC Usp_CreateOrder @Customer_Id = '20', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-10-13 09:01:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '457', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-13 09:07:32'

EXEC Usp_InsertFeedback @Order_Id = '457', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 458
DELETE FROM @Items
INSERT INTO @Items VALUES ('21','1')
EXEC Usp_CreateOrder @Customer_Id = '118', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-10-13 16:24:18', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '458', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-13 16:31:54'

EXEC Usp_InsertFeedback @Order_Id = '458', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Order 459
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','2'), ('25','1'), ('26','2'), ('10','2'), ('2','1')
EXEC Usp_CreateOrder @Customer_Id = '86', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-10-13 17:50:01', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '459', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-13 17:59:25'

EXEC Usp_InsertFeedback @Order_Id = '459', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 460
DELETE FROM @Items
INSERT INTO @Items VALUES ('15','1'), ('8','1'), ('28','1'), ('37','3')
EXEC Usp_CreateOrder @Customer_Id = '62', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-10-14 10:57:33', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '460', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-14 11:06:57'

EXEC Usp_InsertFeedback @Order_Id = '460', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Return for Order 453
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('2','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '453', @Return_Date_Time = '2026-10-15 09:42:53', @Return_Products = @Return_Items

-- Order 461
DELETE FROM @Items
INSERT INTO @Items VALUES ('19','2'), ('11','2')
EXEC Usp_CreateOrder @Customer_Id = '98', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-10-15 11:25:23', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '461', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-15 11:27:50'

EXEC Usp_InsertFeedback @Order_Id = '461', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 462
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('12','2'), ('21','2'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '69', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-10-15 12:38:58', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '462', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-15 12:47:48'

EXEC Usp_InsertFeedback @Order_Id = '462', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 463
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('37','2'), ('33','2'), ('26','1')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-10-15 13:32:56', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '463', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-15 13:37:09'

EXEC Usp_InsertFeedback @Order_Id = '463', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 464
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('15','3'), ('34','2'), ('8','1'), ('5','1')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-17 12:43:02', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '464', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-10-17 12:52:06'

EXEC Usp_ProcessPayment @Order_Id = '464', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-17 12:56:18'

-- Order 465
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','4'), ('4','1')
EXEC Usp_CreateOrder @Customer_Id = '143', @Store_Id = '4', @Employee_Id = '15', @Order_Date_Time = '2026-10-17 13:08:00', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '464', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

EXEC Usp_ProcessPayment @Order_Id = '465', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-17 13:16:49'

EXEC Usp_InsertFeedback @Order_Id = '465', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Friendly cashier'

-- Order 466
DELETE FROM @Items
INSERT INTO @Items VALUES ('27','1'), ('18','2'), ('35','1')
EXEC Usp_CreateOrder @Customer_Id = '46', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-17 17:55:25', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '466', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-17 18:03:41'

EXEC Usp_InsertFeedback @Order_Id = '466', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 467
DELETE FROM @Items
INSERT INTO @Items VALUES ('7','1'), ('8','1'), ('33','1'), ('6','2'), ('10','2')
EXEC Usp_CreateOrder @Customer_Id = '56', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-10-18 11:46:22', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '467', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-18 11:51:18'

EXEC Usp_InsertFeedback @Order_Id = '467', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 468
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','1'), ('24','1')
EXEC Usp_CreateOrder @Customer_Id = '9', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-10-18 12:51:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '468', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-18 12:55:20'

EXEC Usp_InsertFeedback @Order_Id = '468', @Store_Rating = '2', @Cashier_Rating = '2', @Feedback_Detail = 'Store was crowded and untidy'

-- Order 469
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('32','1')
EXEC Usp_CreateOrder @Customer_Id = '146', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-18 15:44:26', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '469', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-18 15:49:48'

EXEC Usp_InsertFeedback @Order_Id = '469', @Store_Rating = '4', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 470
DELETE FROM @Items
INSERT INTO @Items VALUES ('36','1'), ('34','1'), ('10','3')
EXEC Usp_CreateOrder @Customer_Id = '126', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-18 18:16:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '470', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-18 18:23:11'

EXEC Usp_InsertFeedback @Order_Id = '470', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Staff could be more attentive'

-- Return for Order 460
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('15','1','Seal was broken'), ('28','1','Bought by mistake')
EXEC Usp_InsertReturn @Order_Id = '460', @Return_Date_Time = '2026-10-18 19:00:57', @Return_Products = @Return_Items

-- Order 471
DELETE FROM @Items
INSERT INTO @Items VALUES ('10','2'), ('8','2'), ('20','1')
EXEC Usp_CreateOrder @Customer_Id = '142', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-19 12:35:07', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '471', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-19 12:38:40'

EXEC Usp_InsertFeedback @Order_Id = '471', @Store_Rating = '2', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 472
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','1'), ('38','1'), ('9','1')
EXEC Usp_CreateOrder @Customer_Id = '7', @Store_Id = '1', @Employee_Id = '5', @Order_Date_Time = '2026-10-19 16:00:31', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '472', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-19 16:07:02'

EXEC Usp_InsertFeedback @Order_Id = '472', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Staff could be more attentive'

-- Order 473
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','2'), ('6','1'), ('18','2'), ('9','1'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '131', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-10-19 17:56:42', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '473', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-19 18:06:31'

EXEC Usp_InsertFeedback @Order_Id = '473', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 474
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','4'), ('10','3'), ('9','2'), ('33','1')
EXEC Usp_CreateOrder @Customer_Id = '93', @Store_Id = '5', @Employee_Id = '20', @Order_Date_Time = '2026-10-20 09:52:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '474', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-20 09:57:36'

-- Order 475
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3'), ('8','1'), ('12','2'), ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '80', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-10-20 10:00:16', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '474', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good experience overall'

EXEC Usp_ProcessPayment @Order_Id = '475', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-20 10:10:22'

EXEC Usp_InsertFeedback @Order_Id = '475', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 476
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','2'), ('32','1'), ('24','1'), ('23','2')
EXEC Usp_CreateOrder @Customer_Id = '60', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-21 12:37:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '476', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-21 12:45:16'

EXEC Usp_InsertFeedback @Order_Id = '476', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 477
DELETE FROM @Items
INSERT INTO @Items VALUES ('18','3'), ('23','1')
EXEC Usp_CreateOrder @Customer_Id = '52', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-22 11:18:59', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '477', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-22 11:29:53'

EXEC Usp_InsertFeedback @Order_Id = '477', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 478
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','1'), ('6','1'), ('22','2')
EXEC Usp_CreateOrder @Customer_Id = '56', @Store_Id = '3', @Employee_Id = '12', @Order_Date_Time = '2026-10-22 18:32:06', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '478', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-22 18:41:44'

EXEC Usp_InsertFeedback @Order_Id = '478', @Store_Rating = '2', @Cashier_Rating = '4', @Feedback_Detail = 'Some products were out of place'

-- Order 479
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','3')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '18', @Order_Date_Time = '2026-10-23 14:40:49', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '479', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-10-23 14:43:55'

EXEC Usp_ProcessPayment @Order_Id = '479', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-23 14:48:54'

EXEC Usp_InsertFeedback @Order_Id = '479', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

-- Order 480
DELETE FROM @Items
INSERT INTO @Items VALUES ('9','1'), ('4','3'), ('20','2')
EXEC Usp_CreateOrder @Customer_Id = '81', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-23 15:29:37', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '480', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-23 15:32:08'

EXEC Usp_InsertFeedback @Order_Id = '480', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 481
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','2'), ('26','1'), ('38','3')
EXEC Usp_CreateOrder @Customer_Id = '104', @Store_Id = '2', @Employee_Id = '7', @Order_Date_Time = '2026-10-23 18:43:10', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '481', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-23 18:48:00'

EXEC Usp_InsertFeedback @Order_Id = '481', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Very helpful staff, great experience'

-- Order 482
DELETE FROM @Items
INSERT INTO @Items VALUES ('3','1'), ('15','1')
EXEC Usp_CreateOrder @Customer_Id = '116', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-10-25 09:25:53', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '482', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-25 09:36:44'

EXEC Usp_InsertFeedback @Order_Id = '482', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 483
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1'), ('20','1'), ('28','1'), ('9','4')
EXEC Usp_CreateOrder @Customer_Id = '76', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-25 10:11:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '483', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-25 10:19:54'

-- Order 484
DELETE FROM @Items
INSERT INTO @Items VALUES ('20','2')
EXEC Usp_CreateOrder @Customer_Id = '58', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-10-25 10:21:16', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '483', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Friendly cashier'

EXEC Usp_ProcessPayment @Order_Id = '484', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-25 10:32:05'

EXEC Usp_InsertFeedback @Order_Id = '484', @Store_Rating = '3', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Return for Order 480
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('9','1','Bought by mistake'), ('4','1','Duplicate purchase')
EXEC Usp_InsertReturn @Order_Id = '480', @Return_Date_Time = '2026-10-25 15:53:08', @Return_Products = @Return_Items

-- Order 485
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '4', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-10-25 17:41:29', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '485', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-25 17:46:38'

EXEC Usp_InsertFeedback @Order_Id = '485', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Store was clean and well organised'

-- Order 486
DELETE FROM @Items
INSERT INTO @Items VALUES ('14','4')
EXEC Usp_CreateOrder @Customer_Id = '49', @Store_Id = '4', @Employee_Id = '16', @Order_Date_Time = '2026-10-26 10:45:20', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '486', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-26 10:49:11'

EXEC Usp_InsertFeedback @Order_Id = '486', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 487
DELETE FROM @Items
INSERT INTO @Items VALUES ('29','1')
EXEC Usp_CreateOrder @Customer_Id = '48', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-10-27 17:25:46', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '487', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-27 17:36:19'

EXEC Usp_InsertFeedback @Order_Id = '487', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Friendly cashier'

-- Order 488
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','2'), ('6','3'), ('8','1')
EXEC Usp_CreateOrder @Customer_Id = '127', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-10-27 21:15:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '488', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-27 21:24:09'

EXEC Usp_InsertFeedback @Order_Id = '488', @Store_Rating = '4', @Cashier_Rating = '2', @Feedback_Detail = 'Staff could be more attentive'

-- Order 489
DELETE FROM @Items
INSERT INTO @Items VALUES ('12','2')
EXEC Usp_CreateOrder @Customer_Id = '17', @Store_Id = '3', @Employee_Id = '10', @Order_Date_Time = '2026-10-28 13:29:00', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '489', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-28 13:31:57'

EXEC Usp_InsertFeedback @Order_Id = '489', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Loved the shopping experience'

-- Order 490
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','1'), ('7','1'), ('3','1')
EXEC Usp_CreateOrder @Customer_Id = '30', @Store_Id = '5', @Employee_Id = '22', @Order_Date_Time = '2026-10-30 15:03:09', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '490', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-30 15:13:13'

EXEC Usp_InsertFeedback @Order_Id = '490', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Products were easy to find'

-- Order 491
DELETE FROM @Items
INSERT INTO @Items VALUES ('23','1'), ('13','1'), ('9','1'), ('34','2'), ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '6', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-10-30 16:46:32', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '491', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-30 16:50:59'

-- Order 492
DELETE FROM @Items
INSERT INTO @Items VALUES ('2','2'), ('35','2')
EXEC Usp_CreateOrder @Customer_Id = '73', @Store_Id = '1', @Employee_Id = '1', @Order_Date_Time = '2026-10-30 17:04:23', @Order_Products = @Items

EXEC Usp_InsertFeedback @Order_Id = '491', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

EXEC Usp_ProcessPayment @Order_Id = '492', @Payment_Type = 'Card', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-30 17:10:11'

EXEC Usp_InsertFeedback @Order_Id = '492', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Excellent service and quick billing'

-- Order 493
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('18','4')
EXEC Usp_CreateOrder @Customer_Id = '139', @Store_Id = '4', @Employee_Id = '17', @Order_Date_Time = '2026-10-30 18:16:15', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '493', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-30 18:20:25'

EXEC Usp_InsertFeedback @Order_Id = '493', @Store_Rating = '5', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 494
DELETE FROM @Items
INSERT INTO @Items VALUES ('32','2'), ('34','1')
EXEC Usp_CreateOrder @Customer_Id = '122', @Store_Id = '5', @Employee_Id = '19', @Order_Date_Time = '2026-10-30 21:15:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '494', @Payment_Type = 'Card', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-10-30 21:19:57'

EXEC Usp_ProcessPayment @Order_Id = '494', @Payment_Type = 'UPI', @Payment_Result = 'Failed', @Transaction_Date_Time = '2026-10-30 21:22:34'

-- Order 495
DELETE FROM @Items
INSERT INTO @Items VALUES ('4','1'), ('11','1'), ('35','2')
EXEC Usp_CreateOrder @Customer_Id = '148', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-31 09:10:30', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '495', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 09:20:45'

EXEC Usp_InsertFeedback @Order_Id = '495', @Store_Rating = '5', @Cashier_Rating = '1', @Feedback_Detail = 'Some products were out of place'

-- Order 496
DELETE FROM @Items
INSERT INTO @Items VALUES ('37','1'), ('18','1'), ('28','1')
EXEC Usp_CreateOrder @Customer_Id = '116', @Store_Id = '1', @Employee_Id = '3', @Order_Date_Time = '2026-10-31 11:42:40', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '496', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 11:53:16'

EXEC Usp_InsertFeedback @Order_Id = '496', @Store_Rating = '3', @Cashier_Rating = '3', @Feedback_Detail = 'Average experience'

-- Order 497
DELETE FROM @Items
INSERT INTO @Items VALUES ('30','2'), ('25','1'), ('14','1')
EXEC Usp_CreateOrder @Customer_Id = '57', @Store_Id = '5', @Employee_Id = '23', @Order_Date_Time = '2026-10-31 14:00:13', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '497', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 14:04:49'

EXEC Usp_InsertFeedback @Order_Id = '497', @Store_Rating = '4', @Cashier_Rating = '4', @Feedback_Detail = 'Nice store, staff was helpful'

-- Order 498
DELETE FROM @Items
INSERT INTO @Items VALUES ('22','1')
EXEC Usp_CreateOrder @Customer_Id = '87', @Store_Id = '5', @Employee_Id = '21', @Order_Date_Time = '2026-10-31 18:32:14', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '498', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 18:40:32'

EXEC Usp_InsertFeedback @Order_Id = '498', @Store_Rating = '5', @Cashier_Rating = '2', @Feedback_Detail = 'Friendly cashier'

-- Order 499
DELETE FROM @Items
INSERT INTO @Items VALUES ('16','3')
EXEC Usp_CreateOrder @Customer_Id = '150', @Store_Id = '3', @Employee_Id = '14', @Order_Date_Time = '2026-10-31 19:03:16', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '499', @Payment_Type = 'Cash', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 19:10:11'

EXEC Usp_InsertFeedback @Order_Id = '499', @Store_Rating = '3', @Cashier_Rating = '5', @Feedback_Detail = 'Good service, billing took a little time'

-- Order 500
DELETE FROM @Items
INSERT INTO @Items VALUES ('8','3'), ('32','2')
EXEC Usp_CreateOrder @Customer_Id = '115', @Store_Id = '3', @Employee_Id = '13', @Order_Date_Time = '2026-10-31 20:29:08', @Order_Products = @Items

EXEC Usp_ProcessPayment @Order_Id = '500', @Payment_Type = 'UPI', @Payment_Result = 'Success', @Transaction_Date_Time = '2026-10-31 20:35:17'

EXEC Usp_InsertFeedback @Order_Id = '500', @Store_Rating = '5', @Cashier_Rating = '5', @Feedback_Detail = 'Cashier was polite and fast'

-- Return for Order 487
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('29','1','Wrong product given')
EXEC Usp_InsertReturn @Order_Id = '487', @Return_Date_Time = '2026-11-05 09:11:19', @Return_Products = @Return_Items

-- Return for Order 498
DELETE FROM @Return_Items
INSERT INTO @Return_Items VALUES ('22','1','Quality not as expected')
EXEC Usp_InsertReturn @Order_Id = '498', @Return_Date_Time = '2026-11-11 09:37:32', @Return_Products = @Return_Items

GO

/* ---------- STEP 3 : Verification ---------- */
SELECT 'Order' AS TableName, COUNT(*) AS Total, 500 AS Expected FROM [Order]
UNION ALL SELECT 'OrderProduct',         COUNT(*), 1272 FROM OrderProduct
UNION ALL SELECT 'OrderTransaction',     COUNT(*), 548 FROM OrderTransaction
UNION ALL SELECT 'StoreCashierFeedback', COUNT(*), 493 FROM StoreCashierFeedback
UNION ALL SELECT 'Return',               COUNT(*), 40 FROM [Return]
UNION ALL SELECT 'ReturnProduct',        COUNT(*), 50 FROM ReturnProduct;

-- Orders and Sales by Month and Store (Completed Orders)
SELECT FORMAT(O.OrderDateTime, 'yyyy-MM') AS OrderMonth, S.StoreName, COUNT(*) AS Orders, SUM(O.OrderAmount) AS Sales
FROM [Order] O JOIN Store S ON S.StoreID = O.StoreID
WHERE O.OrderStatus = 1
GROUP BY FORMAT(O.OrderDateTime, 'yyyy-MM'), S.StoreName
ORDER BY OrderMonth, S.StoreName;

-- Rule checks : every count must be 0
SELECT 'Order before Store opened' AS RuleCheck, COUNT(*) AS Violations
FROM [Order] O JOIN Store S ON S.StoreID = O.StoreID WHERE CAST(O.OrderDateTime AS DATE) < S.StoreEstablishDate
UNION ALL
SELECT 'Order before Customer registered', COUNT(*)
FROM [Order] O JOIN Customer C ON C.CustomerID = O.CustomerID WHERE CAST(O.OrderDateTime AS DATE) < C.CustomerRegisterDate
UNION ALL
SELECT 'Order before Employee joined / wrong Store', COUNT(*)
FROM [Order] O JOIN StoreEmployee E ON E.EmployeeID = O.EmployeeStoreID
WHERE CAST(O.OrderDateTime AS DATE) < E.EmployeeJoinDate OR E.EmployeeStoreID <> O.StoreID
UNION ALL
SELECT 'Product ordered before it was introduced', COUNT(*)
FROM OrderProduct OP JOIN [Order] O ON O.OrderID = OP.OrderID JOIN Product P ON P.ProductID = OP.ProductID
WHERE CAST(O.OrderDateTime AS DATE) < P.ProductIntroduceDate
UNION ALL
SELECT 'Payment before Order', COUNT(*)
FROM OrderTransaction T JOIN [Order] O ON O.OrderID = T.OrderID WHERE T.TransactionDateTime < O.OrderDateTime
UNION ALL
SELECT 'Return before Payment', COUNT(*)
FROM [Return] R JOIN OrderTransaction T ON T.OrderID = R.OrderID AND T.TransactionStatus = 1
WHERE R.ReturnDateTime < T.TransactionDateTime
UNION ALL
SELECT 'Negative Product Stock', COUNT(*) FROM Product WHERE ProductAvailableCount < 0;
