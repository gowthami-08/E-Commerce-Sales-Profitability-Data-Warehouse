USE ecommerce_warehouse;

INSERT INTO dim_customer (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM stg_customers;

SELECT COUNT(*) FROM dim_customer;

INSERT INTO dim_seller (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT DISTINCT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM stg_sellers;

SELECT COUNT(*) FROM dim_seller;

INSERT INTO dim_product (
    product_id,
    product_category_name,
    product_category_name_english,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT DISTINCT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg_products p
LEFT JOIN stg_category_translation t
    ON p.product_category_name = t.product_category_name;

SELECT COUNT(*) FROM dim_product;

INSERT INTO dim_date (
    date_id,
    full_date,
    day,
    month,
    month_name,
    year,
    quarter,
    weekday
)
SELECT DISTINCT
    DATE_FORMAT(order_purchase_timestamp, '%Y%m%d') AS date_id,
    DATE(order_purchase_timestamp) AS full_date,
    DAY(order_purchase_timestamp) AS day,
    MONTH(order_purchase_timestamp) AS month,
    MONTHNAME(order_purchase_timestamp) AS month_name,
    YEAR(order_purchase_timestamp) AS year,
    QUARTER(order_purchase_timestamp) AS quarter,
    DAYNAME(order_purchase_timestamp) AS weekday
FROM stg_orders
WHERE order_purchase_timestamp IS NOT NULL;
