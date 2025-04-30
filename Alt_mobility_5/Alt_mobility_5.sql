show databases;
use alt_mobility;
show tables;
#1: Identify the Cohort Month
SELECT 
  customer_id,
  MIN(DATE_FORMAT(order_date, '%Y-%m')) AS cohort_month
FROM customer_orders
GROUP BY customer_id;
#2: Join Cohort Info with Orders
SELECT 
  o.customer_id,
  DATE_FORMAT(MIN(o.order_date), '%Y-%m') AS cohort_month,
  DATE_FORMAT(o.order_date, '%Y-%m') AS order_month
FROM customer_orders o
GROUP BY o.customer_id, order_month;
#3: Calculate Months Since First Order
WITH cohort_base AS (
  SELECT 
    customer_id,
    MIN(DATE(order_date)) AS cohort_date
  FROM customer_orders
  GROUP BY customer_id
)

SELECT 
  o.customer_id,
  DATE_FORMAT(cb.cohort_date, '%Y-%m') AS cohort_month,
  DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
  TIMESTAMPDIFF(MONTH, cb.cohort_date, o.order_date) AS month_number
FROM customer_orders o
JOIN cohort_base cb ON o.customer_id = cb.customer_id;

#4: Count Customers per Cohort & Month
WITH cohort_base AS (
  SELECT 
    customer_id,
    MIN(order_date) AS cohort_date
  FROM customer_orders
  GROUP BY customer_id
)
select
  DATE_FORMAT(cb.cohort_date, '%Y-%m') AS cohort_month,
  DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
  TIMESTAMPDIFF(MONTH, cb.cohort_date, o.order_date) AS month_number,
  COUNT(DISTINCT o.customer_id) AS retained_customers
FROM customer_orders o
JOIN cohort_base cb ON o.customer_id = cb.customer_id
GROUP BY cohort_month, order_month, month_number
ORDER BY cohort_month, month_number;


