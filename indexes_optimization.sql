USE ecommerce_warehouse;

-- FACT TABLE INDEXES
CREATE INDEX idx_fact_order_id ON fact_sales(order_id);
CREATE INDEX idx_fact_customer_id ON fact_sales(customer_id);
CREATE INDEX idx_fact_product_id ON fact_sales(product_id);
CREATE INDEX idx_fact_date_id ON fact_sales(date_id);
CREATE INDEX idx_fact_order_status ON fact_sales(order_status);


-- DIMENSION INDEXES
CREATE INDEX idx_dim_customer_unique ON dim_customer(customer_unique_id);
CREATE INDEX idx_dim_date_full_date ON dim_date(full_date);


-- MATERIALIZED SUMMARY TABLE (MONTHLY SALES)
CREATE TABLE mv_monthly_sales AS
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name;


-- DATA VALIDATION
SELECT COUNT(*) FROM fact_sales WHERE revenue < 0;
SELECT COUNT(*) FROM fact_sales WHERE date_id IS NULL;


-- QUERY PLAN CHECK
EXPLAIN
SELECT *
FROM vw_monthly_sales
WHERE year = 2017;
