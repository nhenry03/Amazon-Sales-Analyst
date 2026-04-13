-- Which categories have the highest average discount percentage?
SELECT 
    category, 
    ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM amazon_sales
GROUP BY category
ORDER BY avg_discount DESC;


-- Which product in each category has the highest discount percentage? 
SELECT a.product_id, a.product_name, a.category, a.discount_percentage
FROM amazon_sales a
JOIN (
    SELECT category, MAX(discount_percentage) as max_discount
    FROM amazon_sales
    GROUP BY category
) b
ON a.category = b.category
AND a.discount_percentage = b.max_discount
ORDER BY a.discount_percentage DESC;

-- Which product has the longest promotion period 
SELECT product_id, product_name, (promotion_end_date - promotion_start_date) as period_duration
FROM amazon_sales
WHERE promotion_end_date IS NOT NULL AND promotion_start_date IS NOT NULL
GROUP BY product_id, product_name, promotion_end_date, promotion_start_date
ORDER BY period_duration DESC;

-- Which user has the most reviews? 
SELECT user_id, user_name, COUNT(*) as num_reviews
FROM amazon_sales
GROUP BY user_id, user_name
ORDER BY num_reviews DESC;

-- Which user has the most reviews in each category? 
SELECT a.user_id, a.user_name, a.category, a.num_reviews
FROM (
    SELECT user_id, user_name, category, COUNT(*) as num_reviews
    FROM amazon_sales
    GROUP BY user_id, user_name, category
) a
JOIN (
    SELECT category, MAX(num_reviews) as max_reviews
    FROM (
        SELECT user_id, user_name, category, COUNT(*) as num_reviews
        FROM amazon_sales
        GROUP BY user_id, user_name, category
    ) b
    GROUP BY category
) c
ON a.category = c.category
AND a.num_reviews = c.max_reviews
ORDER BY a.num_reviews DESC;

-- What is the total number of reviews for each category? 
SELECT category, COUNT(*) as num_reviews
FROM amazon_sales
GROUP BY category
ORDER BY num_reviews DESC;

-- Does a discount > 50% lead to higher average engagement (rating_count)?
SELECT 
    CASE 
        WHEN discount_percentage >= 50 THEN 'High Discount (>=50%)'
        ELSE 'Low Discount (<50%)'
    END as discount_tier,
    ROUND(AVG(rating_count), 0) as avg_rating_count,
    COUNT(product_id) as number_of_products
FROM amazon_sales
GROUP BY 
    CASE 
        WHEN discount_percentage >= 50 THEN 'High Discount (>=50%)'
        ELSE 'Low Discount (<50%)'
    END;


-- Which month had the highest number of promotions starting?
SELECT 
    EXTRACT(MONTH FROM promotion_start_date) as promo_month,
    COUNT(*) as number_of_promos_started
FROM amazon_sales
WHERE promotion_start_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM promotion_start_date)
ORDER BY number_of_promos_started DESC;




