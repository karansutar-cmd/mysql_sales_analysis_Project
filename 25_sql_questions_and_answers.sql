-- E-commerce Sales Analysis Project | MySQL 8.0+

-- Q01 [BASIC]: Show all customers.
SELECT * FROM customers;

-- Q02 [BASIC]: Display product names, categories, and prices from highest to lowest price.
SELECT product_name, category, price
FROM products
ORDER BY price DESC;

-- Q03 [BASIC]: Find products priced above ₹1,000.
SELECT product_id, product_name, price
FROM products
WHERE price > 1000
ORDER BY price DESC;

-- Q04 [BASIC]: List all distinct product categories.
SELECT DISTINCT category
FROM products
ORDER BY category;

-- Q05 [BASIC]: Find orders placed during October 2025.
SELECT *
FROM orders
WHERE order_date >= '2025-10-01' AND order_date < '2025-11-01'
ORDER BY order_date;

-- Q06 [BASIC]: Count the total number of customers.
SELECT COUNT(*) AS total_customers FROM customers;

-- Q07 [BASIC]: Calculate total quantity ordered across all orders.
SELECT SUM(quantity) AS total_units_ordered FROM orders;

-- Q08 [BASIC]: Show orders that were cancelled or returned.
SELECT * FROM orders
WHERE order_status IN ('Cancelled', 'Returned')
ORDER BY order_id;

-- Q09 [INTERMEDIATE]: Show each order with the customer name and order date.
SELECT o.order_id, c.customer_name, o.order_date, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Q10 [INTERMEDIATE]: Show each order with its product name, quantity, and total amount.
SELECT o.order_id, p.product_name, o.quantity, o.total_amount
FROM orders o
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_id;

-- Q11 [INTERMEDIATE]: Calculate total order value by order status.
SELECT order_status, SUM(total_amount) AS total_order_value
FROM orders
GROUP BY order_status
ORDER BY total_order_value DESC;

-- Q12 [INTERMEDIATE]: Count orders placed by each customer, including customers with zero orders.
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC, c.customer_name;

-- Q13 [INTERMEDIATE]: Calculate delivered sales by product category, excluding cancelled and returned orders.
SELECT p.category, SUM(o.total_amount) AS delivered_sales
FROM orders o JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY delivered_sales DESC;

-- Q14 [INTERMEDIATE]: Find customers whose total delivered spending is more than ₹5,000.
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS delivered_spending
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 5000
ORDER BY delivered_spending DESC;

-- Q15 [INTERMEDIATE]: Find the five best-selling products by units in delivered orders.
SELECT p.product_id, p.product_name, SUM(o.quantity) AS units_sold
FROM products p JOIN orders o ON p.product_id = o.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 5;

-- Q16 [INTERMEDIATE]: Show monthly delivered sales for 2025.
SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, SUM(total_amount) AS delivered_sales
FROM orders
WHERE order_status = 'Delivered' AND order_date >= '2025-01-01' AND order_date < '2026-01-01'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

-- Q17 [INTERMEDIATE]: Find customers who have never placed an order.
SELECT c.customer_id, c.customer_name
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q18 [ADVANCED]: Find products priced above the average product price.
SELECT product_id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Q19 [ADVANCED]: Find the customer or customers with the highest total delivered spending.
WITH customer_spending AS (
 SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS spending
 FROM customers c JOIN orders o ON c.customer_id = o.customer_id
 WHERE o.order_status = 'Delivered'
 GROUP BY c.customer_id, c.customer_name
)
SELECT * FROM customer_spending
WHERE spending = (SELECT MAX(spending) FROM customer_spending);

-- Q20 [ADVANCED]: Rank products by delivered sales within each category.
WITH product_sales AS (
 SELECT p.product_id, p.product_name, p.category, SUM(o.total_amount) AS delivered_sales
 FROM products p JOIN orders o ON p.product_id = o.product_id
 WHERE o.order_status = 'Delivered'
 GROUP BY p.product_id, p.product_name, p.category
)
SELECT product_id, product_name, category, delivered_sales,
 RANK() OVER (PARTITION BY category ORDER BY delivered_sales DESC) AS sales_rank
FROM product_sales ORDER BY category, sales_rank;

-- Q21 [ADVANCED]: Calculate running delivered sales by order date.
SELECT order_id, order_date, total_amount,
 SUM(total_amount) OVER (ORDER BY order_date, order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sales
FROM orders WHERE order_status = 'Delivered'
ORDER BY order_date, order_id;

-- Q22 [ADVANCED]: Compare each month's delivered sales with the previous month.
WITH monthly_sales AS (
 SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, SUM(total_amount) AS delivered_sales
 FROM orders WHERE order_status = 'Delivered'
 GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT sales_month, delivered_sales,
 LAG(delivered_sales) OVER (ORDER BY sales_month) AS previous_month_sales,
 delivered_sales - LAG(delivered_sales) OVER (ORDER BY sales_month) AS change_from_previous_month
FROM monthly_sales ORDER BY sales_month;

-- Q23 [ADVANCED]: Calculate delivered sales contribution percentage for each product category.
WITH category_sales AS (
 SELECT p.category, SUM(o.total_amount) AS delivered_sales
 FROM products p JOIN orders o ON p.product_id = o.product_id
 WHERE o.order_status = 'Delivered'
 GROUP BY p.category
)
SELECT category, delivered_sales,
 ROUND(100.0 * delivered_sales / SUM(delivered_sales) OVER (), 2) AS sales_percentage
FROM category_sales ORDER BY delivered_sales DESC;

-- Q24 [ADVANCED]: Calculate revenue, cost, gross profit, and profit margin by product for delivered orders.
SELECT p.product_id, p.product_name,
 SUM(o.quantity * p.price) AS sales_revenue,
 SUM(o.quantity * p.cost_price) AS cost_value,
 SUM(o.quantity * (p.price - p.cost_price)) AS gross_profit,
 ROUND(100.0 * SUM(o.quantity * (p.price - p.cost_price)) / NULLIF(SUM(o.quantity * p.price), 0), 2) AS profit_margin_pct
FROM products p JOIN orders o ON p.product_id = o.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY gross_profit DESC;

-- Q25 [ADVANCED]: Find each customer's latest order using ROW_NUMBER().
WITH ranked_orders AS (
 SELECT o.*, c.customer_name,
 ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC, o.order_id DESC) AS rn
 FROM orders o JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_id, customer_name, order_id, order_date, order_status, total_amount
FROM ranked_orders WHERE rn = 1 ORDER BY customer_id;

