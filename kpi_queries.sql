USE ecommerce_warehouse;

-- TOTAL ORDERS & REVENUE
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue
FROM fact_sales;

-- AVERAGE ORDER VALUE (AOV)
SELECT
    SUM(revenue) / COUNT(DISTINCT order_id) AS avg_order_value
FROM fact_sales;


-- CUSTOMER LIFETIME VALUE (LTV)
SELECT
    customer_id,
    SUM(revenue) AS customer_ltv
FROM fact_sales
GROUP BY customer_id
ORDER BY customer_ltv DESC
LIMIT 10;


-- REPEAT PURCHASE RATE
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM fact_sales
    GROUP BY customer_id
    
    
)
SELECT
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM customer_orders;


-- RETURN RATE
SELECT
    ROUND(
        SUM(CASE 
            WHEN order_status IN ('canceled', 'unavailable') THEN 1 
            ELSE 0 
        END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS return_rate_percentage
FROM fact_sales;

