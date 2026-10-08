# Experiment 3 — Employee Management Database

## Aim

To design and implement an **Employee–Department–Project database schema** and perform SQL queries using:

* Selection
* Projection
* Aggregate Functions
* GROUP BY
* HAVING
* CASE Expressions
* ORDER BY
* JOIN operations

## Database

The database used in this experiment is:

```sql
EmployeeManagement
```

## Database Schema

The database consists of four main tables:

### 1. Department

Stores information about departments.

| Column      | Data Type   | Constraint  |
| ----------- | ----------- | ----------- |
| `dept_id`   | INT         | PRIMARY KEY |
| `dept_name` | VARCHAR(50) | NOT NULL    |
| `location`  | VARCHAR(50) | —           |

### 2. Employee

Stores employee information and connects employees with departments.

| Column      | Data Type     | Constraint  |
| ----------- | ------------- | ----------- |
| `emp_id`    | INT           | PRIMARY KEY |
| `emp_name`  | VARCHAR(50)   | NOT NULL    |
| `gender`    | CHAR(1)       | —           |
| `salary`    | DECIMAL(10,2) | —           |
| `hire_date` | DATE          | —           |
| `dept_id`   | INT           | FOREIGN KEY |

### 3. Project

Stores project information and associates projects with departments.

| Column         | Data Type     | Constraint  |
| -------------- | ------------- | ----------- |
| `project_id`   | INT           | PRIMARY KEY |
| `project_name` | VARCHAR(100)  | NOT NULL    |
| `budget`       | DECIMAL(12,2) | —           |
| `dept_id`      | INT           | FOREIGN KEY |

### 4. Employee_Project

This is a relationship table connecting employees and projects.

| Column         | Data Type | Constraint  |
| -------------- | --------- | ----------- |
| `emp_id`       | INT       | FOREIGN KEY |
| `project_id`   | INT       | FOREIGN KEY |
| `hours_worked` | INT       | —           |

The combination of `emp_id` and `project_id` forms the **composite primary key**.

## Relationships

```text
Department
    |
    | 1 : N
    v
Employee
    |
    | N : M
    v
Employee_Project
    ^
    |
    | N : 1
    |
Project
    ^
    |
    | N : 1
    |
Department
```

* One department can have multiple employees.
* One department can have multiple projects.
* An employee can work on multiple projects.
* A project can have multiple employees.
* `Employee_Project` resolves the many-to-many relationship between employees and projects.

## Dataset

The database contains:

* **5 Departments**
* **30 Employees**
* **8 Projects**
* **30 Employee–Project assignments**

The departments are:

1. IT
2. HR
3. Finance
4. Marketing
5. Research

## SQL Operations Performed

### 1. Selection

Retrieves employees whose salary is greater than `80000`.

```sql
SELECT *
FROM Employee
WHERE salary > 80000;
```

### 2. Projection

Displays only employee names and salaries.

```sql
SELECT emp_name, salary
FROM Employee;
```

### 3. Aggregate Functions

The following aggregate functions are demonstrated:

* `COUNT()` — counts employees
* `SUM()` — calculates total salary
* `AVG()` — calculates average salary
* `MAX()` — finds the highest salary
* `MIN()` — finds the lowest salary

```sql
SELECT
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM Employee;
```

### 4. GROUP BY

Counts employees in each department.

```sql
SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id;
```

### 5. GROUP BY with JOIN

Calculates the average salary of employees in each department.

```sql
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
```

### 6. HAVING

Displays departments whose average employee salary is greater than `75000`.

```sql
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 75000;
```

### 7. CASE Expression

Categorizes employees according to their salary.

```sql
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 90000 THEN 'High Salary'
        WHEN salary >= 70000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;
```

Salary categories:

* `>= 90000` → High Salary
* `>= 70000` → Medium Salary
* Below `70000` → Low Salary

### 8. ORDER BY

Displays employees in descending order of salary.

```sql
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
ORDER BY salary DESC;
```

## Additional Queries

### Complete Employee–Department Report

```sql
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;
```

### Project Details

Displays projects along with their departments and budgets.

```sql
SELECT
    p.project_name,
    d.dept_name,
    p.budget
FROM Project p
JOIN Department d
    ON p.dept_id = d.dept_id
ORDER BY p.budget DESC;
```

### Employees Working on Projects

Displays employees, their assigned projects, and hours worked.

```sql
SELECT
    e.emp_name,
    p.project_name,
    ep.hours_worked
FROM Employee_Project ep
JOIN Employee e
    ON ep.emp_id = e.emp_id
JOIN Project p
    ON ep.project_id = p.project_id
ORDER BY ep.hours_worked DESC;
```

## Concepts Demonstrated

This experiment demonstrates the practical use of:

* Database creation
* Table creation
* Primary keys
* Foreign keys
* Composite primary keys
* Data insertion
* Selection using `WHERE`
* Projection using `SELECT`
* Aggregate functions
* `GROUP BY`
* `HAVING`
* `CASE`
* `ORDER BY`
* Inner joins
* Many-to-many relationships
* Relational database design

## Conclusion

The **EmployeeManagement** database was successfully designed and implemented using four related tables: `Department`, `Employee`, `Project`, and `Employee_Project`. Various SQL operations including selection, projection, aggregate functions, grouping, filtering with `HAVING`, conditional classification using `CASE`, sorting, and multiple-table joins were successfully demonstrated.
