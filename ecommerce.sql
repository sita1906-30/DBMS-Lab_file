CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNo VARCHAR(15) UNIQUE,
    RegisterDate DATE NOT NULL
);
CREATE TABLE Address (
    AddressID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AddressType VARCHAR(20) NOT NULL,
    StreetHouseNo VARCHAR(150) NOT NULL,
    PinCode VARCHAR(10) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE Seller (
    SellerID INT PRIMARY KEY,
    PAN VARCHAR(20) NOT NULL UNIQUE,
    BusinessName VARCHAR(100) NOT NULL,
    GSTIN VARCHAR(20) UNIQUE,
    Rating DECIMAL(3,2),
    BankDetails VARCHAR(100)
);
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    SellerID INT,
    CategoryID INT,
    ProductName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    BasePrice DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,

    FOREIGN KEY (SellerID)
        REFERENCES Seller(SellerID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    TaxAmount DECIMAL(10,2),
    DiscountAmount DECIMAL(10,2),

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    OrderItemID INT NOT NULL UNIQUE,
    PaymentStatus VARCHAR(30) NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    TransactionID VARCHAR(100) NOT NULL UNIQUE,
    PaymentMode VARCHAR(30) NOT NULL,
    PaymentDate DATE NOT NULL,

    FOREIGN KEY (OrderItemID)
        REFERENCES OrderItem(OrderItemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY,
    OrderItemID INT NOT NULL UNIQUE,
    TrackingNo VARCHAR(100) UNIQUE,
    DispatchDate DATE,
    ActualDeliveryDate DATE,
    EstimatedDeliveryDate DATE,
    DeliveryStatus VARCHAR(30) NOT NULL,
    CourierPartner VARCHAR(100),

    FOREIGN KEY (OrderItemID)
        REFERENCES OrderItem(OrderItemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Customer
(CustomerID, FirstName, LastName, Email, PhoneNo, RegisterDate)
VALUES
(1, 'Simran', 'Rajput', 'simran@gmail.com', '9876543210', '2026-01-10'),
(2, 'Aarav', 'Sharma', 'aarav@gmail.com', '9876543211', '2026-02-15'),
(3, 'Priya', 'Verma', 'priya@gmail.com', '9876543212', '2026-03-20');

INSERT INTO Address
(AddressID, CustomerID, AddressType, StreetHouseNo, PinCode, State, City)
VALUES
(1, 1, 'Home', 'House 21', '226001', 'Uttar Pradesh', 'Lucknow'),
(2, 1, 'Work', 'Office 12', '226010', 'Uttar Pradesh', 'Lucknow'),
(3, 2, 'Home', 'House 45', '160014', 'Punjab', 'Chandigarh'),
(4, 3, 'Home', 'House 78', '110001', 'Delhi', 'New Delhi');

INSERT INTO Seller
(SellerID, PAN, BusinessName, GSTIN, Rating, BankDetails)
VALUES
(1, 'ABCDE1234F', 'TechWorld', 'GSTIN001', 4.50, 'HDFC Bank'),
(2, 'FGHIJ5678K', 'FashionHub', 'GSTIN002', 4.20, 'SBI Bank');

INSERT INTO Category
(CategoryID, CategoryName, Description)
VALUES
(1, 'Electronics', 'Electronic products'),
(2, 'Fashion', 'Fashion products'),
(3, 'Books', 'Books and study material');

INSERT INTO Product
(ProductID, SellerID, CategoryID, ProductName, Description, BasePrice, StockQuantity)
VALUES
(1, 1, 1, 'Wireless Headphones', 'Bluetooth headphones', 1999.00, 50),
(2, 1, 1, 'Wireless Mouse', 'Ergonomic mouse', 799.00, 100),
(3, 2, 2, 'Denim Jacket', 'Casual denim jacket', 2499.00, 30),
(4, 2, 2, 'Cotton T-Shirt', 'Premium cotton T-shirt', 899.00, 75);

INSERT INTO Orders
(OrderID, CustomerID, OrderStatus, OrderDate, TotalAmount)
VALUES
(1, 1, 'Confirmed', '2026-08-20', 1999.00),
(2, 2, 'Shipped', '2026-08-21', 1698.00),
(3, 3, 'Pending', '2026-08-22', 2499.00);

INSERT INTO OrderItem
(OrderItemID, OrderID, ProductID, UnitPrice, Quantity, TaxAmount, DiscountAmount)
VALUES
(1, 1, 1, 1999.00, 1, 199.90, 0.00),
(2, 2, 2, 799.00, 1, 79.90, 0.00),
(3, 2, 4, 899.00, 1, 89.90, 100.00),
(4, 3, 3, 2499.00, 1, 249.90, 0.00);

INSERT INTO Payment
(PaymentID, OrderItemID, PaymentStatus, Amount, TransactionID, PaymentMode, PaymentDate)
VALUES
(1, 1, 'Completed', 1999.00, 'TXN1001', 'UPI', '2026-08-20'),
(2, 2, 'Completed', 799.00, 'TXN1002', 'Card', '2026-08-21'),
(3, 3, 'Completed', 799.00, 'TXN1003', 'UPI', '2026-08-21'),
(4, 4, 'Pending', 2499.00, 'TXN1004', 'Net Banking', '2026-08-22');

INSERT INTO Delivery
(DeliveryID, OrderItemID, TrackingNo, DispatchDate,
ActualDeliveryDate, EstimatedDeliveryDate, DeliveryStatus, CourierPartner)
VALUES
(1, 1, 'TRK1001', '2026-08-21', '2026-08-23',
'2026-08-24', 'Delivered', 'BlueDart'),

(2, 2, 'TRK1002', '2026-08-22', NULL,
'2026-08-25', 'In Transit', 'Delhivery'),

(3, 3, 'TRK1003', '2026-08-22', NULL,
'2026-08-25', 'In Transit', 'Ecom Express'),

(4, 4, 'TRK1004', NULL, NULL,
'2026-08-27', 'Processing', 'Delhivery');

SELECT * FROM Customer;
SELECT * FROM Address;
SELECT * FROM Seller;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderItem;
SELECT * FROM Payment;
SELECT * FROM Delivery;

SELECT * FROM Customer
WHERE CustomerID = 1;

SELECT * FROM Address
WHERE CustomerID = 1;

SELECT * FROM Orders
WHERE CustomerID = 1;

DELETE FROM Customer
WHERE CustomerID = 1;

SELECT * FROM Address
WHERE CustomerID = 1;

SELECT * FROM Orders
WHERE CustomerID = 1;

SELECT ProductID, ProductName, SellerID
FROM Product;

DELETE FROM Seller
WHERE SellerID = 1;

SELECT ProductID, ProductName, SellerID
FROM Product;

SELECT ProductID, ProductName, CategoryID
FROM Product;

DELETE FROM Category
WHERE CategoryID = 1;

SELECT ProductID, ProductName, CategoryID
FROM Product;