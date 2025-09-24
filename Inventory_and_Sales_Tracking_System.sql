-- =======================================================
-- INVENTORY AND SALES TRACKING SYSTEM
-- Vanessa's SQL Project 
-- =======================================================

-- Database
CREATE DATABASE Inventory_and_Sales_Tracking_System;

-- Create Table
-- Suppliers
CREATE TABLE IF NOT EXISTS suppliers (
	supplier_id SERIAL PRIMARY KEY,
	supplier_name VARCHAR(50),
	contact_info VARCHAR(50)
);

-- Customers
CREATE TABLE IF NOT EXISTS customers (
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(50),
	contact_info VARCHAR(50)
);

-- Products
CREATE TABLE IF NOT EXISTS products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(50),
	category VARCHAR(50),
	unit_price DECIMAL(10,2),
	stock_quantity INT,
	supplier_id INT NOT NULL REFERENCES suppliers(supplier_id) ON DELETE CASCADE
);

-- Sales
CREATE TABLE IF NOT EXISTS sales (
	sale_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
	sale_date DATE,
	total_amount DECIMAL(10,2)
);

-- Sale_Items
CREATE TABLE IF NOT EXISTS sale_items (
	sale_item_id SERIAL PRIMARY KEY,
	sale_id INT NOT NULL REFERENCES sales(sale_id) ON DELETE CASCADE,
	product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
	quantity INT,
	unit_price DECIMAL(10,2)
);

-- Insert Into Table
-- Suppliers
INSERT INTO suppliers (supplier_name, contact_info) VALUES
('Tech Supplier Co', 'tech@suppliers.com'),
('Food Supplier Inc', 'food@suppliers.com'),
('Clothing Supplier Ltd', 'clothes@suppliers.com');

-- Customers
INSERT INTO customers (customer_name, contact_info) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Carol White', 'carol@example.com');

-- Products
INSERT INTO products (product_name, category, unit_price, stock_quantity, supplier_id) VALUES
('Laptop', 'Electronics', 1500.00, 50, 1),
('Smartphone', 'Electronics', 800.00, 100, 1),
('Headphones', 'Electronics', 150.00, 200, 1),
('Apple', 'Food', 1.50, 500, 2),
('Banana', 'Food', 1.00, 400, 2),
('Jeans', 'Clothing', 40.00, 150, 3),
('T-Shirt', 'Clothing', 20.00, 300, 3);

-- Sales
INSERT INTO sales (customer_id, sale_date, total_amount) VALUES
(1, '2025-08-01', 3150.00),
(2, '2025-08-02', 850.00),
(1, '2025-08-03', 55.00),
(3, '2025-08-05', 40.00);

-- Sale Items
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1500.00),
(1, 3, 1, 150.00),
(2, 2, 1, 800.00),
(2, 4, 50, 1.00),
(3, 6, 1, 40.00),
(3, 4, 10, 1.50),
(4, 7, 2, 20.00);

-- Practice Query

-- 1. Show all customers and their contact info
SELECT * FROM customers;

-- 2. Show all sales transactions
SELECT * FROM sales;

-- 3. Show all suppliers
SELECT * FROM suppliers;

-- 4. List all products with their category and price
SELECT product_name, category, unit_price FROM products;

-- 5. Show products with stock less than 100
SELECT product_name, stock_quantity FROM products WHERE stock_quantity < 100;

-- 6. Show sales with total_amount greater than 1,000
SELECT * FROM sales WHERE total_amount > 1000;

-- 7. List all products ordered by stock_quantity ascending
SELECT product_name, stock_quantity FROM products ORDER BY stock_quantity ASC;

-- 8. Show all customers in alphabetical order
SELECT customer_name FROM customers ORDER BY customer_name ASC;

-- 9. List all sales from August 2025
SELECT * FROM sales
WHERE EXTRACT(MONTH FROM sale_date) = 8
  AND EXTRACT(YEAR FROM sale_date) = 2025;

-- 10. Show all products in the “Electronics” category
SELECT product_name, unit_price FROM products WHERE category = 'Electronics';

-- 11. Show all sales with customer names
SELECT s.sale_id, c.customer_name, s.sale_date, s.total_amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id;

-- 12. Show products with supplier names
SELECT p.product_name, s.supplier_name
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id;

-- 13. Total number of products per category
SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category;

-- 14. Total stock quantity per category
SELECT category, SUM(stock_quantity) AS total_stock
FROM products
GROUP BY category;

-- 15. Total sales per month
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month,
       SUM(total_amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

-- 16. Top 5 best-selling products
SELECT p.product_name, SUM(si.quantity) AS total_sold
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- 17. Customer purchase history
SELECT c.customer_name, s.sale_date, p.product_name, si.quantity
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN sale_items si ON s.sale_id = si.sale_id
JOIN products p ON si.product_id = p.product_id;

-- 18. Total revenue per product
SELECT p.product_name, SUM(si.quantity * si.unit_price) AS revenue
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 19. List products with no sales
SELECT product_name
FROM products
WHERE product_id NOT IN (SELECT product_id FROM sale_items);

-- 20. Show sales with quantity > 5 for any item
SELECT s.sale_id, p.product_name, si.quantity
FROM sale_items si
JOIN sales s ON si.sale_id = s.sale_id
JOIN products p ON si.product_id = p.product_id
WHERE si.quantity > 5;

-- 21. Total revenue per customer
SELECT c.customer_name, SUM(s.total_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 22. Products sold above 50 units total
SELECT p.product_name, SUM(si.quantity) AS total_sold
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(si.quantity) > 50;

-- 23. Monthly revenue per product category
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month, p.category,
       SUM(si.quantity * si.unit_price) AS revenue
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
JOIN sales s ON si.sale_id = s.sale_id
GROUP BY month, p.category
ORDER BY month, revenue DESC;

-- 24. Customers who bought all products from “Electronics” category
SELECT c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM products p
    WHERE p.category = 'Electronics'
      AND NOT EXISTS (
          SELECT 1
          FROM sales s
          JOIN sale_items si ON s.sale_id = si.sale_id
          WHERE s.customer_id = c.customer_id AND si.product_id = p.product_id
      )
);

-- 25. View for low stock products
CREATE VIEW low_stock_products AS
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 100;

SELECT * FROM low_stock_products;

-- 26. Trigger – Update stock after sale
-- Step 1: Create the trigger function
CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER AS $$
BEGIN
    -- Deduct the sold quantity from the product stock
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Attach the trigger to the sale_items table
CREATE TRIGGER update_stock_after_sale
AFTER INSERT ON sale_items
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_sale();

CREATE OR REPLACE VIEW current_stock AS
SELECT 
    product_id,
    product_name,
    stock_quantity
FROM products;

-- Insert new Sales
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1500.00);

-- See current stock
SELECT * FROM current_stock;

-- 27. Top 3 customers by purchase quantity in last 6 months
SELECT c.customer_name, SUM(si.quantity) AS total_quantity
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN sale_items si ON s.sale_id = si.sale_id
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY c.customer_name
ORDER BY total_quantity DESC
LIMIT 3;

-- 28. Supplier revenue contribution
SELECT sup.supplier_name, SUM(si.quantity * si.unit_price) AS total_revenue
FROM suppliers sup
JOIN products p ON sup.supplier_id = p.supplier_id
JOIN sale_items si ON p.product_id = si.product_id
GROUP BY sup.supplier_name
ORDER BY total_revenue DESC;

-- 29. Average sale amount per customer per month
SELECT c.customer_name, TO_CHAR(sale_date, 'YYYY-MM') AS month,
       AVG(s.total_amount) AS avg_sale
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name, month
ORDER BY c.customer_name, month;

-- 30. Create a function to return monthly sales report
CREATE OR REPLACE FUNCTION MonthlySalesReport(month_input DATE)
RETURNS TABLE(
    product_name VARCHAR,
    total_sold BIGINT,
    revenue NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.product_name, 
        SUM(si.quantity) AS total_sold,
        SUM(si.quantity * si.unit_price) AS revenue
    FROM sale_items si
    JOIN products p ON si.product_id = p.product_id
    JOIN sales s ON si.sale_id = s.sale_id
    WHERE EXTRACT(MONTH FROM s.sale_date) = EXTRACT(MONTH FROM month_input)
      AND EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM month_input)
    GROUP BY p.product_name
    ORDER BY revenue DESC;
END;
$$ LANGUAGE plpgsql;

-- Make sure the function exist
SELECT routine_name
FROM information_schema.routines
WHERE routine_name = 'monthlysalesreport';

-- Call the function
SELECT * 
FROM MonthlySalesReport('2025-08-01')
ORDER BY revenue DESC
LIMIT 3;
