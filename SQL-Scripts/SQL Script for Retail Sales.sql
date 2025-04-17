DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
  transaction_id TEXT,
  date DATE,
  customer_id TEXT,
  gender TEXT,
  age INTEGER,
  product_category TEXT,
  quantity INTEGER,
  price_per_unit FLOAT,
  total_amount FLOAT
);

\COPY retail_sales FROM 'C:/Users/........./Retail Sales Dataset/retail_sales_dataset.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM retail_sales;

-- Quick look at record count and structure after cleaning th data
SELECT COUNT(*) FROM retail_sales;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'retail_sales';


SALES ANALYSIS EXECUTION:

-- Monthly revenue with MoM/YoY growth  
WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC('month', date) AS month, 
    SUM(total_amount) AS revenue 
  FROM retail_sales 
  GROUP BY 1 
)
SELECT 
  TO_CHAR(month, 'YYYY-MM') AS period, 
  revenue, 
  ROUND((CAST(revenue AS numeric) - LAG(CAST(revenue AS numeric), 1) OVER (ORDER BY month)) / LAG(CAST(revenue AS numeric), 1) OVER () * 100, 2) AS mom_growth, 
  ROUND((CAST(revenue AS numeric) - LAG(CAST(revenue AS numeric), 12) OVER (ORDER BY month)) / LAG(CAST(revenue AS numeric), 12) OVER () * 100, 2) AS yoy_growth 
FROM monthly_sales;

-- Sales distribution by gender with category breakdown  
SELECT 
  gender, 
  product_category, 
  ROUND(CAST(SUM(total_amount) AS numeric), 2) AS revenue, 
  ROUND(CAST(SUM(total_amount) AS numeric) * 100.0 / SUM(CAST(SUM(total_amount) AS numeric)) OVER (PARTITION BY gender), 2) AS category_share 
FROM retail_sales 
GROUP BY 1, 2;

-- Sales by age groups  
SELECT  
  CASE  
    WHEN age < 20 THEN 'Teen'  
    WHEN age BETWEEN 20 AND 35 THEN 'Young Adults'  
    WHEN age BETWEEN 36 AND 50 THEN 'Adults'  
    ELSE 'Seniors'  
  END AS age_group,  
  SUM(total_amount) AS revenue  
FROM retail_sales  
GROUP BY 1;  

-- Top categories with quarterly ranking  
SELECT  
  product_category,  
  DATE_TRUNC('quarter', date) AS quarter,  
  SUM(total_amount) AS revenue,  
  RANK() OVER (PARTITION BY DATE_TRUNC('quarter', date) ORDER BY SUM(total_amount) DESC) AS rank  
FROM retail_sales  
GROUP BY 1, 2;  

-- Top 5% customers by lifetime value  
WITH customer_stats AS (  
  SELECT  
    customer_id,  
    SUM(total_amount) AS total_spend,  
    NTILE(20) OVER (ORDER BY SUM(total_amount) DESC) AS percentile  
  FROM retail_sales  
  GROUP BY 1  
)  
SELECT customer_id, total_spend  
FROM customer_stats  
WHERE percentile = 1;  

-- Quantity vs price correlation  
SELECT  
  product_category,  
  CORR(price_per_unit, quantity) AS price_quantity_corr  
FROM retail_sales  
GROUP BY 1;   

-- Monthly cohort retention  
WITH first_purchases AS (  
  SELECT  
    customer_id,  
    DATE_TRUNC('month', MIN(date)) AS cohort_month  
  FROM retail_sales  
  GROUP BY 1  
)  
SELECT  
  cohort_month,  
  DATE_TRUNC('month', date) AS order_month,  
  COUNT(DISTINCT rs.customer_id) AS retained_customers  
FROM retail_sales rs  
JOIN first_purchases fp USING(customer_id)  
GROUP BY 1, 2; 

-- Most popular categories by age group  
SELECT  
  age_group,  
  product_category,  
  SUM(total_amount) AS revenue  
FROM (  
  SELECT  
    CASE  
      WHEN age < 30 THEN 'Under 30'  
      ELSE '30+'  
    END AS age_group,  
    product_category,  
    total_amount  
  FROM retail_sales  
) sub  
GROUP BY 1, 2  
ORDER BY 1, 3 DESC;  

-- recency-frequency-monetary (RFM) analysis  
WITH rfm AS (
  SELECT
    customer_id,
    MAX(date) AS last_purchase,
    COUNT(*) AS frequency,
    SUM(total_amount) AS monetary
  FROM retail_sales
  GROUP BY 1
)
SELECT
  customer_id,
  NTILE(5) OVER (ORDER BY last_purchase) AS recency_score,
  NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
  NTILE(5) OVER (ORDER BY monetary) AS monetary_score
FROM rfm;

-- Compare price changes to quantity sold  
WITH price_changes AS (
  SELECT 
    product_category,
    date_trunc('month', date) AS month,
    AVG(price_per_unit) AS avg_price,
    SUM(quantity) AS total_units
  FROM retail_sales
  GROUP BY 1,2
)
SELECT
  product_category,
  CORR(avg_price, total_units) AS price_elasticity
FROM price_changes
GROUP BY 1;


SELECT * FROM retail_sales;