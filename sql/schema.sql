DROP TABLE IF EXISTS amazon_sales;

CREATE TABLE amazon_sales (

    id SERIAL PRIMARY KEY,

    product_id VARCHAR(255) NOT NULL,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    rating_count INT NOT NULL,
    discounted_price NUMERIC(10,2) NOT NULL,
    actual_price NUMERIC(10,2) NOT NULL,
    discount_percentage NUMERIC(10,2) NOT NULL,
    promotion_start_date DATE,
    promotion_end_date DATE,
    user_id VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL
    
   
);