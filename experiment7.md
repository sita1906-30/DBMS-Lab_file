# EXPERIMENT 7: DATABASE NORMALIZATION

## AIM

To identify functional dependencies in a denormalized Sales table and normalize it step-by-step from Unnormalized Form (UNF) to First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF). To verify lossless join and dependency preservation using SQL queries.

## EXECUTION RESULT

The SQL queries were executed successfully in MySQL Workbench. The Sales table was normalized into 1NF, 2NF and 3NF by removing repeating groups, partial dependencies and transitive dependencies.

### 1. Output: Sales_UNF Table

| Order_ID | Order_Date | Customer_ID | Customer_Name | Customer_City |
|---|---|---|---|---|
| 1001 | 2026-01-10 | 1 | Aarav Sharma | Chandigarh |
| 1002 | 2026-01-11 | 2 | Priya Verma | Delhi |
| 1003 | 2026-01-12 | 1 | Aarav Sharma | Chandigarh |

Products column:

| Order_ID | Products |
|---|---|
| 1001 | Laptop:1:55000, Mouse:2:799 |
| 1002 | Keyboard:1:1200, Mouse:1:799 |
| 1003 | Monitor:1:12000, Laptop:1:55000 |

### 2. Output: Sales_1NF Table

Repeating groups were separated into individual rows.

| Order_ID | Customer_ID | Product_Name | Quantity | Unit_Price |
|---|---|---|---|---:|
| 1001 | 1 | Laptop | 1 | 55000.00 |
| 1001 | 1 | Mouse | 2 | 799.00 |
| 1002 | 2 | Keyboard | 1 | 1200.00 |
| 1002 | 2 | Mouse | 1 | 799.00 |
| 1003 | 1 | Monitor | 1 | 12000.00 |
| 1003 | 1 | Laptop | 1 | 55000.00 |

**Total records: 6**

### 3. Output: 2NF Tables

**Orders_2NF**

| Order_ID | Order_Date | Customer_ID | Customer_Name | Customer_City |
|---|---|---|---|---|
| 1001 | 2026-01-10 | 1 | Aarav Sharma | Chandigarh |
| 1002 | 2026-01-11 | 2 | Priya Verma | Delhi |
| 1003 | 2026-01-12 | 1 | Aarav Sharma | Chandigarh |

**Products_2NF**

| Product_Name | Unit_Price |
|---|---:|
| Laptop | 55000.00 |
| Mouse | 799.00 |
| Keyboard | 1200.00 |
| Monitor | 12000.00 |

**Order_Details_2NF**

| Order_ID | Product_Name | Quantity |
|---|---|---:|
| 1001 | Laptop | 1 |
| 1001 | Mouse | 2 |
| 1002 | Keyboard | 1 |
| 1002 | Mouse | 1 |
| 1003 | Monitor | 1 |
| 1003 | Laptop | 1 |

### 4. Output: 3NF Tables

**Customers_3NF**

| Customer_ID | Customer_Name | Customer_City |
|---|---|---|
| 1 | Aarav Sharma | Chandigarh |
| 2 | Priya Verma | Delhi |

**Orders_3NF**

| Order_ID | Order_Date | Customer_ID |
|---|---|---|
| 1001 | 2026-01-10 | 1 |
| 1002 | 2026-01-11 | 2 |
| 1003 | 2026-01-12 | 1 |

**Products_3NF**

| Product_Name | Unit_Price |
|---|---:|
| Laptop | 55000.00 |
| Mouse | 799.00 |
| Keyboard | 1200.00 |
| Monitor | 12000.00 |

**Order_Details_3NF**

| Order_ID | Product_Name | Quantity |
|---|---|---:|
| 1001 | Laptop | 1 |
| 1001 | Mouse | 2 |
| 1002 | Keyboard | 1 |
| 1002 | Mouse | 1 |
| 1003 | Monitor | 1 |
| 1003 | Laptop | 1 |

### 5. Output: Reconstructed Data Using JOIN

The original data was reconstructed using INNER JOIN operations on all four 3NF tables.

| Order_ID | Order_Date | Customer_ID | Customer_Name | Customer_City | Product_Name | Quantity | Unit_Price |
|---|---|---|---|---|---|---:|---:|
| 1001 | 2026-01-10 | 1 | Aarav Sharma | Chandigarh | Laptop | 1 | 55000.00 |
| 1001 | 2026-01-10 | 1 | Aarav Sharma | Chandigarh | Mouse | 2 | 799.00 |
| 1002 | 2026-01-11 | 2 | Priya Verma | Delhi | Keyboard | 1 | 1200.00 |
| 1002 | 2026-01-11 | 2 | Priya Verma | Delhi | Mouse | 1 | 799.00 |
| 1003 | 2026-01-12 | 1 | Aarav Sharma | Chandigarh | Laptop | 1 | 55000.00 |
| 1003 | 2026-01-12 | 1 | Aarav Sharma | Chandigarh | Monitor | 1 | 12000.00 |

### 6. Output: Lossless Join Verification

Query:

```sql
SELECT COUNT(*) AS Reconstructed_Rows
FROM Orders_3NF o
JOIN Customers_3NF c
    ON o.Customer_ID = c.Customer_ID
JOIN Order_Details_3NF od
    ON o.Order_ID = od.Order_ID
JOIN Products_3NF p
    ON od.Product_Name = p.Product_Name;
```

**Result:**

| Reconstructed_Rows |
|---:|
| 6 |

Original 1NF row count:

| Original_Rows |
|---:|
| 6 |

Both counts are equal, confirming lossless reconstruction for the given dataset.

### 7. Output: Functional Dependency Verification

The following functional dependencies were checked:

1. Customer_ID → Customer_Name, Customer_City
2. Order_ID → Order_Date, Customer_ID
3. Product_Name → Unit_Price
4. (Order_ID, Product_Name) → Quantity

The GROUP BY and HAVING queries returned empty result sets for all four checks.

**Result:** No duplicate key records were found.

### 8. Final Record Count

| Table Name | Total Records |
|---|---:|
| Customers_3NF | 2 |
| Orders_3NF | 3 |
| Products_3NF | 4 |
| Order_Details_3NF | 6 |

## CONCLUSION

Successfully implemented database normalization from UNF to 1NF, 2NF and 3NF using MySQL. Repeating groups, partial dependencies and transitive dependencies were eliminated by decomposing the Sales table into multiple related tables. Primary keys, foreign keys and functional dependencies were verified. The original data was successfully reconstructed using JOIN operations, confirming a lossless join for the given dataset.
