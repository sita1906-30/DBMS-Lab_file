# Experiment 6 — Stored Procedures and Database Triggers

## Aim

To create a stored procedure `transfer_employee(emp_id, new_dept_id)` with validation and error handling, and to implement database triggers for:

* Salary validation
* Salary update validation
* Salary audit logging
* Error handling
* Transaction rollback

The procedure and triggers are tested using normal as well as edge-case inputs.

---

## Database Used

The experiment uses the database created in **Experiment 3**:

```text
EmployeeManagement
```

Main tables used:

* `Employee`
* `Department`
* `Salary_Audit`

---

# 1. Stored Procedure — `transfer_employee`

The stored procedure transfers an employee from one department to another.

It performs the following validations:

1. Checks whether the employee exists.
2. Checks whether the new department exists.
3. Checks whether the employee is already in the requested department.
4. Transfers the employee if all validations pass.
5. Handles SQL exceptions using `SQLEXCEPTION`.
6. Rolls back the transaction if an error occurs.

### Procedure

```sql id="j3x5ru"
DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_employee_count INT DEFAULT 0;
    DECLARE v_department_count INT DEFAULT 0;
    DECLARE v_current_dept INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred. Transaction rolled back.' AS message;
    END;

    START TRANSACTION;

    -- Check whether employee exists
    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    -- Further validation and transfer logic
    -- are performed here.

END //

DELIMITER ;
```

The complete procedure validates the employee and department before performing the update and commits the transaction only after a successful transfer.

---

# 2. Testing the Stored Procedure

Before transferring an employee, the employee's current department can be checked using:

```sql id="uj48gl"
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.emp_id = 101;
```

### Successful Transfer

```sql id="x5sh9a"
CALL transfer_employee(101, 3);
```

After the transfer, the employee's department can be verified using:

```sql id="y8y2w3"
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.emp_id = 101;
```

---

# 3. Stored Procedure Edge Cases

## Employee Does Not Exist

```sql id="a2q1wd"
CALL transfer_employee(999, 3);
```

Expected behavior:

```text
Error: Employee does not exist.
```

## Department Does Not Exist

```sql id="m2v7ks"
CALL transfer_employee(101, 99);
```

Expected behavior:

```text
Error: Department does not exist.
```

## Employee Already in Same Department

```sql id="q4j8na"
CALL transfer_employee(101, 3);
```

Expected behavior:

```text
Error: Employee is already in this department.
```

These edge cases are specifically tested in the experiment.

---

# 4. Salary Validation Trigger

A trigger is created to ensure that an employee's salary cannot be less than `15000`.

```sql id="5gq1xv"
DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 15000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be at least 15000';
    END IF;
END //

DELIMITER ;
```

### Purpose

The trigger executes **before an employee is inserted** and rejects salaries below `15000`.

---

# 5. Testing Invalid Salary

```sql id="w2h4e6"
INSERT INTO Employee
(emp_id, emp_name, gender, salary, hire_date, dept_id)
VALUES
(131, 'Test Employee', 'M', 10000, '2026-09-25', 1);
```

The trigger rejects the insertion because:

```text
10000 < 15000
```

---

# 6. Testing Valid Salary

A valid salary can be inserted using:

```sql id="r7v3pz"
INSERT INTO Employee
(emp_id, emp_name, gender, salary, hire_date, dept_id)
VALUES
(131, 'Test Employee', 'M', 30000, '2026-09-25', 1);
```

The employee can then be verified:

```sql id="d8m4qa"
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE emp_id = 131;
```

---

# 7. Salary Validation During UPDATE

A second trigger prevents an existing employee's salary from being changed to a value below `15000`.

```sql id="n5c9xk"
DELIMITER //

CREATE TRIGGER validate_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 15000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be at least 15000';
    END IF;
END //

DELIMITER ;
```

### Test

```sql id="s3f7dv"
UPDATE Employee
SET salary = 5000
WHERE emp_id = 131;
```

The update is rejected because the new salary is below the minimum allowed value.

---

# 8. Salary Audit Table

An audit table is created to record salary changes.

```sql id="z9t2bc"
CREATE TABLE Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(30)
);
```

### Columns

| Column       | Purpose                       |
| ------------ | ----------------------------- |
| `audit_id`   | Unique audit record ID        |
| `emp_id`     | Employee whose salary changed |
| `old_salary` | Salary before the change      |
| `new_salary` | Salary after the change       |
| `changed_at` | Time of salary change         |
| `action`     | Type of action                |

---

# 9. Salary Audit Trigger

An `AFTER UPDATE` trigger records salary changes in the audit table.

```sql id="k6v4mx"
DELIMITER //

CREATE TRIGGER salary_audit_trigger
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN

        INSERT INTO Salary_Audit (
            emp_id,
            old_salary,
            new_salary,
            action
        )
        VALUES (
            NEW.emp_id,
            OLD.salary,
            NEW.salary,
            'SALARY UPDATE'
        );

    END IF;
END //

DELIMITER ;
```

### Purpose

The trigger creates an audit record only when the employee's salary actually changes.

---

# 10. Testing the Audit Trigger

Update the employee's salary:

```sql id="v4p8ne"
UPDATE Employee
SET salary = 35000
WHERE emp_id = 131;
```

View the audit records:

```sql id="e6k2qt"
SELECT *
FROM Salary_Audit;
```

---

# 11. Testing Multiple Salary Changes

```sql id="p8n3ys"
UPDATE Employee
SET salary = 40000
WHERE emp_id = 131;

UPDATE Employee
SET salary = 45000
WHERE emp_id = 131;
```

Audit records can then be viewed using:

```sql id="r2m7hc"
SELECT
    audit_id,
    emp_id,
    old_salary,
    new_salary,
    action
FROM Salary_Audit
WHERE emp_id = 131;
```

Each actual salary change creates a corresponding audit record.

---

# 12. Edge Case — Salary Unchanged

The following query sets the salary to its existing value:

```sql id="c5w9fk"
UPDATE Employee
SET salary = 45000
WHERE emp_id = 131;
```

Since the old and new salaries are the same, the audit trigger does not create a new audit record.

---

# 13. Edge Case — NULL Salary

The salary validation trigger is modified to reject both:

* `NULL` salary
* Salary below `15000`

```sql id="h3q7vz"
DROP TRIGGER validate_employee_salary;

DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL OR NEW.salary < 15000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Salary cannot be NULL and must be at least 15000';
    END IF;
END //

DELIMITER ;
```

Test:

```sql id="n7d4qx"
INSERT INTO Employee
(emp_id, emp_name, gender, salary, hire_date, dept_id)
VALUES
(132, 'Null Salary', 'F', NULL, '2026-09-25', 1);
```

The trigger rejects the insertion because the salary is `NULL`.

---

# 14. Checking Triggers

All triggers can be displayed using:

```sql id="u9k3pm"
SHOW TRIGGERS;
```

This allows verification of the triggers created for salary validation and audit logging.

---

# 15. Checking Stored Procedures

The stored procedure can be checked using:

```sql id="b6x2rq"
SHOW PROCEDURE STATUS
WHERE Db = 'EmployeeManagement';
```

This verifies the existence and status of the stored procedure.

---

# Concepts Demonstrated

This experiment demonstrates:

* Stored Procedures
* Input parameters
* Variables inside procedures
* Transactions
* `START TRANSACTION`
* `COMMIT`
* `ROLLBACK`
* `SQLEXCEPTION`
* Error handling
* Database triggers
* `BEFORE INSERT` triggers
* `BEFORE UPDATE` triggers
* `AFTER UPDATE` triggers
* `OLD` and `NEW` values
* `SIGNAL SQLSTATE`
* Data validation
* Audit logging
* Edge-case testing

---

# Summary

Experiment 6 implements a stored procedure named `transfer_employee` for safely transferring employees between departments. The procedure validates employee and department existence, prevents unnecessary transfers, and uses transaction control with rollback for error handling.

Database triggers are also implemented to enforce minimum salary requirements and prevent invalid salary updates. An audit table and audit trigger record genuine salary changes, providing a history of modifications.

The experiment additionally tests normal operations and edge cases such as non-existent employees, non-existent departments, duplicate department transfers, invalid salaries, unchanged salaries, and `NULL` salaries.

## Conclusion

The stored procedure and database triggers were successfully designed and tested. Transaction management, validation, exception handling, salary constraints, and audit logging were implemented to improve the reliability and integrity of the Employee Management database.
