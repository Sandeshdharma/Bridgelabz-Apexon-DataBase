-- =================================================================================
-- Database Script: Store Database Management System (Store_DB)
-- Purpose: Demonstrates Database Creation, Table Schemas, Data Insertion,
--          Advanced SQL Joins (Inner, Left, Right, Full Outer, Cross), 
--          and Stored Procedures implementation.
-- Author: Sandesh Raj
-- Date: June 2026
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DATABASE SETUP
-- ---------------------------------------------------------------------------------
-- Create the main database container for the store application
CREATE DATABASE store_db;
GO

-- Switch the context to use the newly created database
USE store_db;
GO


-- ---------------------------------------------------------------------------------
-- 2. SCHEMA DEFINITION (TABLE CREATION)
-- ---------------------------------------------------------------------------------

-- Create the 'customers' table to store unique buyer profiles
-- Uses auto-incrementing identity starting at 100 for a realistic ID structure
CREATE TABLE customers
(
    customer_id INT IDENTITY(100, 1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Create the 'orders' table to record transactions
-- Establishes a Foreign Key constraint pointing back to the 'customers' table
CREATE TABLE orders
(
    order_id INT IDENTITY(500, 1) PRIMARY KEY,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);
GO

-- Verify table metadata, structure, indexes, and constraints
EXEC sp_help 'orders';
GO


-- ---------------------------------------------------------------------------------
-- 3. DATA POPULATION (SEEDING DATA)
-- ---------------------------------------------------------------------------------

-- Populate the 'customers' table with initial records
INSERT INTO customers (customer_name, email)
VALUES
    ('Raju', 'raju@example.com'),
    ('Sham', 'sham@example.com'),
    ('baburao', 'baburao@example.com');

-- Populate the 'orders' table with sample transactional records linked to customer IDs
INSERT INTO orders (order_date, total_amount, customer_id)
VALUES
    ('2025-09-15', 1500.00, 100), -- Transaction associated with Raju
    ('2025-09-28', 800.00, 101),  -- Transaction associated with Sham
    ('2025-10-05', 2200.00, 100), -- Transaction associated with Raju
    ('2025-10-12', 500.00, 102),  -- Transaction associated with Baburao
    ('2025-10-17', 1200.00, 101); -- Transaction associated with Sham

-- Basic data verification query
SELECT * FROM orders;
SELECT * FROM customers;

-- Insert an isolated order record (No customer assigned to demonstrate outer/right joins)
INSERT INTO orders (order_date, total_amount, customer_id)
VALUES ('2025-10-18', 3500.00, NULL);

-- Insert an isolated customer record (No matching transactions to demonstrate outer/left joins)
INSERT INTO customers (customer_name, email)
VALUES ('paul', 'paul@example.com');
GO


-- ---------------------------------------------------------------------------------
-- 4. SQL JOINS DEMONSTRATION
-- ---------------------------------------------------------------------------------

-- A. CROSS JOIN
-- Generates a Cartesian product (combines every customer row with every order row)
SELECT 
    c.customer_id, c.customer_name, o.order_id, o.total_amount 
FROM customers c 
CROSS JOIN orders o;


-- B. INNER JOIN
-- Retrieves only records that have matching values in both tables (active buyers with orders)
SELECT 
    c.customer_id, c.customer_name, c.email, 
    o.order_id, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;


-- C. LEFT OUTER JOIN
-- Returns all rows from the left table (customers), and matched rows from the right table (orders)
-- Includes customers who have never made a purchase (e.g., 'paul' will appear with NULL order data)
SELECT 
    c.customer_id, c.customer_name, 
    o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;


-- D. RIGHT OUTER JOIN
-- Returns all rows from the right table (orders), and matched rows from the left table (customers)
-- Includes standalone orders without an assigned customer profile (will display NULL for customer fields)
SELECT 
    c.customer_id, c.customer_name, 
    o.order_id, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


-- E. FULL OUTER JOIN
-- Combines the structural behavior of both Left and Right Joins
-- Shows all customers and all orders, inserting NULLs wherever matches are missing on either side
SELECT 
    c.customer_id, c.customer_name, 
    o.order_id, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
GO


-- ---------------------------------------------------------------------------------
-- 5. ADVANCED DATABASE OBJECTS: STORED PROCEDURES
-- ---------------------------------------------------------------------------------

-- Stored Procedure 1: Get Complete Customer Purchase History
-- Safely fetches all order statements dynamically for a specific customer ID
IF OBJECT_ID('usp_GetCustomerOrderHistory', 'P') IS NOT NULL
    DROP PROCEDURE usp_GetCustomerOrderHistory;
GO

CREATE PROCEDURE usp_GetCustomerOrderHistory
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the customer profile actually exists
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @CustomerID)
    BEGIN
        PRINT 'Error: The specified Customer ID does not exist.';
        RETURN;
    END

    -- Retrieve structural transactional rows
    SELECT 
        c.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date,
        o.total_amount
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = @CustomerID
    ORDER BY o.order_date DESC;
END;
GO

-- Stored Procedure 2: Place New Order with Validation
-- Safely creates an entry in the transaction log with strict constraint handling
IF OBJECT_ID('usp_PlaceNewOrder', 'P') IS NOT NULL
    DROP PROCEDURE usp_PlaceNewOrder;
GO

CREATE PROCEDURE usp_PlaceNewOrder
    @OrderDate DATE,
    @TotalAmount DECIMAL(10,2),
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Basic input boundary verification
    IF @TotalAmount <= 0
    BEGIN
        RAISERROR('Order total amount must be a positive decimal value.', 16, 1);
        RETURN;
    END

    -- Ensure integrity check for foreign key reference profile before handling execution
    IF @CustomerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @CustomerID)
    BEGIN
        RAISERROR('Cannot create order. Assigned Customer ID not found.', 16, 1);
        RETURN;
    END

    -- Execute formal insert logic
    INSERT INTO orders (order_date, total_amount, customer_id)
    VALUES (@OrderDate, @TotalAmount, @CustomerID);

    PRINT 'Success: Order entry registered successfully.';
END;
GO

-- ---------------------------------------------------------------------------------
-- 6. VERIFICATION & EXECUTION EXAMPLES
-- ---------------------------------------------------------------------------------

-- Example: Execute history procedure for customer 'Raju' (ID: 100)
EXEC usp_GetCustomerOrderHistory @CustomerID = 100;

-- Example: Execute formal order placement workflow
EXEC usp_PlaceNewOrder @OrderDate = '2026-06-12', @TotalAmount = 1750.50, @CustomerID = 101;
GO