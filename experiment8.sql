
-- EXPERIMENT 8: TRANSACTIONS AND CONCURRENCY CONTROL

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    CHECK (balance >= 0)
) ENGINE = InnoDB;

INSERT INTO Accounts VALUES
(101, 'Aarav', 10000.00),
(102, 'Diya', 5000.00),
(103, 'Kabir', 8000.00);

SELECT * FROM Accounts;

-- Successful Transaction using COMMIT

START TRANSACTION;

UPDATE Accounts
SET balance = balance - 2000
WHERE account_id = 101
AND balance >= 2000;

UPDATE Accounts
SET balance = balance + 2000
WHERE account_id = 102;

COMMIT;

SELECT * FROM Accounts;

-- Transaction using ROLLBACK

START TRANSACTION;

UPDATE Accounts
SET balance = balance - 1000
WHERE account_id = 101;

UPDATE Accounts
SET balance = balance + 1000
WHERE account_id = 103;

ROLLBACK;

-- Balances remain unchanged from before Part C

SELECT * FROM Accounts;

-- Transaction using SAVEPOINT

START TRANSACTION;

-- Successful transfer of Rs. 500

UPDATE Accounts
SET balance = balance - 500
WHERE account_id = 101
AND balance >= 500;

UPDATE Accounts
SET balance = balance + 500
WHERE account_id = 102;

SAVEPOINT after_first_transfer;

UPDATE Accounts
SET balance = balance - 20000
WHERE account_id = 101
AND balance >= 20000;

ROLLBACK TO SAVEPOINT after_first_transfer;

COMMIT;

SELECT * FROM Accounts;

-- 1. READ UNCOMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 2. READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 3. REPEATABLE READ (MySQL InnoDB default)

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 4. SERIALIZABLE

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- TEST 1: DIRTY READ

-- SESSION 1:

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

UPDATE Accounts
SET balance = 3000
WHERE account_id = 101;

-- Do NOT commit yet.

-- SESSION 2:

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT balance
FROM Accounts
WHERE account_id = 101;

-- Session 2 may see the uncommitted value 3000.

-- SESSION 1:

ROLLBACK;

-- SESSION 2:

ROLLBACK;

-- TEST 2: NON-REPEATABLE READ

-- SESSION 1:

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT balance
FROM Accounts
WHERE account_id = 102;

-- Keep the transaction open.

-- SESSION 2:

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

UPDATE Accounts
SET balance = balance + 100
WHERE account_id = 102;

COMMIT;

-- SESSION 1:

SELECT balance
FROM Accounts
WHERE account_id = 102;

-- The value may differ from the first read.

COMMIT;

-- TEST 3: REPEATABLE READ PREVENTS NON-REPEATABLE READ

-- SESSION 1:

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT balance
FROM Accounts
WHERE account_id = 103;

-- Keep the transaction open.

-- SESSION 2:

UPDATE Accounts
SET balance = balance + 200
WHERE account_id = 103;

COMMIT;

-- SESSION 1:

SELECT balance
FROM Accounts
WHERE account_id = 103;

-- Ordinary consistent reads see the same snapshot.

COMMIT;

-- TEST 4: LOST UPDATE FROM STALE APPLICATION DATA

-- SESSION 1:

START TRANSACTION;

SELECT balance
FROM Accounts
WHERE account_id = 102;

-- Assume the application reads 7500.
-- Keep the transaction open.

-- SESSION 2:

START TRANSACTION;

UPDATE Accounts
SET balance = balance + 300
WHERE account_id = 102;

COMMIT;

-- SESSION 1:

UPDATE Accounts
SET balance = 7500 - 100
WHERE account_id = 102;

COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT
    account_id,
    account_holder,
    balance
FROM Accounts
ORDER BY account_id;
