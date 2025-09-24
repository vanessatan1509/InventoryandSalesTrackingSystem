Inventory and Sales Tracking System – SQL Project

<img width="998" height="692" alt="image" src="https://github.com/user-attachments/assets/30ecdb5f-0552-4e26-b815-0ed86e9da00e" />

Project Overview
This project is a fully functional SQL-based Inventory & Sales Tracking System designed to practice and demonstrate:
•	Database Design – Creating normalized tables with relationships and constraints
•	Data Insertion – Populating realistic sample data for products, suppliers, customers, and sales
•	SQL Queries – Writing simple to advanced queries for analysis, reporting, and stock management
•	Business Use Cases – Inventory tracking, sales monitoring, supplier & customer management, and revenue reporting

Database Schema & Relationships
-	Tables
1.	suppliers – Stores supplier names and contact information
2.	customers – Stores customer names and contact information
3.	products – Stores product details, stock quantity, unit price, and links to suppliers
4.	sales – Records each sale transaction with customer and date
5.	sale_items – Many-to-many link between sales and products, including quantity and unit price
-	Relationships
1.	One-to-Many: suppliers → products (each product has one supplier)
2.	One-to-Many: customers → sales (each sale is linked to one customer)
3.	One-to-Many: sales → sale_items (each sale can have multiple products sold)
4.	One-to-Many: products → sale_items (each product can appear in multiple sale items)

Inventory and Sales Tracking System Practice Query
1.	Show all customers and their contact info
2.	Show all sales transactions
3.	Show all suppliers
4.	List all products with their category and price
5.	Show products with stock less than 100
6.	Show sales with total_amount greater than 1,000
7.	List all products ordered by stock_quantity ascending
8.	Show all customers in alphabetical order
9.	List all sales from August 2025
10.	Show all products in the “Electronics” category
11.	Show all sales with customer names
12.	Show products with supplier names
13.	Total number of products per category
14.	Total stock quantity per category
15.	Total sales per month
16.	Top 5 best-selling products
17.	Customer purchase history
18.	Total revenue per product
19.	List products with no sales
20.	Show sales with quantity > 5 for any item
21.	Total revenue per customer
22.	Products sold above 50 units total
23.	Monthly revenue per product category
24.	Customers who bought all products from “Electronics” category
25.	View for low stock products
26.	Trigger – Update stock after sale
27.	Top 3 customers by purchase quantity in last 6 months
28.	Supplier revenue contribution
29.	Average sale amount per customer per month
30.	Create a function to return monthly sales report
