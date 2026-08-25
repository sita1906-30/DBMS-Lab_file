AIM:Convert the ER diagram into a relational schema. Write complete MySQL CREATE TABLE statements with primary keys, foreign keys, NOT NULL, UNIQUE, ON DELETE CASCADE, and SET NULL constraints. Insert sample data and demonstrate referential integrity violations.




# Execution Results: `ecommerce.sql`

The SQL file [ecommerce.sql](file:///c:/Users/simran/OneDrive/Desktop/experiment%202/ecommerce.sql) was successfully run against an in-memory **SQLite 3.50.4** database with foreign keys enabled (`PRAGMA foreign_keys = ON;`). 

Below are the detailed execution outputs for each step of the script.

---

## 1. Initial Seed Data Verification

### Customers (`SELECT * FROM Customer;`)
| CustomerID | FirstName | LastName | Email | PhoneNo | RegisterDate |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | Simran | Rajput | simran@gmail.com | 9876543210 | 2026-01-10 |
| **2** | Aarav | Sharma | aarav@gmail.com | 9876543211 | 2026-02-15 |
| **3** | Priya | Verma | priya@gmail.com | 9876543212 | 2026-03-20 |

### Addresses (`SELECT * FROM Address;`)
| AddressID | CustomerID | AddressType | StreetHouseNo | PinCode | State | City |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | Home | House 21 | 226001 | Uttar Pradesh | Lucknow |
| **2** | 1 | Work | Office 12 | 226010 | Uttar Pradesh | Lucknow |
| **3** | 2 | Home | House 45 | 160014 | Punjab | Chandigarh |
| **4** | 3 | Home | House 78 | 110001 | Delhi | New Delhi |

### Sellers (`SELECT * FROM Seller;`)
| SellerID | PAN | BusinessName | GSTIN | Rating | BankDetails |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | ABCDE1234F | TechWorld | GSTIN001 | 4.5 | HDFC Bank |
| **2** | FGHIJ5678K | FashionHub | GSTIN002 | 4.2 | SBI Bank |

### Categories (`SELECT * FROM Category;`)
| CategoryID | CategoryName | Description |
| :--- | :--- | :--- |
| **1** | Electronics | Electronic products |
| **2** | Fashion | Fashion products |
| **3** | Books | Books and study material |

### Products (`SELECT * FROM Product;`)
| ProductID | SellerID | CategoryID | ProductName | Description | BasePrice | StockQuantity |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | 1 | Wireless Headphones | Bluetooth headphones | 1999 | 50 |
| **2** | 1 | 1 | Wireless Mouse | Ergonomic mouse | 799 | 100 |
| **3** | 2 | 2 | Denim Jacket | Casual denim jacket | 2499 | 30 |
| **4** | 2 | 2 | Cotton T-Shirt | Premium cotton T-shirt | 899 | 75 |

### Orders (`SELECT * FROM Orders;`)
| OrderID | CustomerID | OrderStatus | OrderDate | TotalAmount |
| :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | Confirmed | 2026-08-20 | 1999 |
| **2** | 2 | Shipped | 2026-08-21 | 1698 |
| **3** | 3 | Pending | 2026-08-22 | 2499 |

### OrderItems (`SELECT * FROM OrderItem;`)
| OrderItemID | OrderID | ProductID | UnitPrice | Quantity | TaxAmount | DiscountAmount |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | 1 | 1999 | 1 | 199.9 | 0 |
| **2** | 2 | 2 | 799 | 1 | 79.9 | 0 |
| **3** | 2 | 4 | 899 | 1 | 89.9 | 100 |
| **4** | 3 | 3 | 2499 | 1 | 249.9 | 0 |

### Payments (`SELECT * FROM Payment;`)
| PaymentID | OrderItemID | PaymentStatus | Amount | TransactionID | PaymentMode | PaymentDate |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | Completed | 1999 | TXN1001 | UPI | 2026-08-20 |
| **2** | 2 | Completed | 799 | TXN1002 | Card | 2026-08-21 |
| **3** | 3 | Completed | 799 | TXN1003 | UPI | 2026-08-21 |
| **4** | 4 | Pending | 2499 | TXN1004 | Net Banking | 2026-08-22 |

### Deliveries (`SELECT * FROM Delivery;`)
| DeliveryID | OrderItemID | TrackingNo | DispatchDate | ActualDeliveryDate | EstimatedDeliveryDate | DeliveryStatus | CourierPartner |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | 1 | TRK1001 | 2026-08-21 | 2026-08-23 | 2026-08-24 | Delivered | BlueDart |
| **2** | 2 | TRK1002 | 2026-08-22 | *NULL* | 2026-08-25 | In Transit | Delhivery |
| **3** | 3 | TRK1003 | 2026-08-22 | *NULL* | 2026-08-25 | In Transit | Ecom Express |
| **4** | 4 | TRK1004 | *NULL* | *NULL* | 2026-08-27 | Processing | Delhivery |

---

## 2. Foreign Key Cascade Demonstrations

### A. Customer Cascade Delete Verification (`CustomerID = 1`)

Before deleting Customer 1:
- **Customer details:**
  | CustomerID | FirstName | LastName | Email | PhoneNo | RegisterDate |
  | :--- | :--- | :--- | :--- | :--- | :--- |
  | 1 | Simran | Rajput | simran@gmail.com | 9876543210 | 2026-01-10 |
- **Addresses linked:**
  | AddressID | CustomerID | AddressType | StreetHouseNo | PinCode | State | City |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
  | 1 | 1 | Home | House 21 | 226001 | Uttar Pradesh | Lucknow |
  | 2 | 1 | Work | Office 12 | 226010 | Uttar Pradesh | Lucknow |
- **Orders linked:**
  | OrderID | CustomerID | OrderStatus | OrderDate | TotalAmount |
  | :--- | :--- | :--- | :--- | :--- |
  | 1 | 1 | Confirmed | 2026-08-20 | 1999 |

Running action:
```sql
DELETE FROM Customer WHERE CustomerID = 1;
```

After deleting Customer 1:
- **Addresses linked:** `0 rows returned` (Successfully cascaded delete)
- **Orders linked:** `0 rows returned` (Successfully cascaded delete)

---

### B. Seller Set Null Verification (`SellerID = 1`)

Before deleting Seller 1:
| ProductID | ProductName | SellerID |
| :--- | :--- | :--- |
| 1 | Wireless Headphones | **1** |
| 2 | Wireless Mouse | **1** |
| 3 | Denim Jacket | 2 |
| 4 | Cotton T-Shirt | 2 |

Running action:
```sql
DELETE FROM Seller WHERE SellerID = 1;
```

After deleting Seller 1:
| ProductID | ProductName | SellerID |
| :--- | :--- | :--- |
| 1 | Wireless Headphones | **NULL** |
| 2 | Wireless Mouse | **NULL** |
| 3 | Denim Jacket | 2 |
| 4 | Cotton T-Shirt | 2 |

*(Successfully updated matching products' SellerIDs to `NULL`)*

---

### C. Category Set Null Verification (`CategoryID = 1`)

Before deleting Category 1:
| ProductID | ProductName | CategoryID |
| :--- | :--- | :--- |
| 1 | Wireless Headphones | **1** |
| 2 | Wireless Mouse | **1** |
| 3 | Denim Jacket | 2 |
| 4 | Cotton T-Shirt | 2 |

Running action:
```sql
DELETE FROM Category WHERE CategoryID = 1;
```

After deleting Category 1:
| ProductID | ProductName | CategoryID |
| :--- | :--- | :--- |
| 1 | Wireless Headphones | **NULL** |
| 2 | Wireless Mouse | **NULL** |
| 3 | Denim Jacket | 2 |
| 4 | Cotton T-Shirt | 2 |

*(Successfully updated matching products' CategoryIDs to `NULL`)*
