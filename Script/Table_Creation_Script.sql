CREATE TABLE "Product"(
    "ProductID" INT NOT NULL PRIMARY KEY,
    "ProductCategoryID" INT NOT NULL,
    "ProductName" VARCHAR(50) NOT NULL,
    "ProductPrice" DECIMAL(7, 2) NOT NULL,
    "ProductAvailableCount" INT NOT NULL,
    "ProductIntroduceDate" DATE NOT NULL DEFAULT '01/02/2026',
    "ProductActiveStatus" TINYINT NOT NULL DEFAULT 1,
    "ProductDiscontinueDate" DATE NULL
);
CREATE TABLE "ProductCategory"(
    "ProductCategoryID" INT NOT NULL PRIMARY KEY,
    "ProductCategoryName" VARCHAR(50) NOT NULL UNIQUE,
    "ProductCategoryIntroduceDate" DATE NOT NULL DEFAULT '01/02/2026',
    "ProductCategoryActiveStatus" TINYINT NOT NULL DEFAULT 1,
    "ProductCategoryClosingDate" DATE NULL
);
CREATE TABLE "Store"(
    "StoreID" INT NOT NULL PRIMARY KEY,
    "StoreName" VARCHAR(50) NOT NULL,
    "StoreLocationID" INT NOT NULL,
    "StoreManagerID" INT NULL,
    "StoreEstablishDate" DATE NOT NULL DEFAULT '01/01/2026',
    "StoreActiveStatus" TINYINT NOT NULL DEFAULT 1,
    "StoreClosingDate" DATE NULL
);
CREATE TABLE "StoreEmployee"(
    "EmployeeID" INT NOT NULL PRIMARY KEY,
    "EmployeeStoreID" INT NOT NULL,
    "EmployeeName" VARCHAR(50) NOT NULL,
    "EmployeeGender" VARCHAR(12) NOT NULL,
    "EmployeeDOB" DATE NOT NULL,
    "EmployeeEmail" VARCHAR(100) NOT NULL UNIQUE,
    "EmployeePhone" VARCHAR(10) NOT NULL UNIQUE,
    "EmployeeGovernmentID" VARCHAR(15) NOT NULL UNIQUE,
    "EmployeeJoinDate" DATE NOT NULL,
    "EmployeeActiveStatus" TINYINT NOT NULL DEFAULT 1,
    "EmployeeLeaveDate" DATE NULL
);
CREATE TABLE "StoreLocation"(
    "StoreLocationID" INT NOT NULL PRIMARY KEY,
    "StoreLocationArea" VARCHAR(30) NOT NULL,
    "StoreAddress" VARCHAR(200) NOT NULL
);
CREATE TABLE "Customer"(
    "CustomerID" INT NOT NULL PRIMARY KEY,
    "CustomerName" VARCHAR(50) NOT NULL,
    "CustomerEmail" VARCHAR(100) NULL,
    "CustomerPhone" VARCHAR(10) NOT NULL,
    "CustomerGender" VARCHAR(15) NULL,
    "CustomerDOB" DATE NULL,
    "CustomerRegisterDate" DATE NOT NULL,
    "CustomerActiveStatus" TINYINT NOT NULL DEFAULT 1,
    "CustomerDeactivateDate" DATE NULL
);
CREATE TABLE "Order"(
    "OrderID" INT NOT NULL PRIMARY KEY,
    "CustomerID" INT NOT NULL,
    "StoreID" INT NOT NULL,
    "EmployeeStoreID" INT NOT NULL,
    "OrderAmount" DECIMAL(9, 2) NOT NULL,
    "OrderStatus" TINYINT NOT NULL DEFAULT 5,
    "OrderDateTime" DATETIME NOT NULL
);
CREATE TABLE "OrderProduct"(
    "OrderID" INT NOT NULL,
    "ProductID" INT NOT NULL,
    "ProductOrderCount" INT NOT NULL,
    "ProductPrice" DECIMAL(7, 2) NOT NULL
);
CREATE TABLE "OrderTransaction"(
    "TransactionID" UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    "OrderID" INT NOT NULL,
    "PaymentType" VARCHAR(5) NOT NULL,
    "TransactionDateTime" DATETIME NOT NULL,
    "TransactionStatus" TINYINT NOT NULL
);
CREATE TABLE "StoreCashierFeedback"(
    "FeedbackID" INT NOT NULL PRIMARY KEY,
    "OrderID" INT NOT NULL UNIQUE,
    "StoreRating" INT NOT NULL,
    "CashierRating" INT NOT NULL,
    "FeedbackDetail" VARCHAR(255) NOT NULL
);
CREATE TABLE "Return"(
    "ReturnID" INT NOT NULL PRIMARY KEY,
    "OrderID" INT NOT NULL,
    "ReturnAmount" DECIMAL(9, 2) NOT NULL,
    "ReturnDateTime" DATETIME NOT NULL
);
CREATE TABLE "ReturnProduct"(
    "ReturnID" INT NOT NULL,
    "ProductID" INT NOT NULL,
    "ProductReturnCount" INT NOT NULL,
    "ProductPrice" DECIMAL(7, 2) NOT NULL,
    "ReturnReason" VARCHAR(255) NULL
);
CREATE TABLE "Status"(
    "StatusID" TINYINT NOT NULL PRIMARY KEY,
    "Status" VARCHAR(8) NOT NULL
);