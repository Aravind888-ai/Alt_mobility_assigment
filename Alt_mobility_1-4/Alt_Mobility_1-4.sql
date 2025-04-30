show databases;
use alt_mobility;
show tables;
#1.Order and Sales Analysis: 
#Order Fulfillment
SELECT 
	order_status, 
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customer_orders), 2) AS percentage
FROM customer_orders
GROUP BY order_status;
#Revenue Trends
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(order_amount) AS total_revenue,
    COUNT(order_id) AS total_orders
FROM customer_orders
WHERE order_status = 'delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
#2.Customer Analysis: 
#Repeat Orders & Trends
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spent
FROM customer_orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
#Customer Order Trend Over Time
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(order_id) AS total_orders
FROM customer_orders
GROUP BY order_month
ORDER BY order_month;
#3.Payment Status Analysis
#Success vs Failure
SELECT 
    payment_status,
    COUNT(payment_id) AS total_payments,
    SUM(payment_amount) AS total_value
FROM payments
GROUP BY payment_status;
# Payment Method vs Failure Rate
SELECT 
    payment_method,
    COUNT(payment_id) AS total_transactions,
    SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) AS failed_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) / COUNT(payment_id),
        2
    ) AS failure_rate_percentage
FROM payments
GROUP BY payment_method;
 #4.Order Details Report
#Comprehensive View
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_amount,
    o.order_status,
    o.shipping_address,
    p.payment_id,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM customer_orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id;










