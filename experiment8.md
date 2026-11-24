# EXPERIMENT – 8

## AIM
To implement banking-style transactions using `BEGIN`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`. To simulate partial failures and demonstrate transaction isolation levels and concurrency anomalies using two sessions.

## EXECUTION RESULTS

### 1. Initial Account Table

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Aarav | 10000.00 |
| 102 | Diya | 5000.00 |
| 103 | Kabir | 8000.00 |

### 2. Successful Transaction (COMMIT)

A transaction transfers ₹2,000 from Account 101 to Account 102. The transaction is committed successfully.

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Aarav | 8000.00 |
| 102 | Diya | 7000.00 |
| 103 | Kabir | 8000.00 |

**Result:** The transaction was successfully committed and the balances were updated.

### 3. Transaction Rollback

A transaction attempts to transfer ₹1,000 from Account 101 to Account 103. The transaction is rolled back.

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Aarav | 8000.00 |
| 102 | Diya | 7000.00 |
| 103 | Kabir | 8000.00 |

**Result:** The changes were undone using `ROLLBACK`. Account balances remained unchanged.

### 4. SAVEPOINT and Partial Rollback

A successful transfer of ₹500 is performed from Account 101 to Account 102. A SAVEPOINT is created. A subsequent transfer of ₹20,000 is attempted, but the balance condition is not satisfied. The transaction is rolled back to the savepoint and committed.

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Aarav | 7500.00 |
| 102 | Diya | 7500.00 |
| 103 | Kabir | 8000.00 |

**Result:** The valid ₹500 transfer was retained, while the unsuccessful operation was discarded.

### 5. Transaction Isolation Levels

The following isolation levels were executed:

| Isolation Level | Result |
|---|---|
| READ UNCOMMITTED | Allows reading uncommitted changes |
| READ COMMITTED | Reads only committed data |
| REPEATABLE READ | Maintains a consistent snapshot during the transaction |
| SERIALIZABLE | Provides the strictest transaction isolation |

### 6. Dirty Read Test

Session 1 updates Account 101's balance to ₹3,000 without committing.

Session 2, operating at READ UNCOMMITTED isolation level, may read the uncommitted value.

**Sample Output:**

| Balance |
|---:|
| 3000.00 |

After Session 1 executes `ROLLBACK`, the balance returns to its previous committed value.

**Result:** Dirty read was demonstrated using READ UNCOMMITTED.

### 7. Non-Repeatable Read Test

Session 1 reads Account 102's balance. Session 2 increases the balance by ₹100 and commits. Session 1 reads the balance again.

**Sample Output:**

| First Read | Second Read |
|---:|---:|
| 7500.00 | 7600.00 |

**Result:** The value changed between two reads in the same transaction under READ COMMITTED isolation.

### 8. REPEATABLE READ Test

Session 1 reads Account 103's balance. Session 2 increases the balance by ₹200 and commits.

**Sample Output:**

| First Read (Session 1) | Second Read (Session 1) |
|---:|---:|
| 8000.00 | 8000.00 |

**Result:** REPEATABLE READ maintains the same snapshot for ordinary consistent reads within the transaction.

### 9. Lost Update Test

Two sessions modify Account 102 using stale application data. Session 2 increases the balance by ₹300, but Session 1 subsequently overwrites the balance using an older value.

**Result:** The update made by Session 2 is lost because Session 1 overwrites it.

### 10. Final Account Table

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Aarav | 7500.00 |
| 102 | Diya | 7400.00 |
| 103 | Kabir | 8200.00 |

## CONCLUSION

The experiment successfully demonstrated transaction management using COMMIT, ROLLBACK, and SAVEPOINT. Different isolation levels were tested, and concurrency anomalies such as dirty reads, non-repeatable reads, and lost updates were illustrated using multiple sessions.
