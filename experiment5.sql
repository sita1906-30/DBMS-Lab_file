DATABASE CREATING
CREATE DATABASE EmployeeManagement; USE EmployeeManagement;

TABLE CREATING
-- Department Table
CREATE TABLE Department ( dept_id INT PRIMARY KEY,
dept_name VARCHAR(50) NOT NULL, location VARCHAR(50)
);
-- Employee Table
CREATE TABLE Employee ( emp_id INT PRIMARY KEY,
emp_name VARCHAR(50) NOT NULL,
gender CHAR(1), salary DECIMAL(10,2), hire_date DATE, dept_id INT,
FOREIGN KEY (dept_id)
REFERENCES Department(dept_id)
);
-- Project Table
CREATE TABLE Project ( project_id INT PRIMARY KEY,
project_name VARCHAR(100) NOT NULL, budget DECIMAL(12,2),
dept_id INT,
FOREIGN KEY (dept_id)
REFERENCES Department(dept_id)
) 
--Employee-Project Relationship
CREATE TABLE Employee_Project ( emp_id INT,
project_id INT, hours_worked INT,

PRIMARY KEY (emp_id, project_id),

FOREIGN KEY (emp_id)
REFERENCES Employee(emp_id),

FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

--INSERTING DEPARTMENTS
INSERT INTO Department (dept_id, dept_name, location) VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Research', 'Hyderabad');

--INSERTING 30 EMPLOYEES
INSERT INTO Employee
(emp_id, emp_name, gender, salary, hire_date, dept_id) VALUES
(101,	'Aarav Sharma', 'M', 75000, '2021-01-15', 1),
(102,	'Ananya Singh', 'F', 68000, '2022-03-10', 1),
(103,	'Rohan Verma', 'M', 82000, '2020-07-20', 1),
(104,	'Priya Gupta', 'F', 72000, '2021-11-05', 1),
(105,	'Karan Mehta', 'M', 95000, '2019-06-18', 1),
(106,	'Sneha Kapoor', 'F', 64000, '2023-01-12', 1),
(107,	'Rahul Kumar', 'M', 55000, '2022-05-15', 2),
(108,	'Neha Sharma', 'F', 62000, '2021-09-22', 2),
(109,	'Amit Jain', 'M', 58000, '2020-04-11', 2),
(110,	'Pooja Verma', 'F', 67000, '2023-02-19', 2),
(111,	'Vikas Singh', 'M', 60000, '2022-08-01', 2),
(112,	'Riya Agarwal', 'F', 71000, '2019-12-10', 2),
(113,	'Arjun Patel', 'M', 88000, '2020-01-25', 3),
(114,	'Meera Shah', 'F', 92000, '2019-08-14', 3),
(115,	'Suresh Rao', 'M', 76000, '2021-06-30', 3),
(116,	'Kavya Iyer', 'F', 85000, '2022-10-17', 3),
(117,	'Manish Gupta', 'M', 73000, '2023-03-21', 3),
 
(118,	'Nisha Reddy', 'F', 90000, '2020-11-09', 3),
(119,	'Aditya Joshi', 'M', 70000, '2021-02-28', 4),
(120,	'Simran Kaur', 'F', 66000, '2022-04-15', 4),
(121,	'Mohit Bansal', 'M', 74000, '2020-09-12', 4),
(122,	'Isha Malhotra', 'F', 81000, '2019-07-07', 4),
(123,	'Nikhil Sethi', 'M', 69000, '2023-01-05', 4),
(124,	'Tanya Arora', 'F', 77000, '2021-12-18', 4),
(125,	'Dev Malhotra', 'M', 98000, '2018-05-20', 5),
(126,	'Aditi Mishra', 'F', 91000, '2020-03-16', 5),
(127,	'Varun Nair', 'M', 87000, '2021-10-08', 5),
(128,	'Shreya Das', 'F', 93000, '2019-11-25', 5),
(129,	'Yash Thakur', 'M', 79000, '2022-07-14', 5),
(130,	'Diya Kapoor', 'F', 96000, '2023-02-02', 5);

--INSERTING 8 PROJECTS
INSERT INTO Project
(project_id, project_name, budget, dept_id) VALUES
(201, 'AI Chatbot', 500000, 1),
(202, 'Cloud Migration', 750000, 1),
(203, 'Employee Training', 250000, 2),
(204, 'Financial Analysis', 600000, 3),
(205, 'Digital Marketing', 450000, 4),
(206, 'Market Research', 350000, 4),
(207, 'Machine Learning Research', 900000, 5),
(208, 'AI Security System', 1000000, 5);

--ASSIGNING EMPLOYEES TO PROJECTS
INSERT INTO Employee_Project (emp_id, project_id, hours_worked) VALUES
(101,	201,	120),
(102,	201,	100),
(103,	202,	150),
(104,	202,	110),
(105,	201,	130),
(106,	202,	90),
(107,	203,	100),
(108,	203,	120),
(109,	203,	80),
(110,	203,	110),
(111,	203,	90),
(112,	203,	130),
(113,	204,	140),
(114,	204,	150),
(115,	204,	120),
(116,	204,	135),
 
(117,	204,	100),
(118,	204,	145),
(119,	205,	110),
(120,	205,	100),
(121,	206,	120),
(122,	205,	140),
(123,	206,	90),
(124,	206,	130),
(125,	207,	160),
(126,	207,	140),
(127,	208,	150),
(128,	208,	160),
(129,	207,	120),
(130,	208,	135);

--DEPARTMENT SALARY SUMMARY VIEW
CREATE VIEW Department_Salary_Summary AS SELECT
d.dept_id, d.dept_name,
COUNT(e.emp_id) AS total_employees, SUM(e.salary) AS total_salary, AVG(e.salary) AS average_salary, MAX(e.salary) AS highest_salary, MIN(e.salary) AS lowest_salary
FROM Department d LEFT JOIN Employee e
ON d.dept_id = e.dept_id GROUP BY d.dept_id, d.dept_name;
SELECT *
FROM Department_Salary_Summary;

--Find departments with an average salary greater than ₹75,000 SELECT
dept_name, average_salary
FROM Department_Salary_Summary WHERE average_salary > 75000;

--EMPLOYEE HIERARCHY
ALTER TABLE Employee
ADD manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);


INSERT EMPLOYEE HIERARCHY
-- Update Manager IDs
UPDATE Employee SET manager_id = NULL WHERE emp_id IN (105, 112, 114, 122, 125);

-- IT
UPDATE Employee
SET manager_id = 105
WHERE emp_id IN (103, 104);

UPDATE Employee
SET manager_id = 103
WHERE emp_id IN (101, 102);

UPDATE Employee
SET manager_id = 104

WHERE emp_id = 106;

-- HR
UPDATE Employee
SET manager_id = 105
WHERE emp_id IN (103, 104);

UPDATE Employee
SET manager_id = 103
WHERE emp_id IN (101, 102);

UPDATE Employee
SET manager_id = 104 WHERE emp_id = 106;
 
-- Finance UPDATE Employee
SET manager_id = 112
WHERE emp_id IN (107, 108);

UPDATE Employee
SET manager_id = 107 WHERE emp_id = 109;

UPDATE Employee
SET manager_id = 108
WHERE emp_id IN (110, 111);

-- Marketing
UPDATE Employee
SET manager_id = 112
WHERE emp_id IN (107, 108);

UPDATE Employee
SET manager_id = 107 WHERE emp_id = 109;

UPDATE Employee
SET manager_id = 108
WHERE emp_id IN (110, 111);
-- Research UPDATE Employee
SET manager_id = 125
WHERE emp_id IN (126, 127, 128);

UPDATE Employee
SET manager_id = 126

WHERE emp_id = 129;

UPDATE Employee
SET manager_id = 128 WHERE emp_id = 130;


--EMPLOYEE HIERARCHY VIEW
CREATE VIEW Employee_Hierarchy AS SELECT
e.emp_id,
e.emp_name AS employee_name, e.manager_id,
m.emp_name AS manager_name, e.salary,
e.dept_id FROM Employee e
LEFT JOIN Employee m
ON e.manager_id = m.emp_id;

SELECT *
FROM Employee_Hierarchy;

--TEST UPDATABILITY OF A SINGLE VIEW
CREATE VIEW Employee_Basic AS SELECT
emp_id, emp_name, salary, dept_id
FROM Employee;

SELECT *
FROM Employee_Basic WHERE emp_id = 101;

--UPDATE THROUGH THE VIEW
UPDATE Employee_Basic SET salary = 78000 WHERE emp_id = 101;

SELECT *
FROM Employee WHERE emp_id = 101;
OUTPUT:

--TEST NON-UPDATABILITY OF DEPARTMENT SALARY VIEW
UPDATE Department_Salary_Summary SET average_salary = 80000 WHERE dept_id = 1;

--RECURSIVE CTE
WITH RECURSIVE EmployeeChain AS (
-- Anchor member SELECT
emp_id, emp_name, manager_id,
0 AS level,
CAST(emp_name AS CHAR(500)) AS reporting_chain FROM Employee
WHERE manager_id IS NULL UNION ALL
-- Recursive member SELECT
e.emp_id, e.emp_name, e.manager_id, ec.level + 1,
CONCAT(ec.reporting_chain, ' -> ', e.emp_name) FROM Employee e
INNER JOIN EmployeeChain ec
ON e.manager_id = ec.emp_id
)
SELECT
emp_id, emp_name, manager_id, level, reporting_chain
FROM EmployeeChain
ORDER BY reporting_chain;


--RECURSIVE CTE FOR ONE EMPLOYEE
WITH RECURSIVE ReportingChain AS (
SELECT
emp_id, emp_name, manager_id,
0 AS level FROM Employee WHERE emp_id = 101
UNION ALL

SELECT
e.emp_id, e.emp_name, e.manager_id, rc.level + 1
FROM Employee e
JOIN ReportingChain rc
ON e.emp_id = rc.manager_id
)

SELECT
emp_id, emp_name,
manager_id, level
FROM ReportingChain;
