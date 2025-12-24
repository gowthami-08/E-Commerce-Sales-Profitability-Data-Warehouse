USE ecommerce_warehouse;

-- MONTHLY SALES VIEW
CREATE VIEW vw_monthly_sales AS
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;


-- MONTHLY AOV VIEW
CREATE VIEW vw_monthly_aov AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.revenue) / COUNT(DISTINCT f.order_id) AS avg_order_value
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;


-- MONTHLY RETURN RATE VIEW
CREATE VIEW vw_monthly_returns AS
SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(
        SUM(CASE 
            WHEN f.order_status IN ('canceled', 'unavailable') THEN 1
            ELSE 0
        END) * 100.0 / COUNT(DISTINCT f.order_id),
        2
    ) AS return_rate_percentage
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
