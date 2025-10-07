-- ------------------------------------------------------------
-- WALMART SALES ANALYSIS SQL SCRIPT (Beginner-Friendly)
-- ------------------------------------------------------------

-- 1. Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS walmartSales;
USE walmartSales;

-- 2. Create sales table
CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,   -- Unique invoice ID
    branch VARCHAR(5) NOT NULL,                   -- Branch code (A, B, C)
    city VARCHAR(30) NOT NULL,                    -- City of the branch
    customer_type VARCHAR(30) NOT NULL,           -- Customer type (Member / Normal)
    gender VARCHAR(30) NOT NULL,                  -- Customer gender
    product_line VARCHAR(100) NOT NULL,           -- Product category
    unit_price DECIMAL(10,2) NOT NULL,           -- Price per unit
    quantity INT NOT NULL,                        -- Number of units sold
    tax_pct FLOAT(6,4) NOT NULL,                 -- Tax percentage (VAT)
    total DECIMAL(12,4) NOT NULL,                -- Total sale amount (including tax)
    date DATETIME NOT NULL,                       -- Date of purchase
    time TIME NOT NULL,                           -- Time of purchase
    payment VARCHAR(15) NOT NULL,                -- Payment method
    cogs DECIMAL(10,2) NOT NULL,                 -- Cost of goods sold
    gross_margin_pct FLOAT(11,9),                -- Gross margin percentage
    gross_income DECIMAL(12,4),                  -- Profit for the sale
    rating FLOAT(2,1)                            -- Customer rating (1-10)
);

-- 3. Add feature columns for analysis
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);  -- Morning/Afternoon/Evening
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);     -- Day of the week
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);   -- Month name

-- 4. Update time_of_day based on time column
UPDATE sales
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- 5. Update day_name based on date column
UPDATE sales
SET day_name = DAYNAME(date);

-- 6. Update month_name based on date column
UPDATE sales
SET month_name = MONTHNAME(date);

-- 7. Generic Queries
-- List all unique cities
SELECT DISTINCT city FROM sales;

-- List branches and corresponding cities
SELECT DISTINCT branch, city FROM sales;

-- Count total records
SELECT COUNT(*) AS total_transactions FROM sales;

-- Count total branches and cities
SELECT COUNT(DISTINCT branch) AS total_branches, COUNT(DISTINCT city) AS total_cities FROM sales;

-- 8. Product Analysis
-- List all unique product lines
SELECT DISTINCT product_line FROM sales;

-- Most selling product line by quantity
SELECT product_line, SUM(quantity) AS total_sold
FROM sales
GROUP BY product_line
ORDER BY total_sold DESC;

-- Product line with highest revenue
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Product line with highest average rating
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Classify product lines as Good or Bad based on average quantity sold
SELECT product_line,
    CASE
        WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sales) THEN 'Good'
        ELSE 'Below Average'
    END AS performance
FROM sales
GROUP BY product_line;

-- Product line with highest average tax
SELECT product_line, ROUND(AVG(tax_pct),2) AS avg_vat
FROM sales
GROUP BY product_line
ORDER BY avg_vat DESC;

-- 9. Sales & Revenue Analysis
-- Total revenue by month
SELECT month_name, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- City with highest total revenue
SELECT city, branch, SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- Month with highest cost of goods sold
SELECT month_name, SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- Daily revenue trend
SELECT DATE(date) AS day, SUM(total) AS daily_revenue
FROM sales
GROUP BY day
ORDER BY day;

-- Branches selling above average quantity
SELECT branch, SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM sales);

-- 10. Customer Analysis
-- Unique customer types
SELECT DISTINCT customer_type FROM sales;

-- Unique payment methods
SELECT DISTINCT payment FROM sales;

-- Most common customer type
SELECT customer_type, COUNT(*) AS total_customers
FROM sales
GROUP BY customer_type
ORDER BY total_customers DESC;

-- Revenue by customer type
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Gender distribution
SELECT gender, COUNT(*) AS total_customers
FROM sales
GROUP BY gender
ORDER BY total_customers DESC;

-- Gender distribution per branch
SELECT branch, gender, COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch;

-- 11. Time-Based Analysis
-- Sales by time of day
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Average rating by time of day
SELECT time_of_day, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Best weekday by sales
SELECT day_name, COUNT(*) AS total_sales
FROM sales
GROUP BY day_name
ORDER BY total_sales DESC;

-- Best weekday by average rating
SELECT day_name, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Sales trend per branch per time_of_day
SELECT branch, time_of_day, COUNT(*) AS total_sales
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, total_sales DESC;

-- 12. Payment Analysis
-- Most used payment method
SELECT payment, COUNT(*) AS payment_count
FROM sales
GROUP BY payment
ORDER BY payment_count DESC;

-- Revenue by payment method
SELECT payment, SUM(total) AS total_revenue
FROM sales
GROUP BY payment
ORDER BY total_revenue DESC;

-- Average transaction amount by payment type
SELECT payment, ROUND(AVG(total),2) AS avg_transaction_value
FROM sales
GROUP BY payment
ORDER BY avg_transaction_value DESC;

-- 13. Profitability Analysis
-- Average gross margin per branch
SELECT branch, ROUND(AVG(gross_margin_pct),3) AS avg_margin
FROM sales
GROUP BY branch
ORDER BY avg_margin DESC;

-- Total gross income per month
SELECT month_name, SUM(gross_income) AS total_gross_income
FROM sales
GROUP BY month_name
ORDER BY total_gross_income DESC;

-- Most profitable branch
SELECT branch, SUM(gross_income) AS total_gross_income
FROM sales
GROUP BY branch
ORDER BY total_gross_income DESC;

-- Profit margin per product line
SELECT product_line, ROUND(SUM(gross_income)/SUM(cogs)*100,2) AS profit_margin_pct
FROM sales
GROUP BY product_line
ORDER BY profit_margin_pct DESC;

-- 14. Advanced Insights
-- Quantity vs Average Rating
SELECT CASE 
        WHEN quantity <= 3 THEN 'Low Quantity'
        WHEN quantity BETWEEN 4 AND 6 THEN 'Medium Quantity'
        ELSE 'High Quantity'
    END AS qty_level,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY qty_level
ORDER BY avg_rating DESC;

-- Average quantity by payment type
SELECT payment, ROUND(AVG(quantity),2) AS avg_quantity
FROM sales
GROUP BY payment
ORDER BY avg_quantity DESC;

-- City-wise peak selling time
SELECT city, time_of_day, COUNT(*) AS total_sales
FROM sales
GROUP BY city, time_of_day
ORDER BY city, total_sales DESC;

-- Top 5 invoices by total sale value
SELECT invoice_id, total, customer_type, city, payment
FROM sales
ORDER BY total DESC
LIMIT 5;

-- Monthly sales growth (using LAG function)
SELECT month_name,
       SUM(total) AS total_revenue,
       LAG(SUM(total)) OVER (ORDER BY MIN(date)) AS prev_month_revenue,
       SUM(total) - LAG(SUM(total)) OVER (ORDER BY MIN(date)) AS month_growth
FROM sales
GROUP BY month_name
ORDER BY MIN(date);

-- 15. Indexes for optimization (faster queries)
CREATE INDEX idx_city ON sales(city);
CREATE INDEX idx_product_line ON sales(product_line);
CREATE INDEX idx_customer_type ON sales(customer_type);
CREATE INDEX idx_date ON sales(date);
CREATE INDEX idx_time_of_day ON sales(time_of_day);

-- ------------------------------------------------------------
-- END OF WALMART SALES ANALYSIS SQL SCRIPT
-- ------------------------------------------------------------
