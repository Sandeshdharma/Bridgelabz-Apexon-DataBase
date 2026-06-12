-- =================================================================================
-- Database Script: Enterprise Corporate & Project Tracking System (Company)
-- Purpose: Demonstrates One-to-Many Relationships, Foreign Key Enforcement,
--          Dynamic Date Calculations (`GETDATE()`), Inner Joins, and Cross Joins.
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE INITIALIZATION
-- ---------------------------------------------------------------------------------
-- Spin up the centralized company database infrastructure
CREATE DATABASE Company;
GO

-- Set active context to the target database
USE Company;
GO


-- ---------------------------------------------------------------------------------
-- 2. SCHEMA DEFINITION (TABLE STRUCTURES)
-- ---------------------------------------------------------------------------------

-- Create the master 'Employee' registry table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Salary FLOAT NOT NULL,
    Gender VARCHAR(45) NOT NULL,
    Age INT NOT NULL,
    City VARCHAR(45) NOT NULL
);

-- Create the 'Projects' tracking table
-- Implements a structural Foreign Key mapping back to the Employee table (Id)
-- Allows NULL values on EmployeeId to represent unassigned/open project backlogs
CREATE TABLE Projects (
    ProjectId INT PRIMARY KEY IDENTITY(1, 1),
    Title VARCHAR(200) NOT NULL,
    ClientId INT NOT NULL,
    EmployeeId INT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(Id) ON DELETE SET NULL
);
GO


-- ---------------------------------------------------------------------------------
-- 3. DATA POPULATION (SEED DATA)
-- ---------------------------------------------------------------------------------

-- Populate employee directories across geographic hubs (London & Mumbai)
INSERT INTO Employee (Id, Name, Department, Salary, Gender, Age, City) 
VALUES 
    (1001, 'John Doe', 'IT', 35000, 'Male', 25, 'London'),
    (1002, 'Mary Smith', 'HR', 45000, 'Female', 27, 'London'),
    (1003, 'James Brown', 'Finance', 50000, 'Male', 28, 'London'),
    (1004, 'Mike Walker', 'Finance', 50000, 'Male', 28, 'London'),
    (1005, 'Linda Jones', 'HR', 75000, 'Female', 26, 'London'),
    (1006, 'Anurag Mohanty', 'IT', 35000, 'Male', 25, 'Mumbai'),
    (1007, 'Priyanla Dewangan', 'HR', 45000, 'Female', 27, 'Mumbai'),
    (1008, 'Sambit Mohanty', 'IT', 50000, 'Male', 28, 'Mumbai'),
    (1009, 'Pranaya Kumar', 'IT', 50000, 'Male', 28, 'Mumbai'),
    (1010, 'Hina Sharma', 'HR', 75000, 'Female', 26, 'Mumbai');

-- Populate operational deliverables roadmap (including assigned and unallocated projects)
INSERT INTO Projects (Title, ClientId, EmployeeId, StartDate, EndDate) 
VALUES  
    ('Develop ecommerce website from scratch', 1, 1003, GETDATE(), (GETDATE() + 35)),
    ('WordPress website for our company', 1, 1002, GETDATE(), (GETDATE() + 45)),
    ('Manage our company servers', 2, 1007, GETDATE(), (GETDATE() + 55)),
    ('Hosting account is not working', 3, 1009, GETDATE(), (GETDATE() + 65)),
    ('MySQL database from my desktop application', 4, 1010, GETDATE(), (GETDATE() + 75)),
    ('Develop new WordPress plugin for my business website', 2, NULL, GETDATE(), (GETDATE() + 85)), -- Unassigned
    ('Migrate web application and database to new server', 2, NULL, GETDATE(), (GETDATE() + 95)),  -- Unassigned
    ('Android Application development', 4, 1004, GETDATE(), (GETDATE() + 60)),
    ('Hosting account is not working', 3, 1001, GETDATE(), (GETDATE() + 70)),
    ('MySQL database from my desktop application', 4, 1008, GETDATE(), (GETDATE() + 80)),
    ('Develop new WordPress plugin for my business website', 2, NULL, GETDATE(), (GETDATE() + 90)); -- Unassigned
GO

-- Verify base tables
SELECT * FROM Employee;
SELECT * FROM Projects;
GO


-- ---------------------------------------------------------------------------------
-- 4. RELATIONAL DATA QUERIES & JOIN TECHNIQUES
-- ---------------------------------------------------------------------------------

-- Query A: INNER JOIN (Active Staff Project Utilization)
-- Filters out unassigned projects; returns only records where an employee matches a project
SELECT 
    P.EmployeeId, 
    E.Name AS EmployeeName, 
    E.Department,
    E.City, 
    P.Title AS ProjectTitle, 
    P.ClientId
FROM Employee AS E
INNER JOIN Projects AS P ON E.Id = P.EmployeeId;
GO

-- Query B: CROSS JOIN (Cartesian Product Evaluation Matrix)
-- Combines every unique employee with every project title regardless of relational assignment
-- Useful for calculating hypothetical resource availability allocations
SELECT 
    E.Id AS EmployeeId, 
    E.Name, 
    E.Department, 
    E.City, 
    P.Title AS ProjectTitle, 
    P.ClientId
FROM Employee E
CROSS JOIN Projects P;
GO