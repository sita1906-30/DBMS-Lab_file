# Experiment 5 — SQL Views and Recursive CTE

## Aim

To create and manipulate SQL views for:

* Department salary summary
* Employee hierarchy

To test the **updatability of views** and implement a **recursive CTE** to display employee reporting chains.

---

## Database Used

The experiment uses the database created in **Experiment 3**:

```text
EmployeeManagement
```

Main tables used:

* `Employee`
* `Department`
* `Project`
* `Employee_Project`

---

# 1. Department Salary Summary View

A view named `Department_Salary_Summary` is created to display salary-related statistics for each department.

```sql
CREATE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
```

The view can be queried using:

```sql
SELECT *
FROM Department_Salary_Summary;
```

### Information Provided

The view provides:

* Department ID
* Department name
* Total number of employees
* Total salary
* Average salary
* Highest salary
* Lowest salary

---

# 2. Querying the View

The created view can be filtered like a normal table.

The following query finds departments having an average salary greater than ₹75,000:

```sql
SELECT
    dept_name,
    average_salary
FROM Department_Salary_Summary
WHERE average_salary > 75000;
```

---

# 3. Employee Hierarchy

A manager relationship is added to the `Employee` table using a self-referencing foreign key.

## Add Manager ID

```sql
ALTER TABLE Employee
ADD manager_id INT NULL;
```

A foreign key constraint is then created:

```sql
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id)
REFERENCES Employee(emp_id);
```

### Purpose

The `manager_id` column stores the employee ID of an employee's manager.

Because `manager_id` references `Employee(emp_id)`, the table has a **self-referencing relationship**.

---

# 4. Employee Hierarchy Data

Manager IDs are assigned to employees to create the organizational hierarchy.

For example:

```sql
UPDATE Employee
SET manager_id = 105
WHERE emp_id IN (103, 104);
```

Employees `103` and `104` report to employee `105`.

Another level is created using:

```sql
UPDATE Employee
SET manager_id = 103
WHERE emp_id IN (101, 102);
```

This creates a reporting chain where employees `101` and `102` report to employee `103`.

The experiment similarly establishes reporting relationships for the Finance, Marketing, and Research sections.

---

# 5. Employee Hierarchy View

A view named `Employee_Hierarchy` is created to display employees together with their managers.

```sql
CREATE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.salary,
    e.dept_id
FROM Employee e
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;
```

The view can be displayed using:

```sql
SELECT *
FROM Employee_Hierarchy;
```

### Information Provided

The view displays:

* Employee ID
* Employee name
* Manager ID
* Manager name
* Salary
* Department ID

---

# 6. Testing Updatability of a Single View

A simple view named `Employee_Basic` is created.

```sql
CREATE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;
```

The view can be queried for a particular employee:

```sql
SELECT *
FROM Employee_Basic
WHERE emp_id = 101;
```

---

# 7. Updating Through the View

The experiment tests whether changes made through the view are reflected in the underlying table.

```sql
UPDATE Employee_Basic
SET salary = 78000
WHERE emp_id = 101;
```

The underlying `Employee` table is then checked:

```sql
SELECT *
FROM Employee
WHERE emp_id = 101;
```

This demonstrates the updatability of the simple `Employee_Basic` view.

---

# 8. Testing Non-Updatability of Department Salary View

The experiment attempts to update the aggregate view:

```sql
UPDATE Department_Salary_Summary
SET average_salary = 80000
WHERE dept_id = 1;
```

The view contains aggregate functions such as:

* `COUNT()`
* `SUM()`
* `AVG()`
* `MAX()`
* `MIN()`

Therefore, the experiment demonstrates the limitation of updating an aggregate-based view.

---

# 9. Recursive CTE

A **Recursive Common Table Expression (CTE)** is used to display the complete employee reporting hierarchy.

```sql
WITH RECURSIVE EmployeeChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS CHAR(500)) AS reporting_chain
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1,
        CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
    FROM Employee e
    INNER JOIN EmployeeChain ec
        ON e.manager_id = ec.emp_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_chain
FROM EmployeeChain
ORDER BY reporting_chain;
```

## How It Works

The recursive CTE consists of two parts:

### Anchor Member

```sql
SELECT
    emp_id,
    emp_name,
    manager_id,
    0 AS level,
    CAST(emp_name AS CHAR(500)) AS reporting_chain
FROM Employee
WHERE manager_id IS NULL
```

It identifies employees at the top of the hierarchy who do not have a manager.

### Recursive Member

```sql
SELECT
    e.emp_id,
    e.emp_name,
    e.manager_id,
    ec.level + 1,
    CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
FROM Employee e
INNER JOIN EmployeeChain ec
    ON e.manager_id = ec.emp_id
```

It repeatedly finds employees who report to the employees already found in the hierarchy.

The `level` increases by one at each stage, while `reporting_chain` builds the complete reporting path.

---

# 10. Recursive CTE for One Employee

A second recursive CTE is used to trace the reporting relationship for employee `101`.

```sql
WITH RECURSIVE ReportingChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE emp_id = 101

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1
    FROM Employee e
    JOIN ReportingChain rc
        ON e.emp_id = rc.manager_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM ReportingChain;
```

### Purpose

This query follows the `manager_id` relationship upward from employee `101` to their manager and continues until the top of the reporting chain is reached.

---

# Concepts Demonstrated

This experiment demonstrates:

* SQL Views
* Creating views using `CREATE VIEW`
* Querying views
* Aggregate functions inside views
* Filtering views
* Self-referencing foreign keys
* Employee-manager relationships
* Self JOIN
* Updatable views
* Non-updatable aggregate views
* Recursive Common Table Expressions
* Anchor members
* Recursive members
* Reporting hierarchies
* Recursive employee chains

---

# Key SQL Commands

| Command          | Purpose                                    |
| ---------------- | ------------------------------------------ |
| `CREATE VIEW`    | Creates a virtual table based on a query   |
| `SELECT`         | Retrieves data from tables or views        |
| `ALTER TABLE`    | Modifies an existing table                 |
| `ADD CONSTRAINT` | Adds a database constraint                 |
| `UPDATE`         | Modifies existing records                  |
| `WITH RECURSIVE` | Creates a recursive CTE                    |
| `UNION ALL`      | Combines anchor and recursive results      |
| `LEFT JOIN`      | Includes matching and non-matching records |

---

# Conclusion

The experiment successfully demonstrates the creation and manipulation of SQL views, including a department salary summary and an employee hierarchy view. The updatability of a simple view is tested, while the limitations of an aggregate-based view are also demonstrated.

A recursive CTE is implemented to generate employee reporting chains and trace hierarchical relationships within the Employee database.
