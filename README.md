# Database Management and SQL Analytics Showcase

A comprehensive reference repository featuring production-grade, highly structured SQL scripts engineered for Microsoft SQL Server (T-SQL). This showcase highlights database schema normalization, advanced relational query patterns, data analytics automation, and custom script modularity.

---


> Note: All production scripts are safely isolated within a dedicated feature branch. Switch code environments to inspect the raw query sets.

---

## Repository Structure and File Directory

### 1. Advanced Employee Analytics and Automation
advanced_employee_analytics_and_automation.sql
- Core Focus: Database Programmability, Automation, and Advanced Querying.
- Key Highlights:
  - Multi-level data grouping using ROLLUP.
  - Advanced analytical partitioning using Window Functions (SUM() OVER()).
  - Corporate hierarchy tracking utilizing recursive Self-Joins.
  - Database Automation: Robust Stored Procedures featuring conditional execution logic (OUTPUT variables), custom User-Defined Functions (UDFs), data auditing AFTER UPDATE triggers, and an INSTEAD OF DELETE programmatic safety gate.

### 2. Corporate Management and Project Allocations
company_management_and_project_allocations.sql
- Core Focus: Relational Integrity and Project Resource Tracking.
- Key Highlights:
  - Clean One-to-Many relationship mapping profiles across live operational tables.
  - Real-time projection tracking using dynamic date calculations via GETDATE().
  - Multi-table correlation utilizing complex INNER JOIN sets and resource compatibility evaluation maps via CROSS JOIN Cartesian products.

### 3. University Enrollment Management System
university_enrollment_system.sql
- Core Focus: Complex Multi-Table Relational Modeling.
- Key Highlights:
  - Implementation of a clean Many-to-Many relationship pattern using transactional junction tables with cascading constraints (ON DELETE CASCADE).
  - Deep matching validation utilizing structural subqueries, multiple table joins, and descriptive accounting reports managed via analytical Stored Procedures.

### 4. Retail Store Operations and Join Mastery
store_operations_and_joins.sql
- Core Focus: Complete Relational SQL Join Universes.
- Key Highlights:
  - Clear visual dataset isolation demonstrating exact output contrasts across INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER, and CROSS joins.
  - Multi-input database operations utilizing transactional Stored Procedures with error constraint parameters.

### 5. School Administration Baseline
school_db_crud_operations.sql and employee_details_schema.sql
- Core Focus: Fundamental Schema Administration and Lifecycle Management.
- Key Highlights:
  - Server inventory audits utilizing system catalog configurations (sys.databases) and metadata lookup procedures (sp_help).
  - Hands-on implementation of Data Manipulation Language (DML) primitives: Create, Read, Update, and Delete (CRUD) patterns alongside dynamic table restructuring via ALTER TABLE.

---

## How to Deploy and Execute

1. Open SQL Server Management Studio (SSMS) and log into your server instance.
2. Clone this repository or copy the contents of your target .sql workspace script.
3. Open the target script file inside the SSMS query interface window.
4. Execute individual code blocks sequentially (Press F5 or click the Execute button) to instantiate database setups, seed baseline mock rows, and visualize diagnostic query analytics outputs.
