-- =================================================================================
-- Database Script: Enterprise Employee Analytics & Automation Framework
-- Purpose: Comprehensive reference kit covering advanced SQL querying, Window 
--          Functions, Subqueries, UDFs, Stored Procedures, and Audit Triggers.
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE & SCHEMA DESIGN
-- ---------------------------------------------------------------------------------
CREATE DATABASE EmployeesDb;
GO

USE EmployeesDb;
GO

-- Master Workforce Ledger Table
CREATE TABLE employees (
    emp_id INT IDENTITY(101,1) PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    job_title VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2) DEFAULT 30000.00,
    hire_date DATE NOT NULL DEFAULT CONVERT(DATE, GETDATE()),
    city VARCHAR(50)
);

-- Separate Schema: Self-Referencing Company Hierarchy
CREATE TABLE CompanyHierarchy (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ManagerID INT NULL
);

-- Separate Schema: Data Change Capture Audit Trail Table
CREATE TABLE SALARY_AUDIT (
    AUDIT_ID INT IDENTITY PRIMARY KEY,
    EMPID INT NOT NULL,
    OLD_SALARY DECIMAL(10,2),
    NEW_SALARY DECIMAL(10,2),
    CHANGEDATE DATETIME DEFAULT GETDATE()
);
GO

-- Inspect target metadata schema setup
EXEC sp_help 'employees';
GO


-- ---------------------------------------------------------------------------------
-- 2. DATA POPULATION (SEED DATA)
-- ---------------------------------------------------------------------------------

INSERT INTO employees (fname, lname, email, job_title, department, salary, hire_date, city)
VALUES
    ('Aarav', 'Sharma', 'aarav.sharma@example.com', 'Director', 'Management', 180000, '2019-02-10', 'Mumbai'),
    ('Diya', 'Patel', 'diya.patel@example.com', 'Lead Engineer', 'Tech', 120000, '2020-08-15', 'Bengaluru'),
    ('Rohan', 'Mehra', 'rohan.mehra@example.com', 'Software Engineer', 'Tech', 85000, '2022-05-20', 'Bengaluru'),
    ('Priya', 'Singh', 'priya.singh@example.com', 'HR Manager', 'Human Resources', 95000, '2019-11-05', 'Mumbai'),
    ('Arjun', 'Kumar', 'arjun.kumar@example.com', 'Data Scientist', 'Tech', 110000, '2021-07-12', 'Hyderabad'),
    ('Ananya', 'Gupta', 'ananya.gupta@example.com', 'Marketing Lead', 'Marketing', 90000, '2020-03-01', 'Delhi'),
    ('Vikram', 'Reddy', 'vikram.reddy@example.com', 'Sales Executive', 'Sales', 75000, '2023-01-30', 'Mumbai'),
    ('Sameera', 'Rao', 'sameera.rao@example.com', 'Software Engineer', 'Tech', 88000, '2023-06-25', 'Pune'),
    ('Ishaan', 'Verma', 'ishaan.verma@example.com', 'Recruiter', 'Human Resources', 65000, '2022-09-01', 'Mumbai'),
    ('Kavya', 'Joshi', 'kavya.joshi@example.com', 'Product Designer', 'Design', 92000, '2021-04-18', 'Bengaluru'),
    ('Zain', 'Khan', 'zain.khan@example.com', 'Sales Manager', 'Sales', 115000, '2019-09-14', 'Delhi'),
    ('Nisha', 'Desai', 'nisha.desai@example.com', 'Jr. Data Analyst', 'Tech', 70000, '2024-02-01', 'Hyderabad'),
    ('Aditya', 'Nair', 'aditya.nair@example.com', 'Marketing Analyst', 'Marketing', 68000, '2022-10-10', 'Delhi'),
    ('Fatima', 'Ali', 'fatima.ali@example.com', 'Sales Executive', 'Sales', 78000, '2022-11-22', 'Mumbai'),
    ('Kabir', 'Shah', 'kabir.shah@example.com', 'DevOps Engineer', 'Tech', 105000, '2020-12-01', 'Pune');

INSERT INTO CompanyHierarchy (EmployeeID, Name, ManagerID)
VALUES
    (1, 'Sonia Verma', NULL), 
    (2, 'Rohan Gupta', 1),   
    (3, 'Amit Sharma', 2),   
    (4, 'Priya Singh', 1),   
    (5, 'Kabir Shah', 2);
GO


-- ---------------------------------------------------------------------------------
-- 3. CORE QUERY PATTERNS, OPERATORS & CONDITIONAL LOGIC
-- ---------------------------------------------------------------------------------

-- Filtering & Distinct Extractions
SELECT * FROM employees WHERE NOT department = 'Sales';
SELECT * FROM employees WHERE salary > 100000;
SELECT * FROM employees WHERE hire_date > '2020-12-31';
SELECT DISTINCT city FROM employees;

-- Sorting (ORDER BY Variances)
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY department ASC, lname DESC;

-- Advanced Wildcard Patterns (LIKE Expressions)
SELECT * FROM employees WHERE lname LIKE '%A';          -- Trailing letter evaluation
SELECT * FROM employees WHERE email LIKE '%gupta%';     -- Substring containment evaluation
SELECT * FROM employees WHERE fname LIKE '[^A]%' ;      -- Does NOT start with 'A'
SELECT * FROM employees WHERE fname LIKE '__A%';        -- Contains 'A' at the 3rd index slot
SELECT * FROM employees WHERE lname LIKE '____';        -- Exactly 4 characters long

-- Range Boundaries & Inclusions
SELECT TOP 3 * FROM employees ORDER BY salary DESC;
SELECT * FROM employees WHERE department IN ('Marketing', 'Sales', 'Tech');
SELECT * FROM employees WHERE salary BETWEEN 75000 AND 100000;

-- Conditional Row Transformations (CASE Statement Expressions)
SELECT fname, lname, salary,
    CASE   
        WHEN salary > 100000 THEN 'High Earner'
        WHEN salary BETWEEN 80000 AND 100000 THEN 'Medium Earner'
        ELSE 'Standard Earner'
    END AS Salary_category
FROM employees;

SELECT fname, lname, department, salary,
    CASE 
        WHEN department IN ('Sales', 'Marketing') THEN (salary * 0.10)
        WHEN department = 'Tech' THEN (salary * 0.12)
        ELSE (salary * 0.05)
    END AS bonus_amt
FROM employees;
GO


-- ---------------------------------------------------------------------------------
-- 4. AGGREGATIONS, DATA GROUPING & CORRELATED SUBQUERIES
-- ---------------------------------------------------------------------------------

-- Aggregated Group Summary Blocks
SELECT department, COUNT(emp_id) AS total_emp FROM employees GROUP BY department;
SELECT department, city, COUNT(emp_id) AS count FROM employees GROUP BY department, city;

-- Filtering Aggregated Sets (HAVING Patterns)
SELECT department, COUNT(emp_id) AS count FROM employees GROUP BY department HAVING COUNT(emp_id) > 2;
SELECT job_title, AVG(salary) AS avg_salary FROM employees GROUP BY job_title HAVING AVG(salary) > 90000;

-- Rollup Extensions for Total Multi-Level Summaries
SELECT department, city, COUNT(emp_id) AS total_emp
FROM employees
GROUP BY ROLLUP (department, city)
ORDER BY department;

-- Uncorrelated and Correlated Subqueries
SELECT emp_id, fname, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

SELECT * FROM employees e1
WHERE salary = (
    SELECT MAX(salary) FROM employees e2 
    WHERE e2.department = e1.department
);
GO


-- ---------------------------------------------------------------------------------
-- 5. SCALAR FUNCTIONS & RECURSIVE HIERARCHIES (SELF JOINS)
-- ---------------------------------------------------------------------------------

-- String Structuring Expressions
SELECT CONCAT(fname, ' ', lname) AS Full_Name FROM employees;
SELECT CONCAT_WS(':', emp_id, fname, UPPER(department), salary) AS FormattedStaffRecord FROM employees;
SELECT CONCAT(LEFT(department, 1), emp_id) AS SystemUID, fname FROM employees;

-- Self-Join Pattern: Unpacking Organizational Hierarchies
SELECT 
    e.Name AS Employee_Name, 
    COALESCE(m.Name, 'Top-Level Executive (CEO)') AS Manager_Name
FROM CompanyHierarchy e
LEFT JOIN CompanyHierarchy m ON e.ManagerID = m.EmployeeID;
GO


-- ---------------------------------------------------------------------------------
-- 6. ADVANCED WINDOWING CALCULATIONS
-- ---------------------------------------------------------------------------------

-- Ratio-to-Report Calculations using Global Overviews
SELECT fname, salary,
    SUM(salary) OVER() AS total_Sal,
    CAST(salary * 100.0 / SUM(salary) OVER() AS DECIMAL(10,2)) AS salary_percentage_share
FROM employees;

-- Running/Partitioned Summaries across Business Sectors
SELECT fname, department, salary,
    SUM(salary) OVER(PARTITION BY department) AS department_total_budget
FROM employees;
GO


-- ---------------------------------------------------------------------------------
-- 7. PROGRAMMABILITY: STORED PROCEDURES (CRUD & CONTROL FLOW LOGIC)
-- ---------------------------------------------------------------------------------

-- Simple Dynamic Fetch Execution Procedure
CREATE OR ALTER PROCEDURE get_emp_by_dept_sp
    @p_department VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT emp_id, fname, lname, department, hire_date, city
    FROM employees WHERE department = @p_department;
END;
GO

-- Transaction Processing Procedure: Insert with Constraints Validation
CREATE OR ALTER PROCEDURE insert_sp
    @p_fname VARCHAR(50),
    @p_lname VARCHAR(50),
    @p_email VARCHAR(100),
    @p_job_title VARCHAR(50),
    @p_department VARCHAR(50),
    @p_salary DECIMAL(10,2),
    @p_city VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM employees WHERE email = @p_email)
    BEGIN
        RAISERROR('Record processing blocked: Target email already registered.', 16, 1);
        RETURN;
    END
    INSERT INTO employees (fname, lname, email, job_title, department, salary, city)
    VALUES (@p_fname, @p_lname, @p_email, @p_job_title, @p_department, @p_salary, @p_city);
END;
GO

-- Complex Procedure: Evaluation Guard-Rails with OUTPUT Variable Logic
CREATE OR ALTER PROCEDURE update_salary_sp
    @p_empID INT,
    @p_newSalary DECIMAL(10,2),
    @p_message VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS(SELECT 1 FROM employees WHERE emp_id = @p_empID)
    BEGIN
        SET @p_message = 'ERROR: Employee record ID does not exist.';
        RETURN;
    END

    DECLARE @current_Sal DECIMAL(10,2);
    SELECT @current_Sal = salary FROM employees WHERE emp_id = @p_empID;

    IF @p_newSalary > @current_Sal
    BEGIN 
        UPDATE employees SET salary = @p_newSalary WHERE emp_id = @p_empID;
        SET @p_message = 'SUCCESS: Employee transactional salary profile updated.';
    END
    ELSE
    BEGIN 
        SET @p_message = 'ERROR: Operational target constraint failure. New salary figure must exceed historical baseline.';
    END
END;
GO

-- Example: Execute Stored Procedure with Output Validation Intercepts
DECLARE @ResponseLog VARCHAR(200);
EXEC update_salary_sp @p_empID = 103, @p_newSalary = 95000.00, @p_message = @ResponseLog OUTPUT;
SELECT @ResponseLog AS ExecutionStatusMessage;
GO


-- ---------------------------------------------------------------------------------
-- 8. EXTENSIONS: USER-DEFINED FUNCTIONS (UDFs)
-- ---------------------------------------------------------------------------------

-- Scalar Function Definition
CREATE OR ALTER FUNCTION dbo.Double_number(@num DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (@num * 2);
END;
GO

SELECT dbo.Double_number(250.50) AS ComputedScalarResult;
GO

-- Inline Table-Valued Function (ITVF): Fetching Department Outliers
CREATE OR ALTER FUNCTION dbo.DEPT_MAX_EMP(@p_dept VARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT emp_id, fname, lname, department, salary 
    FROM employees 
    WHERE department = @p_dept 
      AND salary = (SELECT MAX(salary) FROM employees WHERE department = @p_dept)
);
GO

SELECT * FROM dbo.DEPT_MAX_EMP('Tech');
GO


-- ---------------------------------------------------------------------------------
-- 9. SYSTEMS ENTERPRISE AUTOMATION: AUDIT & PREVENTATIVE TRIGGERS
-- ---------------------------------------------------------------------------------

-- Data Auditing Trigger Logic (Capturing Salary Adjustments)
CREATE OR ALTER TRIGGER TRG_AUDIT_SALARY_CHANGE
ON employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(salary)
    BEGIN 
        INSERT INTO SALARY_AUDIT (EMPID, OLD_SALARY, NEW_SALARY)
        SELECT 
            d.emp_id,
            d.salary,
            i.salary
        FROM deleted d
        INNER JOIN inserted i ON d.emp_id = i.emp_id;
    END
END;
GO

-- Safety Logic Trigger (Restricting Core Record Deletion Vectors via INSTEAD OF Triggers)
CREATE OR ALTER TRIGGER trg_preventManagementRemoval
ON employees
INSTEAD OF DELETE
AS 
BEGIN 
    SET NOCOUNT ON;
    -- Restrict any operations attempting to flush structural executive tiers
    IF EXISTS (SELECT 1 FROM deleted WHERE department = 'Management')
    BEGIN
        RAISERROR('System Security Violation: Strategic records in Management cannot be deleted.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM employees WHERE emp_id IN (SELECT emp_id FROM deleted);
    END
END;
GO

-- Verify System Trigger Registrations
EXEC sp_helptrigger 'employees';
GO