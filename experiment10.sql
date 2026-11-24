
-- EXPERIMENT 10: QUERY OPTIMIZATION

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    sale_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL
) ENGINE = InnoDB;

-- Generate 10000 records

DELIMITER //

CREATE PROCEDURE GenerateSalesData()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 10000 DO

        INSERT INTO Sales VALUES (
            i,
            MOD(i, 1000) + 1,
            CONCAT('Customer_', MOD(i, 1000) + 1),
            CONCAT('Product_', MOD(i, 100) + 1),

            ELT(MOD(i, 5) + 1,
                'Electronics', 'Clothing', 'Books',
                'Furniture', 'Sports'),

            ELT(MOD(i, 4) + 1,
                'North', 'South', 'East', 'West'),

            MOD(i, 10) + 1,
            100 + MOD(i * 37, 5000),

            DATE_ADD(
                '2024-01-01',
                INTERVAL MOD(i, 730) DAY
            ),

            ELT(MOD(i, 3) + 1,
                'Completed', 'Pending', 'Cancelled')
        );

        SET i = i + 1;

    END WHILE;
END //

DELIMITER ;

CALL GenerateSalesData();

SELECT COUNT(*) AS total_records FROM Sales;

SELECT * FROM Sales LIMIT 10;

-- QUERY 1: Filter by region and status

EXPLAIN
SELECT *
FROM Sales
WHERE region = 'North'
AND status = 'Completed';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE region = 'North'
AND status = 'Completed';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q1_before_microseconds;

-- QUERY 2: Filter by date range

EXPLAIN
SELECT *
FROM Sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-06-30';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-06-30';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q2_before_microseconds;

-- QUERY 3: Filter by category and region

EXPLAIN
SELECT *
FROM Sales
WHERE category = 'Electronics'
AND region = 'West';

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE category = 'Electronics'
AND region = 'West';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q3_before_microseconds;

-- QUERY 4: Aggregation by region

EXPLAIN
SELECT region, SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE region,
    SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q4_before_microseconds;

-- QUERY 5: Customer sales aggregation with HAVING

EXPLAIN
SELECT customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q5_before_microseconds;

-- CREATE INDEXES

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

-- EXPLAIN AFTER INDEXING

EXPLAIN
SELECT *
FROM Sales
WHERE region = 'North'
AND status = 'Completed';

EXPLAIN
SELECT *
FROM Sales
WHERE sale_date >= '2025-01-01'
AND sale_date < '2025-07-01';

EXPLAIN
SELECT *
FROM Sales
WHERE category = 'Electronics'
AND region = 'West';

EXPLAIN
SELECT region, SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

EXPLAIN
SELECT customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

-- QUERY 1: Composite index on region and status

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE region = 'North'
AND status = 'Completed';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q1_after_microseconds;

-- QUERY 2: SARGable date range

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE sale_date >= '2025-01-01'
AND sale_date < '2025-07-01';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q2_after_microseconds;

-- QUERY 3: Composite index on category and region

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE COUNT(*)
FROM Sales
WHERE category = 'Electronics'
AND region = 'West';

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q3_after_microseconds;

-- QUERY 4: Index-assisted grouping may be possible

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE region,
    SUM(quantity * unit_price) AS total_sales
FROM Sales
GROUP BY region;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q4_after_microseconds;

-- QUERY 5: Index on customer_id can help grouping

SET @start_time = NOW(6);

SELECT SQL_NO_CACHE customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM Sales
GROUP BY customer_id
HAVING SUM(quantity * unit_price) > 50000;

SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6))
AS q5_after_microseconds;

-- Additional optimization using YEAR() function

EXPLAIN
SELECT COUNT(*)
FROM Sales
WHERE YEAR(sale_date) = 2025;

-- Optimized form: range condition on sale_date

EXPLAIN
SELECT COUNT(*)
FROM Sales
WHERE sale_date >= '2025-01-01'
AND sale_date < '2026-01-01';

-- Display all indexes

SHOW INDEX FROM Sales;

-- Verify total records

SELECT COUNT(*) AS total_sales_records
FROM Sales;

-- Final sales summary

SELECT
    region,
    COUNT(*) AS number_of_sales,
    SUM(quantity * unit_price) AS revenue
FROM Sales
GROUP BY region
ORDER BY revenue DESC;

-- Final execution plan

EXPLAIN ANALYZE
SELECT *
FROM Sales
WHERE region = 'North'
AND status = 'Completed';
