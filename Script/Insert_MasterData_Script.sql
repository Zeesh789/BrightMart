/* ==========================================================================
   Master data insert script
   Tables : ProductCategory, Product, StoreLocation, Store, StoreEmployee, Customer
   Volume : 10 categories, 38 products, 5 locations, 5 stores, 23 employees,
            150 customers
   Dates  : stores open 01-Feb-2026 to 01-Apr-2026; customers register
            01-Feb-2026 to 31-Aug-2026. Every record is active.
   Dates use the ISO format 'YYYY-MM-DD', which works with any DATEFORMAT setting.
   ========================================================================== */
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;

/* ---------- ProductCategory ---------- */
INSERT INTO ProductCategory (ProductCategoryID, ProductCategoryName, ProductCategoryIntroduceDate, ProductCategoryActiveStatus, ProductCategoryClosingDate) VALUES
(1, 'Groceries & Staples', '2026-02-01', 1, NULL),
(2, 'Beverages', '2026-02-01', 1, NULL),
(3, 'Snacks & Packaged Foods', '2026-02-01', 1, NULL),
(4, 'Dairy & Bakery', '2026-02-01', 1, NULL),
(5, 'Personal Care', '2026-02-01', 1, NULL),
(6, 'Household Cleaning', '2026-02-01', 1, NULL),
(7, 'Home & Kitchen', '2026-02-01', 1, NULL),
(8, 'Electronics & Accessories', '2026-02-01', 1, NULL),
(9, 'Stationery', '2026-02-01', 1, NULL),
(10, 'Apparel', '2026-02-01', 1, NULL);

/* ---------- Product ---------- */
INSERT INTO Product (ProductID, ProductCategoryID, ProductName, ProductPrice, ProductAvailableCount, ProductIntroduceDate, ProductActiveStatus, ProductDiscontinueDate) VALUES
(1, 1, 'Basmati Rice 5kg', 649.00, 55, '2026-02-01', 1, NULL),
(2, 1, 'Toor Dal 1kg', 165.00, 350, '2026-02-01', 1, NULL),
(3, 1, 'Whole Wheat Atta 10kg', 489.00, 470, '2026-02-01', 1, NULL),
(4, 1, 'Sunflower Oil 1L', 155.00, 470, '2026-02-01', 1, NULL),
(5, 2, 'Assam Tea 500g', 245.00, 560, '2026-02-01', 1, NULL),
(6, 2, 'Instant Coffee 100g', 299.00, 210, '2026-02-01', 1, NULL),
(7, 2, 'Mango Juice 1L', 110.00, 290, '2026-02-01', 1, NULL),
(8, 2, 'Packaged Drinking Water 1L', 20.00, 540, '2026-05-16', 1, NULL),
(9, 3, 'Salted Potato Chips 150g', 50.00, 500, '2026-02-01', 1, NULL),
(10, 3, 'Masala Instant Noodles Pack of 4', 56.00, 410, '2026-02-01', 1, NULL),
(11, 3, 'Roasted Peanuts 200g', 70.00, 510, '2026-02-01', 1, NULL),
(12, 3, 'Digestive Biscuits 250g', 45.00, 500, '2026-02-01', 1, NULL),
(13, 4, 'Toned Milk 1L', 58.00, 460, '2026-02-01', 1, NULL),
(14, 4, 'Paneer 200g', 90.00, 520, '2026-02-01', 1, NULL),
(15, 4, 'Salted Butter 500g', 285.00, 430, '2026-02-01', 1, NULL),
(16, 4, 'Brown Bread 400g', 50.00, 150, '2026-03-31', 1, NULL),
(17, 5, 'Herbal Shampoo 340ml', 225.00, 540, '2026-02-01', 1, NULL),
(18, 5, 'Toothpaste 150g', 99.00, 200, '2026-02-01', 1, NULL),
(19, 5, 'Bathing Soap Pack of 4', 160.00, 220, '2026-02-01', 1, NULL),
(20, 5, 'Aloe Vera Face Wash 100ml', 175.00, 330, '2026-02-01', 1, NULL),
(21, 6, 'Detergent Powder 2kg', 260.00, 210, '2026-02-01', 1, NULL),
(22, 6, 'Dishwash Liquid 750ml', 145.00, 430, '2026-02-01', 1, NULL),
(23, 6, 'Floor Cleaner 1L', 199.00, 150, '2026-02-01', 1, NULL),
(24, 7, 'Non-Stick Tawa 28cm', 899.00, 145, '2026-02-01', 1, NULL),
(25, 7, 'Steel Water Bottle 1L', 349.00, 460, '2026-02-01', 1, NULL),
(26, 7, 'Airtight Container Set of 3', 499.00, 580, '2026-02-01', 1, NULL),
(27, 7, 'Pressure Cooker 5L', 1850.00, 90, '2026-02-01', 1, NULL),
(28, 8, 'USB-C Charging Cable 1m', 299.00, 280, '2026-02-01', 1, NULL),
(29, 8, 'Wireless Earbuds', 1499.00, 100, '2026-02-01', 1, NULL),
(30, 8, 'LED Bulb 9W', 120.00, 310, '2026-02-01', 1, NULL),
(31, 8, 'Power Bank 10000mAh', 1199.00, 95, '2026-04-14', 1, NULL),
(32, 9, 'Ruled Notebook 200 Pages', 75.00, 390, '2026-02-01', 1, NULL),
(33, 9, 'Ball Pen Pack of 10', 100.00, 470, '2026-02-01', 1, NULL),
(34, 9, 'Geometry Box', 150.00, 550, '2026-02-01', 1, NULL),
(35, 10, 'Men''s Cotton T-Shirt', 499.00, 190, '2026-02-01', 1, NULL),
(36, 10, 'Women''s Cotton Kurti', 899.00, 90, '2026-02-01', 1, NULL),
(37, 10, 'Cotton Socks Pack of 3', 249.00, 200, '2026-02-01', 1, NULL),
(38, 10, 'Bath Towel', 399.00, 490, '2026-05-11', 1, NULL);

/* ---------- StoreLocation ---------- */
INSERT INTO StoreLocation (StoreLocationID, StoreLocationArea, StoreAddress) VALUES
(1, 'Andheri West', 'Shop 4, Link Square Mall, Linking Road, Andheri West, Mumbai, Maharashtra 400053'),
(2, 'Bandra West', '12 Hill Road, Near St. Peter''s Church, Bandra West, Mumbai, Maharashtra 400050'),
(3, 'Powai', 'Ground Floor, Galleria Complex, Hiranandani Gardens, Powai, Mumbai, Maharashtra 400076'),
(4, 'Thane West', 'Unit 7, Eastern Express Highway, Opp. Viviana Mall, Thane West, Maharashtra 400601'),
(5, 'Vashi', 'Plot 21, Sector 17, Palm Beach Road, Vashi, Navi Mumbai, Maharashtra 400703');

/* ---------- Store (StoreManagerID is filled after the employees are inserted) ---------- */
INSERT INTO Store (StoreID, StoreName, StoreLocationID, StoreManagerID, StoreEstablishDate, StoreActiveStatus, StoreClosingDate) VALUES
(1, 'DailyMart Andheri', 1, NULL, '2026-02-01', 1, NULL),
(2, 'DailyMart Bandra', 2, NULL, '2026-02-15', 1, NULL),
(3, 'DailyMart Powai', 3, NULL, '2026-03-01', 1, NULL),
(4, 'DailyMart Thane', 4, NULL, '2026-03-16', 1, NULL),
(5, 'DailyMart Vashi', 5, NULL, '2026-04-01', 1, NULL);

/* ---------- StoreEmployee (first employee of each store is its manager) ---------- */
INSERT INTO StoreEmployee (EmployeeID, EmployeeStoreID, EmployeeName, EmployeeGender, EmployeeDOB, EmployeeEmail, EmployeePhone, EmployeeGovernmentID, EmployeeJoinDate, EmployeeActiveStatus, EmployeeLeaveDate) VALUES
(1, 1, 'Ayesha Malhotra', 'Female', '1983-08-01', 'ayesha.malhotra@dailymart.in', '8055761698', 'PDNPM8976Q', '2026-02-01', 1, NULL),
(2, 1, 'Kritika Pandey', 'Female', '2003-10-01', 'kritika.pandey@dailymart.in', '6932081967', 'EPHPP1778I', '2026-02-09', 1, NULL),
(3, 1, 'Zoya Mishra', 'Female', '2004-04-04', 'zoya.mishra@dailymart.in', '9663440029', 'OZQPM7534W', '2026-02-12', 1, NULL),
(4, 1, 'Payal Kadam', 'Female', '2004-02-25', 'payal.kadam@dailymart.in', '9804571784', 'OFNPK7147L', '2026-02-13', 1, NULL),
(5, 1, 'Pranav Agarwal', 'Male', '1996-04-13', 'pranav.agarwal@dailymart.in', '6107981933', 'DTBPA8452A', '2026-02-08', 1, NULL),
(6, 2, 'Rupali Nair', 'Female', '1988-02-14', 'rupali.nair@dailymart.in', '7792984162', 'EZZPN9486M', '2026-02-15', 1, NULL),
(7, 2, 'Akash Singh', 'Male', '2001-06-08', 'akash.singh@dailymart.in', '6610550087', 'KVJPS7517O', '2026-02-15', 1, NULL),
(8, 2, 'Amit Chopra', 'Male', '2004-08-27', 'amit.chopra@dailymart.in', '9957931860', 'GUFPC0807Y', '2026-02-18', 1, NULL),
(9, 2, 'Aniket Patil', 'Male', '1995-11-24', 'aniket.patil@dailymart.in', '7822264686', 'CMJPP2524O', '2026-02-25', 1, NULL),
(10, 3, 'Kritika Chavan', 'Female', '1987-03-31', 'kritika.chavan@dailymart.in', '7587718841', 'GHAPC1756R', '2026-03-01', 1, NULL),
(11, 3, 'Vihaan Menon', 'Male', '1996-07-08', 'vihaan.menon@dailymart.in', '7194893949', 'IVRPM2141N', '2026-03-06', 1, NULL),
(12, 3, 'Rahul Joshi', 'Male', '2000-12-28', 'rahul.joshi@dailymart.in', '7185491452', 'IICPJ0646A', '2026-03-12', 1, NULL),
(13, 3, 'Rahul Pawar', 'Male', '1993-07-08', 'rahul.pawar@dailymart.in', '6189557990', 'MKTPP3976V', '2026-03-05', 1, NULL),
(14, 3, 'Sameer Kadam', 'Male', '1998-08-23', 'sameer.kadam@dailymart.in', '8506045414', 'YNKPK9085G', '2026-03-07', 1, NULL),
(15, 4, 'Siddharth Gupta', 'Male', '1988-12-10', 'siddharth.gupta@dailymart.in', '6102859406', 'SELPG6663Y', '2026-03-16', 1, NULL),
(16, 4, 'Anjali Nair', 'Female', '1997-02-11', 'anjali.nair@dailymart.in', '6886423004', 'RPNPN4529C', '2026-03-24', 1, NULL),
(17, 4, 'Joseph Deshmukh', 'Male', '2004-07-13', 'joseph.deshmukh@dailymart.in', '8585003703', 'VQEPD6538I', '2026-03-29', 1, NULL),
(18, 4, 'Meera Pillai', 'Female', '2001-01-20', 'meera.pillai@dailymart.in', '9879432627', 'ALQPP6021J', '2026-03-23', 1, NULL),
(19, 5, 'Ishita Jadhav', 'Female', '1983-07-20', 'ishita.jadhav@dailymart.in', '6083949066', 'RQZPJ2811E', '2026-04-01', 1, NULL),
(20, 5, 'Sana Mishra', 'Female', '1998-11-12', 'sana.mishra@dailymart.in', '6932448452', 'MGXPM0976L', '2026-04-05', 1, NULL),
(21, 5, 'Akash Patil', 'Male', '1997-01-11', 'akash.patil@dailymart.in', '7201805154', 'GREPP9932D', '2026-04-06', 1, NULL),
(22, 5, 'Rupali Mehta', 'Female', '1994-08-23', 'rupali.mehta@dailymart.in', '8941577188', 'HLVPM7951C', '2026-04-07', 1, NULL),
(23, 5, 'Saurabh Desai', 'Male', '1998-12-14', 'saurabh.desai@dailymart.in', '7256885576', 'KFGPD7355N', '2026-04-13', 1, NULL);

/* ---------- Assign store managers ---------- */
UPDATE s SET s.StoreManagerID = m.EmployeeID FROM Store s JOIN (VALUES
(1, 1),
(2, 6),
(3, 10),
(4, 15),
(5, 19)
) AS m (StoreID, EmployeeID) ON s.StoreID = m.StoreID;

/* ---------- Customer (registered 01-Feb-2026 to 31-Aug-2026) ---------- */
INSERT INTO Customer (CustomerID, CustomerName, CustomerEmail, CustomerPhone, CustomerGender, CustomerDOB, CustomerRegisterDate, CustomerActiveStatus, CustomerDeactivateDate) VALUES
(1, 'Aniket Rao', 'aniket.rao@gmail.com', '8072075473', 'Male', '1989-05-04', '2026-02-05', 1, NULL),
(2, 'Sakshi Kadam', 'sakshi.kadam@yahoo.com', '6884791889', 'Female', '1996-11-10', '2026-02-05', 1, NULL),
(3, 'Rupali Naik', 'rupali.naik@gmail.com', '8886193073', 'Female', '1975-08-23', '2026-02-07', 1, NULL),
(4, 'Deepak Kadam', 'deepak.kadam@gmail.com', '9285568983', 'Male', '1984-04-13', '2026-02-13', 1, NULL),
(5, 'Tanmay Mishra', 'tanmay.mishra@gmail.com', '6442248527', 'Male', '1965-06-24', '2026-02-15', 1, NULL),
(6, 'Vikram Joshi', 'vikram.joshi@rediffmail.com', '6438581762', 'Male', '2003-12-08', '2026-02-19', 1, NULL),
(7, 'Shreya Kadam', NULL, '8028316632', NULL, '1983-01-28', '2026-02-19', 1, NULL),
(8, 'Yash Gaikwad', 'yash.gaikwad@gmail.com', '9534789713', 'Male', '1997-12-18', '2026-02-22', 1, NULL),
(9, 'Siddharth Shah', 'siddharth.shah@rediffmail.com', '7636082445', 'Male', '1975-06-11', '2026-02-24', 1, NULL),
(10, 'Ananya Thakur', 'ananya.thakur@gmail.com', '6283576990', 'Female', '1972-05-17', '2026-02-24', 1, NULL),
(11, 'Pallavi Shah', 'pallavi.shah@gmail.com', '8401901879', 'Female', '1968-10-26', '2026-02-26', 1, NULL),
(12, 'Ankit Pandey', 'ankit.pandey@outlook.com', '8201612840', 'Male', NULL, '2026-02-27', 1, NULL),
(13, 'Rohan Banerjee', 'rohan.banerjee@rediffmail.com', '8735736385', 'Male', '1973-09-30', '2026-03-04', 1, NULL),
(14, 'Priya Gaikwad', 'priya.gaikwad@gmail.com', '9780736087', 'Female', '2002-09-24', '2026-03-05', 1, NULL),
(15, 'Manish Pawar', 'manish.pawar@gmail.com', '8982819539', 'Male', '1962-05-11', '2026-03-08', 1, NULL),
(16, 'Joseph Gupta', 'joseph.gupta@hotmail.com', '9033042845', 'Male', '1997-04-24', '2026-03-09', 1, NULL),
(17, 'Tushar Gupta', 'tushar.gupta@gmail.com', '9805780370', 'Male', '1970-05-18', '2026-03-09', 1, NULL),
(18, 'Neha Gupta', 'neha.gupta@gmail.com', '9418288983', 'Female', '1963-11-29', '2026-03-09', 1, NULL),
(19, 'Sneha Bhosale', 'sneha.bhosale@outlook.com', '6668179223', 'Female', '1962-10-27', '2026-03-09', 1, NULL),
(20, 'Joseph Singh', 'joseph.singh@gmail.com', '9105129837', 'Male', '1975-02-26', '2026-03-11', 1, NULL),
(21, 'Suresh Verma', 'suresh.verma@gmail.com', '9695851904', 'Male', '1968-01-14', '2026-03-11', 1, NULL),
(22, 'Siddharth Fernandes', 'siddharth.fernandes@gmail.com', '8800527913', 'Male', '1976-02-12', '2026-03-14', 1, NULL),
(23, 'Aditi Banerjee', 'aditi.banerjee@rediffmail.com', '6984264079', 'Female', NULL, '2026-03-15', 1, NULL),
(24, 'Shreya Fernandes', 'shreya.fernandes@gmail.com', '8716477447', 'Female', '1980-05-27', '2026-03-18', 1, NULL),
(25, 'Sonal Chavan', 'sonal.chavan@hotmail.com', '7346352136', 'Female', '1962-09-30', '2026-03-21', 1, NULL),
(26, 'Tanmay Rao', 'tanmay.rao@yahoo.com', '8573284093', 'Male', '1993-11-30', '2026-03-27', 1, NULL),
(27, 'Aditi Bansal', 'aditi.bansal@gmail.com', '6940985846', 'Female', '2004-07-30', '2026-03-27', 1, NULL),
(28, 'Neeraj Kadam', 'neeraj.kadam@rediffmail.com', '8683068669', 'Male', '1991-06-01', '2026-03-28', 1, NULL),
(29, 'Swati Mishra', 'swati.mishra@gmail.com', '6332796726', 'Female', '1962-08-12', '2026-04-01', 1, NULL),
(30, 'Sameer Patil', 'sameer.patil@gmail.com', '8816354011', 'Male', '2001-01-11', '2026-04-04', 1, NULL),
(31, 'Shreya Malhotra', 'shreya.malhotra@gmail.com', '9592115327', 'Female', '1977-02-08', '2026-04-04', 1, NULL),
(32, 'Kavya Mishra', 'kavya.mishra@yahoo.com', '9617707751', 'Female', '1961-11-05', '2026-04-05', 1, NULL),
(33, 'Gaurav Verma', 'gaurav.verma@gmail.com', '9152029944', 'Male', '1982-04-03', '2026-04-09', 1, NULL),
(34, 'Kavya Shaikh', 'kavya.shaikh@hotmail.com', '8569943982', 'Female', '1967-06-05', '2026-04-10', 1, NULL),
(35, 'Pallavi Deshmukh', 'pallavi.deshmukh@gmail.com', '7972584441', 'Female', '1983-05-19', '2026-04-11', 1, NULL),
(36, 'Aarav Singh', 'aarav.singh@gmail.com', '8669796156', 'Male', '1971-01-06', '2026-04-11', 1, NULL),
(37, 'Fatima Pandey', 'fatima.pandey@gmail.com', '8705670904', 'Female', '1991-06-19', '2026-04-11', 1, NULL),
(38, 'Siddharth Rao', 'siddharth.rao@yahoo.com', '6330132059', 'Male', '1983-02-02', '2026-04-13', 1, NULL),
(39, 'Kavya Das', 'kavya.das@rediffmail.com', '9311119602', 'Female', '1969-09-12', '2026-04-13', 1, NULL),
(40, 'Mansi Patil', 'mansi.patil@hotmail.com', '7064248296', 'Female', '1999-07-31', '2026-04-14', 1, NULL),
(41, 'Rohan Malhotra', 'rohan.malhotra@yahoo.com', '6412634789', 'Male', '1973-03-07', '2026-04-15', 1, NULL),
(42, 'Harsh Naik', 'harsh.naik@hotmail.com', '6376156105', 'Male', NULL, '2026-04-18', 1, NULL),
(43, 'Kunal Mishra', 'kunal.mishra@gmail.com', '6378522238', 'Male', '1969-12-23', '2026-04-18', 1, NULL),
(44, 'Isha Fernandes', 'isha.fernandes@rediffmail.com', '8719294808', 'Female', '1975-12-20', '2026-04-19', 1, NULL),
(45, 'Anjali More', 'anjali.more@gmail.com', '9134146175', 'Female', '2000-10-02', '2026-04-21', 1, NULL),
(46, 'Zoya Nair', 'zoya.nair@rediffmail.com', '6461338005', 'Female', NULL, '2026-04-22', 1, NULL),
(47, 'Vihaan Naik', NULL, '8893059776', 'Male', '1996-12-14', '2026-04-23', 1, NULL),
(48, 'Imran Pillai', 'imran.pillai@gmail.com', '6067090727', 'Male', '1996-02-11', '2026-04-25', 1, NULL),
(49, 'Isha Menon', 'isha.menon@gmail.com', '8370108752', 'Female', '1978-08-16', '2026-05-02', 1, NULL),
(50, 'Riya Singh', 'riya.singh@gmail.com', '9686316653', 'Female', '1985-09-02', '2026-05-07', 1, NULL),
(51, 'Pallavi Naik', 'pallavi.naik@gmail.com', '6342172334', 'Female', '1989-09-01', '2026-05-11', 1, NULL),
(52, 'Payal Malhotra', NULL, '6047516886', 'Female', '1986-01-12', '2026-05-12', 1, NULL),
(53, 'Kritika Shah', NULL, '7359534940', 'Female', '1964-12-12', '2026-05-13', 1, NULL),
(54, 'Aditi Pandey', 'aditi.pandey@hotmail.com', '6824460261', 'Female', '2006-06-14', '2026-05-14', 1, NULL),
(55, 'Bhavna Mishra', 'bhavna.mishra@rediffmail.com', '6052007009', 'Female', NULL, '2026-05-16', 1, NULL),
(56, 'Abhishek Joshi', 'abhishek.joshi@hotmail.com', '6570304887', 'Male', '1979-08-20', '2026-05-17', 1, NULL),
(57, 'Gauri Mehta', 'gauri.mehta@rediffmail.com', '6463511020', 'Female', NULL, '2026-05-18', 1, NULL),
(58, 'Mohit Pawar', 'mohit.pawar@gmail.com', '7004263716', 'Male', NULL, '2026-05-21', 1, NULL),
(59, 'Kavya Rao', 'kavya.rao@gmail.com', '6267081297', 'Female', '1964-01-10', '2026-05-21', 1, NULL),
(60, 'Diya Rao', 'diya.rao@outlook.com', '7981337027', 'Female', '1975-03-18', '2026-05-22', 1, NULL),
(61, 'Mohit Agarwal', 'mohit.agarwal@outlook.com', '8706755485', 'Male', '1969-07-11', '2026-05-22', 1, NULL),
(62, 'Deepak D''Souza', 'deepak.dsouza@gmail.com', '9825973481', 'Male', '2004-09-15', '2026-05-22', 1, NULL),
(63, 'Kunal Iyer', 'kunal.iyer@rediffmail.com', '8366282909', 'Male', '1993-09-26', '2026-05-25', 1, NULL),
(64, 'Aarav Sawant', 'aarav.sawant@rediffmail.com', '7204262837', 'Male', '1987-10-28', '2026-05-25', 1, NULL),
(65, 'Tanmay Pillai', NULL, '9041517801', 'Male', '1970-10-09', '2026-05-27', 1, NULL),
(66, 'Yash Reddy', 'yash.reddy@gmail.com', '7782760821', 'Male', '1999-03-19', '2026-05-28', 1, NULL),
(67, 'Kavya Verma', NULL, '9002238696', 'Female', '1965-06-17', '2026-05-30', 1, NULL),
(68, 'Nisha Jadhav', 'nisha.jadhav@yahoo.com', '8013510063', 'Female', '1988-07-28', '2026-05-30', 1, NULL),
(69, 'Pooja Thakur', NULL, '7351658509', 'Female', '1984-03-24', '2026-05-30', 1, NULL),
(70, 'Ishita Patil', 'ishita.patil@gmail.com', '6302250215', 'Female', '1966-11-03', '2026-05-31', 1, NULL),
(71, 'Aarav Pillai', 'aarav.pillai@gmail.com', '8183419082', 'Male', '1972-04-22', '2026-06-01', 1, NULL),
(72, 'Mohit D''Souza', 'mohit.dsouza@gmail.com', '6222386378', 'Male', '1971-11-06', '2026-06-01', 1, NULL),
(73, 'Rupali D''Souza', NULL, '8685424276', 'Female', '1975-05-17', '2026-06-02', 1, NULL),
(74, 'Pooja Gupta', 'pooja.gupta@hotmail.com', '9660471393', 'Female', '1982-11-20', '2026-06-05', 1, NULL),
(75, 'Sneha Pillai', 'sneha.pillai@gmail.com', '6960564333', 'Female', '2000-09-03', '2026-06-06', 1, NULL),
(76, 'Aditi Fernandes', 'aditi.fernandes@yahoo.com', '9444694037', 'Female', NULL, '2026-06-09', 1, NULL),
(77, 'Ishita Pawar', 'ishita.pawar@gmail.com', '9568965164', 'Female', '1960-05-15', '2026-06-09', 1, NULL),
(78, 'Saurabh Mishra', 'saurabh.mishra@gmail.com', '7209876953', 'Male', '1998-08-23', '2026-06-11', 1, NULL),
(79, 'Neha Iyer', NULL, '9002822070', 'Female', '2004-11-01', '2026-06-11', 1, NULL),
(80, 'Deepak Das', 'deepak.das@outlook.com', '7062443177', 'Male', '2004-09-13', '2026-06-14', 1, NULL),
(81, 'Simran Fernandes', 'simran.fernandes@gmail.com', '9792141534', 'Female', '2002-07-28', '2026-06-16', 1, NULL),
(82, 'Megha Banerjee', 'megha.banerjee@yahoo.com', '6899033212', 'Female', '1975-06-15', '2026-06-16', 1, NULL),
(83, 'Bhavna Kadam', 'bhavna.kadam@outlook.com', '6383129471', 'Female', '2001-10-05', '2026-06-18', 1, NULL),
(84, 'Diya Nair', 'diya.nair@hotmail.com', '6742565798', 'Female', '1976-03-28', '2026-06-19', 1, NULL),
(85, 'Aniket Mehta', 'aniket.mehta@yahoo.com', '6645011459', 'Male', '1998-07-26', '2026-06-20', 1, NULL),
(86, 'Kritika Deshmukh', 'kritika.deshmukh@outlook.com', '8007485148', 'Female', '1985-07-04', '2026-06-21', 1, NULL),
(87, 'Aarav Iyer', 'aarav.iyer@gmail.com', '6408378195', 'Male', '1998-06-10', '2026-06-23', 1, NULL),
(88, 'Pooja Sharma', NULL, '8446151575', 'Female', '1990-04-07', '2026-06-24', 1, NULL),
(89, 'Chirag Nair', 'chirag.nair@gmail.com', '7188904995', 'Male', '1963-07-02', '2026-06-25', 1, NULL),
(90, 'Rohan Desai', 'rohan.desai@yahoo.com', '9951685424', 'Male', '1994-04-23', '2026-06-25', 1, NULL),
(91, 'Zoya Jadhav', 'zoya.jadhav@outlook.com', '6655856252', NULL, '2004-12-26', '2026-06-26', 1, NULL),
(92, 'Fatima Bansal', NULL, '8056135750', 'Female', '1979-03-26', '2026-06-27', 1, NULL),
(93, 'Ayesha Gupta', 'ayesha.gupta@yahoo.com', '8331791430', 'Female', '1970-10-27', '2026-06-28', 1, NULL),
(94, 'Sakshi Malhotra', 'sakshi.malhotra@yahoo.com', '9918044186', 'Female', '2006-07-31', '2026-06-29', 1, NULL),
(95, 'Yash Jadhav', NULL, '9314395461', 'Male', '1988-03-03', '2026-07-01', 1, NULL),
(96, 'Abhishek Menon', 'abhishek.menon@outlook.com', '9641220284', 'Male', '1985-01-22', '2026-07-01', 1, NULL),
(97, 'Riya Rao', 'riya.rao@gmail.com', '9817688784', 'Female', '2001-10-17', '2026-07-03', 1, NULL),
(98, 'Isha Gaikwad', 'isha.gaikwad@outlook.com', '9566055483', 'Female', '1988-05-23', '2026-07-04', 1, NULL),
(99, 'Rupali Joshi', 'rupali.joshi@rediffmail.com', '9244871774', 'Female', '1966-03-31', '2026-07-04', 1, NULL),
(100, 'Gaurav More', NULL, '6722903575', 'Male', NULL, '2026-07-05', 1, NULL),
(101, 'Suresh Sawant', NULL, '8579101699', 'Male', '1990-04-21', '2026-07-07', 1, NULL),
(102, 'Chirag Khan', 'chirag.khan@outlook.com', '8514351159', 'Male', '2003-03-30', '2026-07-07', 1, NULL),
(103, 'Saurabh Kadam', 'saurabh.kadam@yahoo.com', '9147323124', 'Male', '1987-06-17', '2026-07-08', 1, NULL),
(104, 'Riya Mishra', 'riya.mishra@yahoo.com', '8404309642', 'Female', '2000-02-29', '2026-07-09', 1, NULL),
(105, 'Rajesh Khan', 'rajesh.khan@gmail.com', '7814957441', 'Male', '1968-05-11', '2026-07-09', 1, NULL),
(106, 'Ishita Fernandes', 'ishita.fernandes@hotmail.com', '7520426511', 'Female', NULL, '2026-07-11', 1, NULL),
(107, 'Tanvi D''Souza', 'tanvi.dsouza@outlook.com', '8902710528', 'Female', '1981-02-09', '2026-07-12', 1, NULL),
(108, 'Divya Chopra', 'divya.chopra@gmail.com', '7000714655', 'Female', '2005-11-03', '2026-07-15', 1, NULL),
(109, 'Megha Verma', 'megha.verma@gmail.com', '7022654908', 'Female', '2006-11-18', '2026-07-17', 1, NULL),
(110, 'Yash Pawar', 'yash.pawar@gmail.com', '6619227553', 'Male', '1990-07-19', '2026-07-18', 1, NULL),
(111, 'Tushar Chavan', 'tushar.chavan@gmail.com', '8593929817', 'Male', NULL, '2026-07-18', 1, NULL),
(112, 'Pranav Mishra', 'pranav.mishra@gmail.com', '9805786051', 'Male', '1972-11-04', '2026-07-20', 1, NULL),
(113, 'Aniket D''Souza', NULL, '8753707308', 'Male', '1976-07-25', '2026-07-21', 1, NULL),
(114, 'Kevin Joshi', 'kevin.joshi@gmail.com', '8452743680', 'Male', '1997-10-09', '2026-07-21', 1, NULL),
(115, 'Nisha Iyer', NULL, '9142251521', 'Female', '1974-01-17', '2026-07-22', 1, NULL),
(116, 'Sana Thakur', 'sana.thakur@rediffmail.com', '9058188589', 'Female', '1973-10-29', '2026-07-23', 1, NULL),
(117, 'Akash Shaikh', 'akash.shaikh@outlook.com', '9709131757', 'Male', NULL, '2026-07-25', 1, NULL),
(118, 'Ankit Joshi', NULL, '8479783768', 'Male', '1994-07-11', '2026-07-25', 1, NULL),
(119, 'Ritesh Malhotra', 'ritesh.malhotra@rediffmail.com', '7659660268', 'Male', '1971-04-01', '2026-07-26', 1, NULL),
(120, 'Abhishek Rao', 'abhishek.rao@yahoo.com', '9733374366', 'Male', '1985-04-23', '2026-07-28', 1, NULL),
(121, 'Aarav Desai', 'aarav.desai@gmail.com', '7317820540', 'Male', '2005-05-29', '2026-07-31', 1, NULL),
(122, 'Isha Pillai', 'isha.pillai@gmail.com', '9844317367', 'Female', '1961-12-03', '2026-08-01', 1, NULL),
(123, 'Neha Verma', 'neha.verma@yahoo.com', '9517472600', 'Female', '1988-12-12', '2026-08-02', 1, NULL),
(124, 'Nikhil Joshi', 'nikhil.joshi@gmail.com', '9367666971', 'Male', '1999-09-21', '2026-08-03', 1, NULL),
(125, 'Sonal Singh', NULL, '8099379749', 'Female', '1968-11-30', '2026-08-04', 1, NULL),
(126, 'Aditi Nair', 'aditi.nair@rediffmail.com', '8718480782', 'Female', NULL, '2026-08-05', 1, NULL),
(127, 'Divya Menon', 'divya.menon@gmail.com', '8402521960', 'Female', '2004-06-13', '2026-08-06', 1, NULL),
(128, 'Simran Pawar', 'simran.pawar@yahoo.com', '8708761375', 'Female', '1964-03-01', '2026-08-06', 1, NULL),
(129, 'Tushar Banerjee', 'tushar.banerjee@yahoo.com', '7262492170', 'Male', '1995-08-15', '2026-08-07', 1, NULL),
(130, 'Mansi Kadam', 'mansi.kadam@gmail.com', '8522250435', 'Female', '1971-10-16', '2026-08-08', 1, NULL),
(131, 'Kevin Kapoor', 'kevin.kapoor@gmail.com', '9216839956', 'Male', '1967-12-24', '2026-08-09', 1, NULL),
(132, 'Deepak Verma', NULL, '7524787530', NULL, '1965-01-07', '2026-08-10', 1, NULL),
(133, 'Faisal Deshmukh', 'faisal.deshmukh@rediffmail.com', '8748878101', 'Male', '2000-09-18', '2026-08-11', 1, NULL),
(134, 'Mohit Mehta', NULL, '6654771237', 'Male', '1978-06-01', '2026-08-14', 1, NULL),
(135, 'Aditi Bhosale', 'aditi.bhosale@hotmail.com', '8533161881', 'Female', '1963-04-08', '2026-08-14', 1, NULL),
(136, 'Zoya Singh', 'zoya.singh@yahoo.com', '6212066612', 'Female', NULL, '2026-08-15', 1, NULL),
(137, 'Suresh Rao', 'suresh.rao@rediffmail.com', '7507014657', 'Male', '1973-08-16', '2026-08-17', 1, NULL),
(138, 'Pooja Nair', 'pooja.nair@yahoo.com', '7811462032', 'Female', '1968-01-08', '2026-08-17', 1, NULL),
(139, 'Maria Bhosale', 'maria.bhosale@gmail.com', '7928510029', 'Female', '1976-11-16', '2026-08-18', 1, NULL),
(140, 'Tanvi Chavan', 'tanvi.chavan@gmail.com', '8772108357', 'Female', '1980-07-28', '2026-08-18', 1, NULL),
(141, 'Isha Das', 'isha.das@gmail.com', '8211116872', 'Female', '1990-06-26', '2026-08-19', 1, NULL),
(142, 'Suresh Agarwal', 'suresh.agarwal@gmail.com', '6211684455', 'Male', '1969-11-28', '2026-08-19', 1, NULL),
(143, 'Pooja Das', 'pooja.das@gmail.com', '7943949119', 'Female', '1962-08-07', '2026-08-20', 1, NULL),
(144, 'Saurabh Patil', NULL, '6404918053', 'Male', '1971-06-08', '2026-08-22', 1, NULL),
(145, 'Priya Kulkarni', 'priya.kulkarni@hotmail.com', '6034684203', 'Female', '1972-11-21', '2026-08-22', 1, NULL),
(146, 'Priya Malhotra', 'priya.malhotra@gmail.com', '9053365620', 'Female', '2002-07-09', '2026-08-23', 1, NULL),
(147, 'Siddharth Mehta', NULL, '6700153791', 'Male', '1980-03-26', '2026-08-23', 1, NULL),
(148, 'Rahul Kapoor', 'rahul.kapoor@yahoo.com', '8599490452', 'Male', '1971-10-22', '2026-08-24', 1, NULL),
(149, 'Karan Singh', NULL, '7644081869', 'Male', NULL, '2026-08-31', 1, NULL),
(150, 'Nisha D''Souza', NULL, '7249656799', 'Female', '1970-07-15', '2026-08-31', 1, NULL);

COMMIT TRANSACTION;
PRINT 'Master data inserted successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Insert failed, all changes rolled back: ' + ERROR_MESSAGE();
END CATCH;

INSERT INTO "Status"("StatusId", "Status") VALUES
(0, 'False'),
(1, 'True'),
(5, 'Pending');


/* ---------- Verification ---------- */
SELECT 'ProductCategory' AS TableName, COUNT(*) AS Total FROM ProductCategory
UNION ALL SELECT 'Product',       COUNT(*) FROM Product
UNION ALL SELECT 'StoreLocation', COUNT(*) FROM StoreLocation
UNION ALL SELECT 'Store',         COUNT(*) FROM Store
UNION ALL SELECT 'StoreEmployee', COUNT(*) FROM StoreEmployee
UNION ALL SELECT 'Customer',      COUNT(*) FROM Customer;

SELECT FORMAT(CustomerRegisterDate, 'yyyy-MM') AS RegisterMonth, COUNT(*) AS Customers
FROM Customer GROUP BY FORMAT(CustomerRegisterDate, 'yyyy-MM') ORDER BY RegisterMonth;

SELECT s.StoreID, s.StoreName, s.StoreEstablishDate, e.EmployeeName AS Manager,
       (SELECT COUNT(*) FROM StoreEmployee x WHERE x.EmployeeStoreID = s.StoreID) AS Employees
FROM Store s JOIN StoreEmployee e ON e.EmployeeID = s.StoreManagerID;
