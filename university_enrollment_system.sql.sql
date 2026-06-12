-- =================================================================================
-- Database Script: University Enrollment Management System (University_DB)
-- Purpose: Demonstrates Many-to-Many Relational Database Design, Junction Tables,
--          Data Seeding, Multi-Table Joins, and Analytical Stored Procedures.
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE SETUP
-- ---------------------------------------------------------------------------------
-- Create the main container for the university system
CREATE DATABASE university_db;
GO

-- Switch the context to use the newly created database
USE university_db;
GO


-- ---------------------------------------------------------------------------------
-- 2. SCHEMA DEFINITION (TABLE CREATION)
-- ---------------------------------------------------------------------------------

-- Create the 'courses' master catalog table
CREATE TABLE courses ( 
    course_id INT IDENTITY(1,1) PRIMARY KEY, 
    course_name VARCHAR(100) NOT NULL, 
    course_fee NUMERIC(10, 2) NOT NULL 
);

-- Create the 'students' identity profile table
CREATE TABLE students (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

-- Create the 'enrollment' junction table
-- Implements a Many-to-Many relationship mapping students to multiple academic courses
CREATE TABLE enrollment (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
 
    -- Relational Integrity Constraints
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);
GO


-- ---------------------------------------------------------------------------------
-- 3. DATA POPULATION (SEEDING DATA)
-- ---------------------------------------------------------------------------------

-- Populate the 'courses' catalog with initial metadata and fee baselines
INSERT INTO courses (course_name, course_fee)
VALUES
    ('Mathematics', 500.00),
    ('Physics', 600.00),
    ('Chemistry', 700.00);

-- Populate the 'students' table with student identities
INSERT INTO students (student_name) 
VALUES
    ('Raju'),
    ('Sham'),
    ('Baburao'),
    ('Alex');

-- Populate 'enrollment' junction entries linking active student profiles to course tracks
INSERT INTO enrollment (student_id, course_id, enrollment_date)
VALUES
    (1, 1, '2025-01-01'), -- Raju (ID 1) logs into Mathematics (ID 1)
    (1, 2, '2025-01-15'), -- Raju (ID 1) logs into Physics (ID 2)
    (2, 1, '2025-02-01'), -- Sham (ID 2) logs into Mathematics (ID 1)
    (2, 3, '2025-02-15'), -- Sham (ID 2) logs into Chemistry (ID 3)
    (3, 3, '2025-03-25'); -- Baburao (ID 3) logs into Chemistry (ID 3)
GO

-- Verify standalone dataset population checks
SELECT * FROM courses;
SELECT * FROM students;
SELECT * FROM enrollment;
GO


-- ---------------------------------------------------------------------------------
-- 4. RELATIONAL DATA ANALYSIS (JOINS)
-- ---------------------------------------------------------------------------------

-- Comprehensive Analysis View: Resolving the Many-to-Many mapping
-- Combines Student records, Enrollment stamps, and Course data into a single readable output
SELECT 
    e.enrollment_id,
    s.student_id,
    s.student_name,
    c.course_name,
    c.course_fee,
    e.enrollment_date
FROM enrollment e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c  ON e.course_id = c.course_id;

-- Left Join Discovery Query: Tracking un-enrolled students (e.g., 'Alex' who has no classes)
SELECT 
    s.student_id,
    s.student_name,
    e.enrollment_id,
    e.enrollment_date
FROM students s
LEFT JOIN enrollment e ON s.student_id = e.student_id
ORDER BY e.enrollment_id DESC;
GO


-- ---------------------------------------------------------------------------------
-- 5. ADVANCED DATABASE OBJECTS: STORED PROCEDURES
-- ---------------------------------------------------------------------------------

-- Stored Procedure: Get Student Registration Report & Invoice Breakdown
-- Dynamically tracks enrollment metrics and total fees associated with a target student
IF OBJECT_ID('usp_GetStudentEnrollmentReport', 'P') IS NOT NULL
    DROP PROCEDURE usp_GetStudentEnrollmentReport;
GO

CREATE PROCEDURE usp_GetStudentEnrollmentReport
    @StudentName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Edge case verification logic
    IF NOT EXISTS (SELECT 1 FROM students WHERE student_name = @StudentName)
    BEGIN
        RAISERROR('Target record warning: The specified student profile does not exist.', 16, 1);
        RETURN;
    END

    -- Return comprehensive matrix payload
    SELECT 
        s.student_id,
        s.student_name,
        c.course_name,
        c.course_fee,
        e.enrollment_date
    FROM students s
    INNER JOIN enrollment e ON s.student_id = e.student_id
    INNER JOIN courses c    ON e.course_id = c.course_id
    WHERE s.student_name = @StudentName;
    
    -- Print overall accounting summary insights
    SELECT 
        SUM(c.course_fee) AS Total_Tuition_Invested,
        COUNT(e.course_id) AS Total_Active_Courses
    FROM students s
    INNER JOIN enrollment e ON s.student_id = e.student_id
    INNER JOIN courses c    ON e.course_id = c.course_id
    WHERE s.student_name = @StudentName;
END;
GO


-- ---------------------------------------------------------------------------------
-- 6. VERIFICATION EXECUTION EXAMPLES
-- ---------------------------------------------------------------------------------

-- Execute execution routine for student 'Raju' to view academic tracks
EXEC usp_GetStudentEnrollmentReport @StudentName = 'Raju';
GO