CREATE DATABASE ecommerce_warehouse;
USE ecommerce_warehouse;


CREATE TABLE stg_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);


CREATE TABLE stg_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);


CREATE TABLE stg_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

CREATE TABLE stg_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

CREATE TABLE stg_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE stg_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);


SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE stg_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp        = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at               = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date    = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date   = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date   = NULLIF(@order_estimated_delivery_date, '');



SELECT COUNT(*) FROM stg_orders;
SELECT * FROM stg_orders LIMIT 5;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE stg_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE stg_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE stg_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');



LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE stg_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE stg_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE stg_order_reviews
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
    ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_creation_date = NULLIF(@review_creation_date, ''),
    review_answer_timestamp = NULLIF(@review_answer_timestamp, '');

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE stg_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'stg_orders' AS table_name, COUNT(*) AS row_count FROM stg_orders
UNION ALL
SELECT 'stg_order_items', COUNT(*) FROM stg_order_items
UNION ALL
SELECT 'stg_customers', COUNT(*) FROM stg_customers
UNION ALL
SELECT 'stg_products', COUNT(*) FROM stg_products
UNION ALL
SELECT 'stg_category_translation', COUNT(*) FROM stg_category_translation
UNION ALL
SELECT 'stg_order_payments', COUNT(*) FROM stg_order_payments
UNION ALL
SELECT 'stg_order_reviews', COUNT(*) FROM stg_order_reviews
UNION ALL
SELECT 'stg_sellers', COUNT(*) FROM stg_sellers;


CREATE TABLE dim_customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);

CREATE TABLE dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE dim_seller (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    year INT,
    quarter INT,
    weekday VARCHAR(20)
);

SHOW TABLES LIKE 'dim_%';

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


SELECT customer_id, COUNT(*)
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

CREATE TABLE fact_sales (
    fact_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    date_id INT,

    quantity INT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    payment_value DECIMAL(10,2),

    revenue DECIMAL(12,2),
    review_score INT,
    order_status VARCHAR(20),
    CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    CONSTRAINT fk_fact_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    CONSTRAINT fk_fact_seller FOREIGN KEY (seller_id) REFERENCES dim_seller(seller_id),
    CONSTRAINT fk_fact_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);
SHOW TABLES LIKE 'fact_%';
DESCRIBE fact_sales;

INSERT INTO fact_sales (
    order_id,
    customer_id,
    product_id,
    seller_id,
    date_id,
    quantity,
    price,
    freight_value,
    payment_value,
    revenue,
    review_score,
    order_status
)
SELECT
    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    d.date_id,

    1 AS quantity,

    oi.price,
    oi.freight_value,
    p.total_payment,
    oi.price AS revenue,
    r.review_score,
    o.order_status
FROM stg_order_items oi
JOIN stg_orders o
    ON oi.order_id = o.order_id

LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM stg_order_payments
    GROUP BY order_id
) p
    ON oi.order_id = p.order_id

LEFT JOIN stg_order_reviews r
    ON oi.order_id = r.order_id

JOIN dim_date d
    ON d.full_date = DATE(o.order_purchase_timestamp);

SELECT COUNT(*) FROM fact_sales;
SELECT * FROM fact_sales LIMIT 10;

SELECT COUNT(*) 
FROM fact_sales 
WHERE revenue IS NULL;

SELECT COUNT(*) 
FROM fact_sales 
WHERE date_id IS NULL;

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue
FROM fact_sales;

SELECT
    SUM(revenue) / COUNT(DISTINCT order_id) AS avg_order_value
FROM fact_sales;

SELECT
    customer_id,
    SUM(revenue) AS customer_ltv
FROM fact_sales
GROUP BY customer_id
ORDER BY customer_ltv DESC
LIMIT 10;

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


SELECT COUNT(DISTINCT order_id) FROM fact_sales;


SELECT MIN(revenue), MAX(revenue) FROM fact_sales;

CREATE VIEW vw_monthly_sales AS
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year, d.month, d.month_name
ORDER BY
    d.year, d.month;

SELECT * FROM vw_monthly_sales;

CREATE VIEW vw_monthly_aov AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.revenue) / COUNT(DISTINCT f.order_id) AS avg_order_value
FROM fact_sales f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year, d.month, d.month_name
ORDER BY
    d.year, d.month;

SELECT * FROM vw_monthly_aov;

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
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year, d.month, d.month_name
ORDER BY
    d.year, d.month;

CREATE VIEW vw_monthly_customer_type AS
WITH first_purchase AS (
    SELECT
        dc.customer_unique_id,
        MIN(dd.full_date) AS first_order_date
    FROM fact_sales f
    JOIN dim_customer dc ON f.customer_id = dc.customer_id
    JOIN dim_date dd ON f.date_id = dd.date_id
    GROUP BY dc.customer_unique_id
)
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(CASE 
        WHEN fp.first_order_date = d.full_date THEN 1 
        ELSE 0 
    END) AS new_customers,
    SUM(CASE 
        WHEN fp.first_order_date < d.full_date THEN 1 
        ELSE 0 
    END) AS repeat_customers
FROM fact_sales f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
JOIN dim_date d ON f.date_id = d.date_id
JOIN first_purchase fp ON dc.customer_unique_id = fp.customer_unique_id
GROUP BY
    d.year, d.month, d.month_name
ORDER BY
    d.year, d.month;

SELECT * FROM vw_monthly_sales LIMIT 5;
SELECT * FROM vw_monthly_aov LIMIT 5;
SELECT * FROM vw_monthly_returns LIMIT 5;
SELECT * FROM vw_monthly_customer_type LIMIT 5;

CREATE INDEX idx_fact_order_id 
ON fact_sales(order_id);

CREATE INDEX idx_fact_customer_id 
ON fact_sales(customer_id);

CREATE INDEX idx_fact_product_id 
ON fact_sales(product_id);

CREATE INDEX idx_fact_date_id 
ON fact_sales(date_id);

CREATE INDEX idx_fact_order_status
ON fact_sales(order_status);


CREATE INDEX idx_dim_customer_unique
ON dim_customer(customer_unique_id);

CREATE INDEX idx_dim_date_full_date
ON dim_date(full_date);


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


SELECT COUNT(*)
FROM fact_sales
WHERE revenue < 0;


SELECT COUNT(*)
FROM fact_sales
WHERE date_id IS NULL;

EXPLAIN
SELECT *
FROM vw_monthly_sales
WHERE year = 2017;
