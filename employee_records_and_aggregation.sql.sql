-- =================================================================================
-- Database Script: Employee Information & Records Management System (EmployeeDB)
-- Purpose: Demonstrates Database Initialization, Structural Data Insertion,
--          and Analytical Querying (Data Aggregation and Grouping).
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE SETUP
-- ---------------------------------------------------------------------------------
-- Initialize the core employee records tracking database
CREATE DATABASE EmployeeDB;
GO

-- Direct execution context to the newly initialized database
USE EmployeeDB;
GO


-- ---------------------------------------------------------------------------------
-- 2. SCHEMA DEFINITION (TABLE CREATION)
-- ---------------------------------------------------------------------------------

-- Create the master 'Employee' information matrix table
-- Features identity column indexing for safe auto-incremented primary keys
CREATE TABLE Employee
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    EmailID VARCHAR(100) UNIQUE NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Salary INT NOT NULL,
    Age INT NOT NULL,
    CITY VARCHAR(100) NOT NULL
);
GO


-- ---------------------------------------------------------------------------------
-- 3. DATA POPULATION (SEEDING DATA)
-- ---------------------------------------------------------------------------------

-- Seed records across various operational corporate units (IT, HR, Payroll)
INSERT INTO Employee (Name, EmailID, Gender, Department, Salary, Age, CITY)
VALUES
    ('Pranaya', 'Pranaya@g.com', 'Male', 'IT', 25000, 30, 'Mumbai'),
    ('Tarun', 'Tarun@g.com', 'Male', 'Payroll', 30000, 27, 'Odisha'),
    ('Priyanka', 'Priyanka@g.com', 'Female', 'IT', 27000, 25, 'Bangalore'),
    ('Preety', 'Preety@g.com', 'Female', 'HR', 35000, 26, 'Bangalore'),
    ('Ramesh', 'Ramesh@g.com', 'Male', 'IT', 26000, 27, 'Mumbai'),
    ('Pramod', 'Pramod@g.com', 'Male', 'HR', 29000, 28, 'Odisha'),
    ('Anurag', 'Anurag@g.com', 'Male', 'Payroll', 27000, 26, 'Odisha'),
    ('Hina', 'Hina@g.com', 'Female', 'HR', 26000, 30, 'Mumbai'),
    ('Sambit', 'Sambit@g.com', 'Male', 'Payroll', 30000, 25, 'Odisha'),
    ('Manoj', 'Manoj@g.com', 'Male', 'HR', 30000, 28, 'Odisha'),
    ('Sara', 'Sara@g.com', 'Female', 'Payroll', 28000, 27, 'Mumbai'),
    ('Lima', 'Lima@g.com', 'Female', 'HR', 30000, 30, 'Bangalore'),
    ('Dipak', 'Dipak@g.com', 'Male', 'Payroll', 32000, 25, 'Bangalore');
GO

-- ---------------------------------------------------------------------------------
-- 4. BASIC SELECTION & VERIFICATION
-- ---------------------------------------------------------------------------------

-- Retrieve the complete raw employee directory
SELECT * FROM Employee;
GO


-- ---------------------------------------------------------------------------------
-- 5. REPOSITORY BONUS: METRIC AGGREGATION & REPORTING
-- ---------------------------------------------------------------------------------
-- Adding these analytical queries showcases clean database reporting skills on GitHub!

-- A. Department Summary Report
-- Evaluates budget consumption, workforce headcount, and average team age per unit
SELECT 
    Department,
    COUNT(ID) AS Total_Employees,
    SUM(Salary) AS Total_Budget_Spent,
    AVG(Salary) AS Average_Salary,
    AVG(Age) AS Average_Staff_Age
FROM Employee
GROUP BY Department;

-- B. Geographical Dispersion Matrix
-- Measures employee clusters located across target municipal centers
SELECT 
    CITY,
    COUNT(ID) AS Staff_Count,
    AVG(Salary) AS Market_Pay_Average
FROM Employee
GROUP BY CITY
HAVING COUNT(ID) > 2; -- Filters to show regions with structural density

-- C. Gender Demographics Analysis
-- Highlights payroll splits based on gender identities within the organization
SELECT 
    Gender,
    COUNT(ID) AS Headcount,
    AVG(Salary) AS Average_Compensation
FROM Employee
GROUP BY Gender;
GO