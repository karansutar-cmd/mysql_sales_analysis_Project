E-commerce Sales Analysis Using MySQL

Project Overview

This project analyzes e-commerce sales data using MySQL. It covers customer orders, product performance, sales revenue, and profitability through 25 SQL questions ranging from basic to advanced.

Files Included

* "customers.csv" — 15 customer records
* "products.csv" — 12 products with categories, selling prices, and cost prices
* "orders.csv" — 40 order records
* "schema.sql" — Creates the "sales\_project" database and its tables
* "25\_sql\_questions\_and\_answers.sql" — 25 SQL questions with solutions
* 

Database Tables

1. Customers — Customer details, city, state, and signup date
2. Products — Product names, categories, selling prices, and cost prices
3. Orders — Order dates, customer IDs, product IDs, quantities, order statuses, and total amounts

SQL Concepts Covered

* SELECT, WHERE, ORDER BY, and DISTINCT
* Aggregate functions: COUNT, SUM, and AVG
* GROUP BY and HAVING
* INNER JOIN and LEFT JOIN
* Subqueries and Common Table Expressions (CTEs)
* Window functions: ROW\_NUMBER, RANK, and LAG
* Running totals, monthly sales, and profit margin calculations

How to Run the Project

1. Open MySQL Workbench and connect to your MySQL server.
2. Execute "schema.sql" to create the database and tables.
3. Refresh the Schemas panel.
4. Import "customers.csv" into the "customers" table using Table Data Import Wizard.
5. Import "products.csv" into the "products" table.
6. Import "orders.csv" into the "orders" table.
7. Open "25\_sql\_questions\_and\_answers.sql" and execute the queries individually.

Requirements

* MySQL 8.0 or later
* MySQL Workbench

Dataset Information

The dataset contains fictional practice data: 15 customers, 12 products, and 40 orders. It is intended for SQL learning and portfolio demonstration.

Sales analysis queries generally focus on delivered orders, excluding cancelled and returned orders unless a question specifically analyzes order status.

Project Purpose

The purpose of this project is to strengthen SQL skills and demonstrate practical data analysis techniques for entry-level Data Analyst and MIS roles.

