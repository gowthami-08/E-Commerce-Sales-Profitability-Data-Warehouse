USE ecommerce_warehouse;

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
