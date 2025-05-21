
-- QUESTION 1 

--To transform the ProductDetail table into 1NF, we need to split the multi-valued Products column into individual rows. 
-- Create a new 1NF-compliant table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Split the Products column into atomic values and insert into the new table
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) numbers
ON
    CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;


    -- QUESTION 2

-- To resolve the partial dependency and achieve 2NF, split the table into two tables: Orders (order-level data) and OrderProducts (product-specific data)

-- Step 1: Create the Orders table (depends fully on OrderID)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Create the OrderProducts table (depends on OrderID + Product)
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Populate Orders with unique OrderID-CustomerName pairs
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Populate OrderProducts with OrderID-Product-Quantity data
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
