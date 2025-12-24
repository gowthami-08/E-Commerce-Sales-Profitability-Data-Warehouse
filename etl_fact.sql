USE ecommerce_warehouse;

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

