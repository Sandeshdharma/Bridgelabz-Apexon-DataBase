-- =================================================================================
-- Database Script: Educational Records Management System (School_DB)
-- Purpose: Demonstrates Foundational Database Administration (DB Exploration,
--          Schema Modification (ALTER), and Core CRUD Operations).
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. SERVER ENVIRONMENT EXPLORATION
-- ---------------------------------------------------------------------------------

-- List down all existing databases on the current server instance
EXEC sp_databases;

-- Alternative system catalog view query for searching database names
SELECT name FROM sys.databases;
GO


-- ---------------------------------------------------------------------------------
-- 2. DATABASE INITIALIZATION
-- ---------------------------------------------------------------------------------

-- Spin up the school infrastructure tracking instance
CREATE DATABASE School_DB;
GO

-- Switch runtime scope to the newly provisioned database
USE School_DB;
GO

-- Verify the current actively connected database context
SELECT DB_NAME() AS ActiveDatabase;
GO


-- ---------------------------------------------------------------------------------
-- 3. SCHEMA DEFINITION & MUTATIONS (DDL)
-- ---------------------------------------------------------------------------------

-- Create the baseline core 'Students' roster table
CREATE TABLE Students
(
    Student_ID INT NOT NULL,
    Name VARCHAR(50), -- Initially declared with a conservative size limit
    Age INT,
    Grade INT
);
GO

-- Inspect structural metadata, properties, and verification indexes
EXEC sp_help 'Students';
GO

-- Schema Modification: Adjusting column data-length boundaries dynamically
ALTER TABLE Students
ALTER COLUMN Name VARCHAR(100);
GO


-- ---------------------------------------------------------------------------------
-- 4. DATA LOGISTICS & MANIPULATION (DML / CRUD Operations)
-- ---------------------------------------------------------------------------------

-- A. CREATE: Ingestion of records into the dataset matrix
INSERT INTO Students (Student_ID, Name, Age, Grade)
VALUES (101, 'Sandesh', 22, 10);

-- Bulk Ingestion Step
INSERT INTO Students (Student_ID, Name, Age, Grade)
VALUES 
    (102, 'Palash', 23, 11), 
    (103, 'Sanchi', 21, 8), 
    (104, 'Ujjwal', 20, 9), 
    (106, 'Ishika', 22, 20);
GO

-- B. READ: Dynamic evaluation and retrieval
SELECT * FROM Students;
SELECT Name FROM Students;
GO

-- C. UPDATE: Modifying state markers within target sets
UPDATE Students
SET Grade = 12
WHERE Student_ID = 104;
GO

-- D. DELETE: Removing specific localized records
DELETE FROM Students
WHERE Student_ID = 104;
GO


-- ---------------------------------------------------------------------------------
-- 5. REPOSITORY EXERCISES & DATA CLEANUP DEMONSTRATION
-- ---------------------------------------------------------------------------------

-- Exercise 1: Update specific attribute filtering by a string literal match
UPDATE Students
SET Grade = 5
WHERE Name = 'Sandesh';

-- Exercise 2: Add a new record to verify constraint consistency
INSERT INTO Students (Student_ID, Name, Age, Grade)
VALUES (106, 'Sarthak', 24, 9);

-- Exercise 3: Resolve duplicate identity conflicts by refining explicit rows
UPDATE Students
SET Student_ID = 107
WHERE Student_ID = 106 AND Name = 'Sarthak';

-- Exercise 4: Clean up test profiles via target criteria matching
DELETE FROM Students
WHERE Name = 'Ishika';
GO


-- ---------------------------------------------------------------------------------
-- 6. FINAL DATA QUALITY ASSURANCE CHECKS
-- ---------------------------------------------------------------------------------

-- Verify complete state of the finalized tracking table
SELECT * FROM Students;

-- Specific target isolation read checks
SELECT Student_ID, Name, Age, Grade 
FROM Students
WHERE Name = 'Sandesh';
GO