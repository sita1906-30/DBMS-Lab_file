# EXPERIMENT – 10

## AIM
Generate a dataset with at least 10,000 rows. Write five slow queries, analyze them using EXPLAIN, optimize them using indexing and query rewriting, and compare execution time before and after optimization.

## EXECUTION RESULTS

### 1. Creation of Sales Table

A table named `Sales` was created with the following attributes:

- sale_id
- customer_id
- customer_name
- product_name
- category
- region
- quantity
- unit_price
- sale_date
- status

### 2. Generation of Records

The stored procedure `GenerateSalesData()` was executed to insert 10,000 records into the Sales table.

**Output:**

| total_records |
|---:|
| 10000 |

### 3. Display of First 10 Records

| sale_id | customer_id | customer_name | product_name | category | region | quantity | unit_price | sale_date | status |
|---:|---:|---|---|---|---|---:|---:|---|---|
| 1 | 2 | Customer_2 | Product_2 | Clothing | South | 2 | 137 | 2024-01-02 | Pending |
| 2 | 3 | Customer_3 | Product_3 | Books | East | 3 | 174 | 2024-01-03 | Cancelled |
| 3 | 4 | Customer_4 | Product_4 | Furniture | West | 4 | 211 | 2024-01-04 | Completed |
| 4 | 5 | Customer_5 | Product_5 | Sports | North | 5 | 248 | 2024-01-05 | Pending |
| 5 | 6 | Customer_6 | Product_6 | Electronics | South | 6 | 285 | 2024-01-06 | Cancelled |
| 6 | 7 | Customer_7 | Product_7 | Clothing | East | 7 | 322 | 2024-01-07 | Completed |
| 7 | 8 | Customer_8 | Product_8 | Books | West | 8 | 359 | 2024-01-08 | Pending |
| 8 | 9 | Customer_9 | Product_9 | Furniture | North | 9 | 396 | 2024-01-09 | Cancelled |
| 9 | 10 | Customer_10 | Product_10 | Sports | South | 10 | 433 | 2024-01-10 | Completed |
| 10 | 11 | Customer_11 | Product_11 | Electronics | East | 1 | 470 | 2024-01-11 | Pending |

### 4. Execution of Five Queries Before Optimization

**Query 1: Filter by region and status**

```sql
SELECT *
FROM Sales
WHERE region = 'North'
AND status = 'Completed';
```

**Query 2: Filter by date range**

```sql
SELECT *
FROM Sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-06-30';
```

**Query 3: Filter by category and region**

```sql
SELECT *
FROM Sales
WHERE category = 'Electronics'
AND region = 'West';
```

**Query 4: Aggregation by region**

```sql
SELECT region,
       SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;
```

**Query 5: Customer sales aggregation with HAVING**

```sql
SELECT customer_id,
       SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;
```

The EXPLAIN command was used to examine the execution plans of these queries before optimization.

### 5. Creation of Indexes

The following indexes were created to improve query performance:

```sql
CREATE INDEX idx_region_status
ON Sales(region, status);

CREATE INDEX idx_sale_date
ON Sales(sale_date);

CREATE INDEX idx_category_region
ON Sales(category, region);

CREATE INDEX idx_region
ON Sales(region);

CREATE INDEX idx_customer_id
ON Sales(customer_id);

ANALYZE TABLE Sales;
```

### 6. Query Optimization

The queries were executed again after creating indexes.

- A composite index on `region` and `status` was used for Query 1.
- An index on `sale_date` was used for Query 2.
- A composite index on `category` and `region` was used for Query 3.
- An index on `region` may assist Query 4 grouping.
- An index on `customer_id` may assist Query 5 grouping.

### 7. Query Rewriting

The following query uses a function on the indexed date column:

```sql
SELECT COUNT(*)
FROM Sales
WHERE YEAR(sale_date) = 202