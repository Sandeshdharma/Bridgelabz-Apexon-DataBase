-- =================================================================================
-- Database Script: Employee Details Management (EmployeeDetails)
-- Purpose: Demonstrates optimized table creation using appropriate data lengths,
--          data normalization baselines, and structured record seeding.
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE & SCHEMA DEFINITION
-- ---------------------------------------------------------------------------------
-- Ensure you are using your targeted database container (e.g., EmployeeDB)
-- USE EmployeeDB;
-- GO

-- Create the refined 'EmployeeDetails' table
-- Optimized from VARCHAR(MAX) to realistic limits for performance and indexing safety
CREATE TABLE EmployeeDetails
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    EmailID VARCHAR(100) UNIQUE NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Salary INT NOT NULL,
    Age INT NOT NULL,
    City VARCHAR(100) NOT NULL
);
GO


-- ---------------------------------------------------------------------------------
-- 2. DATA POPULATION (SEEDING RECORDS)
-- ---------------------------------------------------------------------------------
-- Explicitly defining columns in the INSERT block prevents structural mismatch errors

INSERT INTO EmployeeDetails (Name, EmailID, Gender, Department, Salary, Age, City)
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
-- 3. VERIFICATION QUERY
-- ---------------------------------------------------------------------------------

-- Fetch the populated data to guarantee smooth constraint and insertion parsing
SELECT 
    ID, 
    Name, 
    EmailID, 
    Department, 
    Salary, 
    City 
FROM EmployeeDetails;
GO