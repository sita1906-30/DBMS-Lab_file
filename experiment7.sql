
-- EXPERIMENT 7: NORMALIZATION

CREATE TABLE Sales_UNF (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE NOT NULL,
    Customer_ID INT NOT NULL,
    Customer_Name VARCHAR(100) NOT NULL,
    Customer_City VARCHAR(100) NOT NULL,
    Products VARCHAR(500) NOT NULL
);

INSERT INTO Sales_UNF VALUES
(1001, '2026-01-10', 1, 'Aarav Sharma', 'Chandigarh',
 'Laptop:1:55000,Mouse:2:799'),
(1002, '2026-01-11', 2, 'Priya Verma', 'Delhi',
 'Keyboard:1:1200,Mouse:1:799'),
(1003, '2026-01-12', 1, 'Aarav Sharma', 'Chandigarh',
 'Monitor:1:12000,Laptop:1:55000');

SELECT * FROM Sales_UNF;

-- 1NF

DROP TABLE IF EXISTS Sales_1NF;

CREATE TABLE Sales_1NF (
    Order_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Customer_ID INT NOT NULL,
    Customer_Name VARCHAR(100) NOT NULL,
    Customer_City VARCHAR(100) NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Order_ID, Product_Name)
);

INSERT INTO Sales_1NF VALUES
(1001, '2026-01-10', 1, 'Aarav Sharma', 'Chandigarh', 'Laptop', 1, 55000),
(1001, '2026-01-10', 1, 'Aarav Sharma', 'Chandigarh', 'Mouse', 2, 799),
(1002, '2026-01-11', 2, 'Priya Verma', 'Delhi', 'Keyboard', 1, 1200),
(1002, '2026-01-11', 2, 'Priya Verma', 'Delhi', 'Mouse', 1, 799),
(1003, '2026-01-12', 1, 'Aarav Sharma', 'Chandigarh', 'Monitor', 1, 12000),
(1003, '2026-01-12', 1, 'Aarav Sharma', 'Chandigarh', 'Laptop', 1, 55000);

SELECT * FROM Sales_1NF;

-- 2NF

CREATE TABLE Orders_2NF (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE NOT NULL,
    Customer_ID INT NOT NULL,
    Customer_Name VARCHAR(100) NOT NULL,
    Customer_City VARCHAR(100) NOT NULL
);

CREATE TABLE Products_2NF (
    Product_Name VARCHAR(100) PRIMARY KEY,
    Unit_Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Order_Details_2NF (
    Order_ID INT NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (Order_ID, Product_Name),
    FOREIGN KEY (Order_ID)
        REFERENCES Orders_2NF(Order_ID),
    FOREIGN KEY (Product_Name)
        REFERENCES Products_2NF(Product_Name)
);

INSERT INTO Orders_2NF VALUES
(1001, '2026-01-10', 1, 'Aarav Sharma', 'Chandigarh'),
(1002, '2026-01-11', 2, 'Priya Verma', 'Delhi'),
(1003, '2026-01-12', 1, 'Aarav Sharma', 'Chandigarh');

INSERT INTO Products_2NF VALUES
('Laptop', 55000),
('Mouse', 799),
('Keyboard', 1200),
('Monitor', 12000);

INSERT INTO Order_Details_2NF VALUES
(1001, 'Laptop', 1),
(1001, 'Mouse', 2),
(1002, 'Keyboard', 1),
(1002, 'Mouse', 1),
(1003, 'Monitor', 1),
(1003, 'Laptop', 1);

-- Verify 2NF data

SELECT * FROM Orders_2NF;
SELECT * FROM Products_2NF;
SELECT * FROM Order_Details_2NF;

-- 3NF

DROP TABLE IF EXISTS Order_Details_3NF;
DROP TABLE IF EXISTS Orders_3NF;
DROP TABLE IF EXISTS Customers_3NF;
DROP TABLE IF EXISTS Products_3NF;

CREATE TABLE Customers_3NF (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Customer_City VARCHAR(100) NOT NULL
);

CREATE TABLE Orders_3NF (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE NOT NULL,
    Customer_ID INT NOT NULL,
    FOREIGN KEY (Customer_ID)
        REFERENCES Customers_3NF(Customer_ID)
);

CREATE TABLE Products_3NF (
    Product_Name VARCHAR(100) PRIMARY KEY,
    Unit_Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Order_Details_3NF (
    Order_ID INT NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (Order_ID, Product_Name),
    FOREIGN KEY (Order_ID)
        REFERENCES Orders_3NF(Order_ID),
    FOREIGN KEY (Product_Name)
        REFERENCES Products_3NF(Product_Name)
);

INSERT INTO Customers_3NF VALUES
(1, 'Aarav Sharma', 'Chandigarh'),
(2, 'Priya Verma', 'Delhi');

INSERT INTO Orders_3NF VALUES
(1001, '2026-01-10', 1),
(1002, '2026-01-11', 2),
(1003, '2026-01-12', 1);

INSERT INTO Products_3NF VALUES
('Laptop', 55000),
('Mouse', 799),
('Keyboard', 1200),
('Monitor', 12000);

INSERT INTO Order_Details_3NF VALUES
(1001, 'Laptop', 1),
(1001, 'Mouse', 2),
(1002, 'Keyboard', 1),
(1002, 'Mouse', 1),
(1003, 'Monitor', 1),
(1003, 'Laptop', 1);

-- Reconstruct original data using JOIN

SELECT
    o.Order_ID,
    o.Order_Date,
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_City,
    od.Product_Name,
    od.Quantity,
    p.Unit_Price
FROM Orders_3NF o
JOIN Customers_3NF c
    ON o.Customer_ID = c.Customer_ID
JOIN Order_Details_3NF od
    ON o.Order_ID = od.Order_ID
JOIN Products_3NF p
    ON od.Product_Name = p.Product_Name
ORDER BY o.Order_ID, od.Product_Name;

-- Verify lossless join

SELECT COUNT(*) AS Reconstructed_Rows
FROM Orders_3NF o
JOIN Customers_3NF c
    ON o.Customer_ID = c.Customer_ID
JOIN Order_Details_3NF od
    ON o.Order_ID = od.Order_ID
JOIN Products_3NF p
    ON od.Product_Name = p.Product_Name;

-- Compare with original 1NF row count

SELECT COUNT(*) AS Original_Rows
FROM Sales_1NF;

-- Verify functional dependencies

-- FD 1: Customer_ID -> Customer_Name, Customer_City

SELECT Customer_ID, COUNT(*) AS Occurrences
FROM Customers_3NF
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- FD 2: Order_ID -> Order_Date, Customer_ID

SELECT Order_ID, COUNT(*) AS Occurrences
FROM Orders_3NF
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- FD 3: Product_Name -> Unit_Price

SELECT Product_Name, COUNT(*) AS Occurrences
FROM Products_3NF
GROUP BY Product_Name
HAVING COUNT(*) > 1;

-- FD 4: (Order_ID, Product_Name) -> Quantity

SELECT Order_ID, Product_Name, COUNT(*) AS Occurrences
FROM Order_Details_3NF
GROUP BY Order_ID, Product_Name
HAVING COUNT(*) > 1;

-- Inspect constraints and schema definitions

SHOW CREATE TABLE Customers_3NF;
SHOW CREATE TABLE Orders_3NF;
SHOW CREATE TABLE Products_3NF;
SHOW CREATE TABLE Order_Details_3NF;

-- Display total records

SELECT COUNT(*) AS Total_Customers FROM Customers_3NF;
SELECT COUNT(*) AS Total_Orders FROM Orders_3NF;
SELECT COUNT(*) AS Total_Products FROM Products_3NF;
SELECT COUNT(*) AS Total_Order_Details FROM Order_Details_3NF;
