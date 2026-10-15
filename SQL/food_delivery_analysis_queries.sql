CREATE DATABASE FDA_12;
USE FDA_12;
USE fda_12;

SHOW TABLES;
SELECT COUNT(*)
FROM food_delivery_cleaned;

USE fda_12;

SELECT COUNT(*) AS imported_rows
FROM food_delivery_cleaned;

USE fda_12;

SELECT
    COUNT(*) AS total_rows,
    SUM(tip_amount IS NULL) AS missing_tips
FROM food_delivery_cleaned;

USE fda_12;

SHOW CREATE TABLE food_delivery_cleaned;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

DESCRIBE fda_12.food_delivery_cleaned;

USE fda_12;

CREATE TABLE food_delivery_final
LIKE food_delivery_cleaned;

SELECT COUNT(*)
FROM food_delivery_final;

SELECT
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'fda_12'
  AND TABLE_NAME = 'food_delivery_final'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'fda_12'
AND TABLE_NAME = 'food_delivery_final';

SELECT COUNT(*) AS total_rows
FROM fda_12.food_delivery_final;

LOAD DATA LOCAL INFILE
'C:/Users/moham/Downloads/food_delivery_mysql.csv'
INTO TABLE fda_12.food_delivery_final
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT
    COUNT(*) AS total_rows,
    SUM(tip_amount IS NULL) AS missing_tips,
    SUM(actual_delivery_time_minutes IS NULL) AS missing_delivery_times
FROM fda_12.food_delivery_final;

SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(tip_amount IS NULL) AS missing_tips,
    SUM(actual_delivery_time_minutes IS NULL) AS missing_delivery_times
FROM fda_12.food_delivery_final
GROUP BY order_status;

USE fda_12;
SELECT COUNT(*) AS total_orders
FROM food_delivery_final;

-- how many unique individual customers,restaurants and drivers exist 
SELECT
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT restaurant_id) AS restaurants,
    COUNT(DISTINCT driver_id) AS drivers
FROM food_delivery_final;

-- check duplicate order ids
SELECT order_id, COUNT(*) AS occurrences
FROM food_delivery_final
GROUP BY order_id
HAVING COUNT(*) > 1;
-- empty result indicates no duplicate non-Null order ids were found

-- checkinf order status
SELECT order_status, COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY order_status;

-- Main Business KPIs
SELECT 
COUNT(*) AS total_orders,
ROUND(SUM(order_total),2) AS total_order_value,
ROUND(AVG(order_total),2) AS avg_order_value,
ROUND(SUM(discount_amount), 2) AS total_discount,
ROUND(SUM(tax_amount), 2) AS total_tax,
ROUND(SUM(delivery_fee), 2) AS total_delivery_fees
FROM food_delivery_final;

-- Delivery Performance KPIs
SELECT
COUNT(*) AS completed_orders,
ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time,
ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta,
ROUND(AVG(delay_minutes), 2) AS avg_delay,
ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed';

-- Orders by Day
SELECT order_date,
COUNT(*) AS total_orders,
ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY order_date
ORDER BY order_date;

-- CUSTOMER ANALYSIS
USE fda_12;

-- which cutmer type genrates most orders?
SELECT customer_type,
COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY customer_type
ORDER BY total_orders DESC;

-- which cutomer type has highest avg order value?
SELECT
customer_type,
ROUND(AVG(order_total), 2) AS avg_order_value
FROM food_delivery_final
GROUP BY customer_type
ORDER BY avg_order_value DESC;

-- Age distribution of cutomers
SELECT age_group,
COUNT(DISTINCT customer_id) AS total_customers
FROM food_delivery_final
GROUP BY age_group
ORDER BY MIN(customer_age);

-- which age group has most orders?
SELECT age_group,
COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY age_group
ORDER BY total_orders DESC;

-- Which customer segment contributes the most order value?
SELECT customer_type,
ROUND(SUM(order_total), 2) AS total_order_value,
ROUND(SUM(order_total) * 100 / (SELECT SUM(order_total) FROM food_delivery_final),2) AS contribution_pct
FROM food_delivery_final
GROUP BY customer_type
ORDER BY contribution_pct DESC;

-- Top 10 customers by total order value
SELECT customer_id,
COUNT(*) AS total_orders,
ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY customer_id
ORDER BY total_order_value DESC
LIMIT 10;

-- Identify repeat customers
SELECT customer_id,
COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

-- The customer type generating the most orders is Regular type
-- The customer type with the highest average order value is New type
-- The age group placing the most orders is 25-34

-- RESTAURANT ANALYSIS
USE fda_12;

-- which cuisine recieves highest number of orders?
 SELECT restaurant_primary_category AS cuisine,
COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY restaurant_primary_category
ORDER BY total_orders DESC;

-- Which cuisine generates the highest order value?
SELECT
restaurant_primary_category AS cuisine,
ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY restaurant_primary_category
ORDER BY total_order_value DESC;

-- Which restaurants have the highest ratings?
SELECT
    restaurant_id,
    ROUND(AVG(restaurant_rating), 2) AS avg_rating,
    COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY restaurant_id
ORDER BY avg_rating DESC, total_orders DESC
LIMIT 10;

-- Which restaurants have the longest preparation times?
SELECT
    restaurant_id,
    ROUND(AVG(restaurant_preparation_time_minutes), 2) AS avg_prep_time,
    COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY restaurant_id
ORDER BY avg_prep_time DESC
LIMIT 10;

-- Does restaurant preparation time affect delivery time?
SELECT
    prep_time_group,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY prep_time_group
ORDER BY MIN(restaurant_preparation_time_minutes);

-- Which cuisine categories have higher delivery times?
SELECT
    restaurant_primary_category AS cuisine,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY restaurant_primary_category
ORDER BY avg_delivery_time DESC;

-- summary
SELECT
    restaurant_id,
    COUNT(*) AS total_orders,
    ROUND(AVG(restaurant_rating), 2) AS avg_rating,
    ROUND(AVG(restaurant_preparation_time_minutes), 2) AS avg_prep_time,
    ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY restaurant_id
ORDER BY total_order_value DESC
LIMIT 10;

-- The cuisine receiving the highest number of orders is Burger
-- The cuisine generating the highest total order value is Burger
-- The highest-rated restaurant is RES_0018 , with an average rating of 5
-- The restaurant with the longest average preparation time is RES_0117
-- The cuisine category with the highest average delivery time is 'Healthy'

-- DRIVER ANALYSIS
USE fda_12;

-- Does driver experience affect delivery time?
SELECT
    driver_experience_group,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY driver_experience_group
ORDER BY avg_delivery_time;

-- Which experience group has the best delivery performance?
SELECT
    driver_experience_group,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY driver_experience_group
ORDER BY delay_rate_pct;

-- Does driver rating relate to delivery performance?
SELECT
    delivery_partner_rating AS driver_rating,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY delivery_partner_rating
ORDER BY driver_rating DESC;

-- Which drivers handle the highest number of orders?
SELECT
    driver_id,
    COUNT(*) AS total_orders
FROM food_delivery_final
GROUP BY driver_id
ORDER BY total_orders DESC
LIMIT 10;

-- Which driver groups have higher average delivery times?
SELECT
    driver_experience_group,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY driver_experience_group
ORDER BY avg_delivery_time DESC;

-- Driver performance ranking
SELECT
    driver_id,
    COUNT(*) AS completed_orders,
    ROUND(AVG(delivery_partner_rating), 2) AS avg_rating,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY driver_id
HAVING COUNT(*) >= 20
ORDER BY delay_rate_pct, avg_delivery_time
LIMIT 10;

-- Driver experience shows minimal differences in average delivery time
-- The 0-6 months experience group has the lowest delay rate at 75.51%
-- Driver DRV_0066 handled the highest number of orders , totalling 315 orders
-- The 7-12 months experience group has the highest average delivery time of 35.33 minutes.



-- TRAFFIC ANALYSIS

-- How does traffic density affect delivery time?
SELECT
    traffic_level,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY traffic_level
ORDER BY avg_delivery_time DESC;

-- Which traffic condition has the highest delivery time?
SELECT
    traffic_level,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY traffic_level
ORDER BY avg_delivery_time DESC
LIMIT 1;

-- What percentage of orders experience high traffic?
SELECT
    ROUND(
        SUM(CASE WHEN traffic_level = 'High' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS high_traffic_pct
FROM food_delivery_final;

-- Does high traffic increase delivery delays?
SELECT
    traffic_level,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct,
    ROUND(AVG(delay_minutes), 2) AS avg_delay
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY traffic_level
ORDER BY delay_rate_pct DESC;

-- What is the average ETA under different traffic conditions?
SELECT
    traffic_level,
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta
FROM food_delivery_final
GROUP BY traffic_level
ORDER BY avg_eta DESC;


-- WEATHER ANALYSIS

-- Which weather condition has the longest delivery time?
SELECT
    weather,
    COUNT(*) AS completed_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY weather
ORDER BY avg_delivery_time DESC;

-- Does bad weather increase delivery delays?
SELECT
    weather,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct,
    ROUND(AVG(delay_minutes), 2) AS avg_delay
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY weather
ORDER BY delay_rate_pct DESC;

-- Which weather condition has the highest average ETA?
SELECT
    weather,
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta
FROM food_delivery_final
GROUP BY weather
ORDER BY avg_eta DESC
LIMIT 1;

-- What percentage of deliveries occur under difficult weather?
SELECT DISTINCT weather
FROM food_delivery_final;

SELECT
ROUND(SUM(CASE WHEN weather IN ('Rain', 'Storm') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
 AS difficult_weather_pct
FROM food_delivery_final
WHERE order_status = 'Completed';

-- TRAFFIC and WEATHER combined Analysis
SELECT
    traffic_level,
    weather,
    COUNT(*) AS completed_orders,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY traffic_level, weather
ORDER BY delay_rate_pct DESC;

-- The traffic condition with the highest average delivery time is High tarffic level
-- Approximately 30.63% of orders experience high traffic.
-- Average ETA generally increases as traffic conditions become heavier
--  The weather condition associated with the longest delivery time is Storm
-- Approximately 17.70% of completed deliveries occur under the defined difficult weather conditions.


-- FINANCIAL , ETA AND DELAY Analysis

-- Overall financial KPIs
SELECT
    ROUND(SUM(order_total), 2) AS total_order_value,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(SUM(discount_amount), 2) AS total_discount,
    ROUND(SUM(tax_amount), 2) AS total_tax,
    ROUND(SUM(delivery_fee), 2) AS total_delivery_fees
FROM food_delivery_final;

-- Which customer type generates the highest order value?
SELECT
    customer_type,
    ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY customer_type
ORDER BY total_order_value DESC;

-- Which cuisine generates the highest order value?
SELECT
    restaurant_primary_category AS cuisine,
    ROUND(SUM(order_total), 2) AS total_order_value
FROM food_delivery_final
GROUP BY restaurant_primary_category
ORDER BY total_order_value DESC;

-- Does discount level affect order value?
SELECT
    discount_group,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM food_delivery_final
GROUP BY discount_group
ORDER BY avg_order_value DESC;


-- ETA & Delay Analysis

-- What is the average ETA?
SELECT
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta,
    ROUND(MIN(estimated_delivery_time_minutes), 2) AS min_eta,
    ROUND(MAX(estimated_delivery_time_minutes), 2) AS max_eta
FROM food_delivery_final;

-- Which numerical factors relate most strongly to delivery time?
SELECT
    prep_time_group,
    ROUND(AVG(restaurant_preparation_time_minutes), 2) AS avg_prep_time,
    ROUND(AVG(actual_delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY prep_time_group
ORDER BY avg_prep_time;

-- Does restaurant preparation time relate to ETA?
SELECT
    prep_time_group,
    ROUND(AVG(restaurant_preparation_time_minutes), 2) AS avg_prep_time,
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta
FROM food_delivery_final
GROUP BY prep_time_group
ORDER BY avg_prep_time;

-- Does driver experience relate to ETA?
SELECT
    driver_experience_group,
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta
FROM food_delivery_final
GROUP BY driver_experience_group
ORDER BY avg_eta DESC;

-- Which orders have unusually high delivery times?
WITH quartiles AS (
    SELECT
        PERCENT_RANK() OVER (
            ORDER BY actual_delivery_time_minutes
        ) AS percentile_rank,
        actual_delivery_time_minutes
    FROM food_delivery_final
    WHERE order_status = 'Completed'
)
SELECT
    ROUND(MIN(CASE WHEN percentile_rank >= 0.25 THEN actual_delivery_time_minutes END), 2) AS q1,
    ROUND(MIN(CASE WHEN percentile_rank >= 0.75 THEN actual_delivery_time_minutes END), 2) AS q3
FROM quartiles;

SELECT
    order_id,
    actual_delivery_time_minutes,
    estimated_delivery_time_minutes,
    delay_minutes
FROM food_delivery_final
WHERE order_status = 'Completed'
  AND actual_delivery_time_minutes > (43 + 1.5 * (43 - 26))
ORDER BY actual_delivery_time_minutes DESC;

-- The total order value is 1908475.05 , and the average order value is 38.17
-- The customer segment contributing the highest order value is 994353.11
-- The discount group with the highest average order value is 0-5%
-- The overall average ETA is 30.95 minutes.
-- Restaurant preparation time shows a positive relationship with ETA.
-- The driver experience group with the highest average ETA is 13-24 Months


-- RELATIONAL DATABASE DESIGN & JOINs

USE fda_12;

-- create customers table
CREATE TABLE customers AS
SELECT
    customer_id,
    MAX(customer_age) AS customer_age,
    MAX(customer_type) AS customer_type
FROM food_delivery_final
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

-- create  restaurants table
CREATE TABLE restaurants AS
SELECT
    restaurant_id,
    MAX(restaurant_primary_category) AS cuisine,
    ROUND(AVG(restaurant_rating), 2) AS restaurant_rating
FROM food_delivery_final
WHERE restaurant_id IS NOT NULL
GROUP BY restaurant_id;

-- create drivers table
CREATE TABLE drivers AS
SELECT
    driver_id,
    MAX(driver_experience_group) AS experience_group,
    ROUND(AVG(delivery_partner_rating), 2) AS avg_driver_rating
FROM food_delivery_final
WHERE driver_id IS NOT NULL
GROUP BY driver_id;

-- create orders table
CREATE TABLE orders AS
SELECT
    order_id,
    customer_id,
    restaurant_id,
    driver_id,
    order_total,
    order_status,
    estimated_delivery_time_minutes AS eta,
    actual_delivery_time_minutes AS delivery_time,
    is_delayed,
    traffic_level,
    weather
FROM food_delivery_final;


-- Validating relational databases
SELECT 'Customers' AS table_name, COUNT(*) AS total FROM customers
UNION ALL
SELECT 'Restaurants', COUNT(*) FROM restaurants
UNION ALL
SELECT 'Drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders;

-- adding primary keys
SELECT COUNT(*) AS missing_order_ids
FROM orders
WHERE order_id IS NULL;

USE fda_12;

ALTER TABLE customers
MODIFY customer_id VARCHAR(50) NOT NULL;

ALTER TABLE restaurants
MODIFY restaurant_id VARCHAR(50) NOT NULL;

ALTER TABLE drivers
MODIFY driver_id VARCHAR(50) NOT NULL;

ALTER TABLE orders
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE restaurants
ADD PRIMARY KEY (restaurant_id);

ALTER TABLE drivers
ADD PRIMARY KEY (driver_id);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

SHOW INDEX FROM customers;
SHOW INDEX FROM restaurants;
SHOW INDEX FROM drivers;
SHOW INDEX FROM orders;

SELECT
    table_name,
    column_name
FROM information_schema.key_column_usage
WHERE table_schema = 'fda_12'
  AND constraint_name = 'PRIMARY';
  
  ALTER TABLE orders
MODIFY customer_id VARCHAR(50),
MODIFY restaurant_id VARCHAR(50),
MODIFY driver_id VARCHAR(50);



SHOW INDEX FROM customers;
SHOW INDEX FROM restaurants;
SHOW INDEX FROM drivers;


SELECT
    table_name,
    column_name,
    constraint_name AS key_name
FROM information_schema.key_column_usage
WHERE table_schema = 'fda_12'
  AND constraint_name = 'PRIMARY'
  AND table_name IN ('customers', 'restaurants', 'drivers');
  
  ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_restaurant
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id);

SELECT
    column_name,
    referenced_table_name
FROM information_schema.key_column_usage
WHERE table_schema = 'fda_12'
  AND table_name = 'orders'
  AND referenced_table_name IS NOT NULL;
  
  -- Orders by Customer Type
  SELECT
    c.customer_type,
    COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY total_orders DESC;

-- Top 10 Customers by Order Value
SELECT
    c.customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(o.order_total), 2) AS total_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_order_value DESC
LIMIT 10;

-- Order Value by Cuisine
SELECT
    r.cuisine,
    COUNT(*) AS total_orders,
    ROUND(SUM(o.order_total), 2) AS total_order_value
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine
ORDER BY total_order_value DESC;

-- Driver Performance
SELECT
    d.experience_group,
    COUNT(*) AS completed_orders,
    ROUND(AVG(o.delivery_time), 2) AS avg_delivery_time,
    ROUND(AVG(o.is_delayed) * 100, 2) AS delay_rate_pct
FROM orders o
JOIN drivers d ON o.driver_id = d.driver_id
WHERE o.order_status = 'Completed'
GROUP BY d.experience_group
ORDER BY delay_rate_pct;

-- Restaurant Performance
SELECT
    r.restaurant_id,
    r.cuisine,
    r.restaurant_rating,
    COUNT(*) AS completed_orders,
    ROUND(AVG(o.delivery_time), 2) AS avg_delivery_time
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Completed'
GROUP BY r.restaurant_id, r.cuisine, r.restaurant_rating
ORDER BY avg_delivery_time DESC
LIMIT 10;


-- ADVANCED BUSINESS ANALYSIS



USE fda_12;

-- Top 5 restaurants by order value — CTE
WITH restaurant_sales AS (
    SELECT
        restaurant_id,
        COUNT(*) AS total_orders,
        ROUND(SUM(order_total), 2) AS total_order_value
    FROM orders
    GROUP BY restaurant_id
)
SELECT *
FROM restaurant_sales
ORDER BY total_order_value DESC
LIMIT 5;

-- Customers spending above the average — Subquery
SELECT
    customer_id,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM orders
GROUP BY customer_id
HAVING AVG(order_total) >
    (SELECT AVG(order_total) FROM orders)
ORDER BY avg_order_value DESC;

-- High-volume restaurants — HAVING
SELECT
    restaurant_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_total), 2) AS total_order_value
FROM orders
GROUP BY restaurant_id
HAVING COUNT(*) > 200
ORDER BY total_orders DESC;

-- Rank restaurants by order value — RANK()
SELECT
    restaurant_id,
    ROUND(SUM(order_total), 2) AS total_order_value,
    RANK() OVER (
        ORDER BY SUM(order_total) DESC
    ) AS restaurant_rank
FROM orders
GROUP BY restaurant_id;

-- Delivery delay risk by traffic and weather — CASE
SELECT
    traffic_level,
    weather,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN is_delayed = 1 THEN 1 ELSE 0 END) AS delayed_orders,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final
WHERE order_status = 'Completed'
GROUP BY traffic_level, weather
ORDER BY delay_rate_pct DESC;



-- FINAL VALIDATION & BUSINESS INSIGHTS



-- Final Database Validation
USE fda_12;
SELECT 'Orders' AS table_name, COUNT(*) AS records FROM orders
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Restaurants', COUNT(*) FROM restaurants
UNION ALL
SELECT 'Drivers', COUNT(*) FROM drivers;


SELECT
    table_name,
    column_name,
    constraint_name,
    referenced_table_name
FROM information_schema.key_column_usage
WHERE table_schema = 'fda_12'
  AND (constraint_name = 'PRIMARY'
       OR referenced_table_name IS NOT NULL);
       
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(actual_delivery_time_minutes IS NULL) AS missing_delivery_times
FROM food_delivery_final
GROUP BY order_status;


-- Validate JOIN Results
SELECT
    COUNT(*) AS joined_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
JOIN drivers d ON o.driver_id = d.driver_id;


SELECT
    (SELECT ROUND(SUM(order_total), 2)
     FROM food_delivery_final) AS original_total,

    (SELECT ROUND(SUM(order_total), 2)
     FROM orders) AS relational_total;

-- Final Business KPI Summary
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT restaurant_id) AS restaurants,
    COUNT(DISTINCT driver_id) AS drivers,
    ROUND(SUM(order_total), 2) AS total_order_value,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(AVG(estimated_delivery_time_minutes), 2) AS avg_eta,
    ROUND(AVG(is_delayed) * 100, 2) AS delay_rate_pct
FROM food_delivery_final;

