/* =====================================================================
    Primary KEYS
   ===================================================================== */
ALTER TABLE "OrderProduct"
    ADD CONSTRAINT "PK_OrderProduct" PRIMARY KEY ("OrderID", "ProductID");

ALTER TABLE "ReturnProduct"
    ADD CONSTRAINT "PK_ReturnProduct" PRIMARY KEY ("ReturnID", "ProductID");
GO

/* =====================================================================
    FOREIGN KEYS
   ===================================================================== */

-- Product -> ProductCategory
ALTER TABLE "Product"
    ADD CONSTRAINT "FK_Product_ProductCategory"
    FOREIGN KEY ("ProductCategoryID") REFERENCES "ProductCategory" ("ProductCategoryID");

-- Store -> StoreLocation
ALTER TABLE "Store"
    ADD CONSTRAINT "FK_Store_StoreLocation"
    FOREIGN KEY ("StoreLocationID") REFERENCES "StoreLocation" ("StoreLocationID");

-- StoreEmployee -> Store
ALTER TABLE "StoreEmployee"
    ADD CONSTRAINT "FK_StoreEmployee_Store"
    FOREIGN KEY ("EmployeeStoreID") REFERENCES "Store" ("StoreID");

-- Order -> Customer
ALTER TABLE "Order"
    ADD CONSTRAINT "FK_Order_Customer"
    FOREIGN KEY ("CustomerID") REFERENCES "Customer" ("CustomerID");

-- Order -> Store
ALTER TABLE "Order"
    ADD CONSTRAINT "FK_Order_Store"
    FOREIGN KEY ("StoreID") REFERENCES "Store" ("StoreID");

-- Order -> Status
ALTER TABLE "Order"
    ADD CONSTRAINT "FK_Order_Status"
    FOREIGN KEY ("OrderStatus") REFERENCES "Status" ("StatusID");

-- Order -> StoreEmployee (cashier)
ALTER TABLE "Order"
    ADD CONSTRAINT "FK_Order_StoreEmployee"
    FOREIGN KEY ("EmployeeStoreID") REFERENCES "StoreEmployee" ("EmployeeID");

-- OrderProduct -> Order / Product
ALTER TABLE "OrderProduct"
    ADD CONSTRAINT "FK_OrderProduct_Order"
    FOREIGN KEY ("OrderID") REFERENCES "Order" ("OrderID");

ALTER TABLE "OrderProduct"
    ADD CONSTRAINT "FK_OrderProduct_Product"
    FOREIGN KEY ("ProductID") REFERENCES "Product" ("ProductID");

-- OrderTransaction -> Order / Status
ALTER TABLE "OrderTransaction"
    ADD CONSTRAINT "FK_OrderTransaction_Order"
    FOREIGN KEY ("OrderID") REFERENCES "Order" ("OrderID");

ALTER TABLE "OrderTransaction"
    ADD CONSTRAINT "FK_OrderTransaction_Status"
    FOREIGN KEY ("TransactionStatus") REFERENCES "Status" ("StatusID");

-- StoreCashierFeedback -> Order 
ALTER TABLE "StoreCashierFeedback"
    ADD CONSTRAINT "FK_StoreCashierFeedback_Order"
    FOREIGN KEY ("OrderID") REFERENCES "Order" ("OrderID");

-- Return -> Order
ALTER TABLE "Return"
    ADD CONSTRAINT "FK_Return_Order"
    FOREIGN KEY ("OrderID") REFERENCES "Order" ("OrderID");

-- ReturnProduct -> Return / Product
ALTER TABLE "ReturnProduct"
    ADD CONSTRAINT "FK_ReturnProduct_Return"
    FOREIGN KEY ("ReturnID") REFERENCES "Return" ("ReturnID");

ALTER TABLE "ReturnProduct"
    ADD CONSTRAINT "FK_ReturnProduct_Product"
    FOREIGN KEY ("ProductID") REFERENCES "Product" ("ProductID");
GO

/* =====================================================================
    UNIQUE CONSTRAINTS 
   ===================================================================== */

-- One status name per ID
ALTER TABLE "Status"
    ADD CONSTRAINT "UQ_Status_Status" UNIQUE ("Status");

-- A customer is identified by phone at the counter
ALTER TABLE "Customer"
    ADD CONSTRAINT "UQ_Customer_CustomerPhone" UNIQUE ("CustomerPhone");

-- Same product name cannot be repeated within a category
ALTER TABLE "Product"
    ADD CONSTRAINT "UQ_Product_Category_Name" UNIQUE ("ProductCategoryID", "ProductName");

/* =====================================================================
   CHECK CONSTRAINTS
   ===================================================================== */

/* ---------- ProductCategory ---------- */
ALTER TABLE "ProductCategory" ADD
    CONSTRAINT "CK_ProductCategory_ActiveStatus"
        CHECK ("ProductCategoryActiveStatus" IN (0, 1)),
    CONSTRAINT "CK_ProductCategory_ClosingDate"
        CHECK ("ProductCategoryClosingDate" IS NULL
               OR "ProductCategoryClosingDate" >= "ProductCategoryIntroduceDate"),
    CONSTRAINT "CK_ProductCategory_Status_ClosingDate"
        CHECK (("ProductCategoryActiveStatus" = 1 AND "ProductCategoryClosingDate" IS NULL)
            OR ("ProductCategoryActiveStatus" = 0 AND "ProductCategoryClosingDate" IS NOT NULL));

/* ---------- Product ---------- */
ALTER TABLE "Product" ADD
    CONSTRAINT "CK_Product_Price"
        CHECK ("ProductPrice" > 0),
    CONSTRAINT "CK_Product_AvailableCount"
        CHECK ("ProductAvailableCount" >= 0),
    CONSTRAINT "CK_Product_ActiveStatus"
        CHECK ("ProductActiveStatus" IN (0, 1)),
    CONSTRAINT "CK_Product_DiscontinueDate"
        CHECK ("ProductDiscontinueDate" IS NULL
               OR "ProductDiscontinueDate" >= "ProductIntroduceDate"),
    CONSTRAINT "CK_Product_Status_DiscontinueDate"
        CHECK (("ProductActiveStatus" = 1 AND "ProductDiscontinueDate" IS NULL)
            OR ("ProductActiveStatus" = 0 AND "ProductDiscontinueDate" IS NOT NULL));

/* =====================================================================
   DEFAULT CONSTRAINTS
   ===================================================================== */

ALTER TABLE "OrderTransaction"
    ADD CONSTRAINT "DF_OrderTransaction_TransactionID"
    DEFAULT NEWID() FOR "TransactionID";

ALTER TABLE "OrderTransaction"
    ADD CONSTRAINT "DF_OrderTransaction_TransactionDateTime"
    DEFAULT GETDATE() FOR "TransactionDateTime";

ALTER TABLE "Order"
    ADD CONSTRAINT "DF_Order_OrderDateTime"
    DEFAULT GETDATE() FOR "OrderDateTime";

ALTER TABLE "Return"
    ADD CONSTRAINT "DF_Return_ReturnDateTime"
    DEFAULT GETDATE() FOR "ReturnDateTime";

ALTER TABLE "Customer"
    ADD CONSTRAINT "DF_Customer_CustomerRegisterDate"
    DEFAULT CAST(GETDATE() AS DATE) FOR "CustomerRegisterDate";
GO

/* =====================================================================
   INDEXES   
   ===================================================================== */


CREATE NONCLUSTERED INDEX "IX_Order_StoreID"              ON "Order" ("StoreID");			-- for Sales by Store reports
CREATE NONCLUSTERED INDEX "IX_Order_OrderStatus"          ON "Order" ("OrderStatus");		-- Almost for every Procedure
CREATE NONCLUSTERED INDEX "IX_Order_OrderDateTime"        ON "Order" ("OrderDateTime");		-- for monthly sales reports

-- Customer email is optional but must be unique when given
CREATE UNIQUE NONCLUSTERED INDEX "UQ_Customer_CustomerEmail"
    ON "Customer" ("CustomerEmail")
    WHERE "CustomerEmail" IS NOT NULL;
GO
