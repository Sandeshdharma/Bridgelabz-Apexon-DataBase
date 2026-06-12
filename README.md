Database Management and SQL Analytics Showcase


Welcome to my SQL reference repository. This project features my collection of T-SQL scripts for Microsoft SQL Server. It covers everything from basic CRUD operations and data design to advanced concepts like Joins, Window Functions, Stored Procedures, Functions, and Triggers. I created these scripts to serve as clean, practical examples of database engineering concepts.

Repository Structure and File Directory

1. advanced_employee_analytics_and_automation.sql

Core Focus: Advanced Database Programmability and Automation.
Key Components:

Performance-optimized schemas using localized data limits.

Multi-level data grouping using ROLLUP.

Dividing and calculating data using Window Functions (SUM() OVER()).

Creating an organizational hierarchy using Self-Joins.

Writing Stored Procedures with input/output variables, custom Functions (UDFs), an AFTER UPDATE data audit trigger, and an INSTEAD OF DELETE safety trigger.


2. company_management_and_project_allocations.sql

Core Focus: Data Relationships and Tracking Corporate Projects.
Key Components:

Managing a standard One-to-Many relationship between data tables.

Handling project timelines dynamically using GETDATE().

Querying active assignments with INNER JOIN and generating combination grids using CROSS JOIN.


3. university_enrollment_system.sql

Core Focus: Complex Relational Modeling.
Key Components:

Setting up a Many-to-Many relationship using a central junction table with ON DELETE CASCADE rules.

Querying records across multiple connected tables using subqueries and multi-table Joins.

Building a custom Stored Procedure to generate financial student invoices.

4. store_operations_and_joins.sql

Core Focus: Complete Relational SQL Join Mastery.
Key Components:

Direct comparison examples for INNER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN, and CROSS JOIN.

Using Stored Procedures to insert transactions safely with basic error validation.

5. school_db_crud_operations.sql and employee_details_schema.sql

Core Focus: Foundational Database Management and Table Lifecycles.
Key Components:

Exploring system states using sys.databases and metadata procedures like sp_help.

Core CRUD operations (Create, Read, Update, Delete).

Modifying an existing database schema using ALTER TABLE.

