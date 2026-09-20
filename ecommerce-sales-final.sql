/*
===============================================================================
PROJECT: E-Commerce Sales & Customer Analytics
DATABASE: PostgreSQL
AUTHOR: Shamim Alam
PURPOSE:
    End-to-end SQL portfolio project covering:
    1. Data exploration
    2. Data cleaning
    3. Data validation
    4. KPI analysis
    5. Category, region, segment and channel analysis
    6. Advanced SQL (CTE, subqueries, window functions)
    7. Date-wise and customer-level analysis
    8. Business insights for Power BI / portfolio presentation

IMPORTANT EXECUTION NOTES:
    - Run SELECT queries first and review the result before UPDATE/DELETE.
    - The original learning queries are preserved below.
    - Do not execute both duplicate-removal DELETE methods; choose one.
    - Take a database backup before modifying production data.
    - The script assumes the table name is: ecommerce_sales
===============================================================================
*/

-- ============================================================================
-- SECTION 0: PROJECT QUICK PROFILE
-- ============================================================================

-- Main columns used in this project:
-- order_id, order_date, customer_id, customer_name, segment, category,
-- product, region, sales_channel, quantity, unit_price, discount,
-- sales, cost, profit

-- Start here to confirm the database and preview the data:
SELECT current_database() AS database_name, CURRENT_DATE AS run_date;

SELECT *
FROM ecommerce_sales
LIMIT 10;

-- ============================================================================
-- SECTION 1-5: ORIGINAL LEARNING QUERIES
-- The original queries are retained to preserve your practice and progress.
-- ============================================================================


-- E-commerce Sales & Customer Analytics
-- A practical PostgreSQL project for data cleaning, analysis, and business insights

-- Phase 1: Get familiar with the data

-- Q1. Check the number of rows in the table

SELECT COUNT(*) AS total_records
FROM ecommerce_sales;


-- Q2. Take a quick look at the first 10 rows

SELECT *
FROM ecommerce_sales
LIMIT 10;


-- Q3. Count the unique customers

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM ecommerce_sales;

-- Q4. How many product categories are available in the dataset?
SELECT DISTINCT category
FROM ecommerce_sales;


SELECT COUNT(DISTINCT category) AS total_categories
FROM ecommerce_sales;

-- Q5. List the different regions available in the dataset?
SELECT DISTINCT region
FROM ecommerce_sales;

-- Q6. List the different customer segments available in the dataset?
SELECT DISTINCT segment
FROM ecommerce_sales;


-- =====================================================
-- Phase 2: Clean the data carefully
-- =====================================================
-- Q7. Check missing values across the columns

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(order_date) AS missing_order_date,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(customer_name) AS missing_customer_name,
    COUNT(*) - COUNT(segment) AS missing_segment,
    COUNT(*) - COUNT(category) AS missing_category,
    COUNT(*) - COUNT(product) AS missing_product,
    COUNT(*) - COUNT(region) AS missing_region,
    COUNT(*) - COUNT(sales_channel) AS missing_sales_channel,
    COUNT(*) - COUNT(quantity) AS missing_quantity,
    COUNT(*) - COUNT(unit_price) AS missing_unit_price,
    COUNT(*) - COUNT(discount) AS missing_discount,
    COUNT(*) - COUNT(sales) AS missing_sales,
    COUNT(*) - COUNT(cost) AS missing_cost,
    COUNT(*) - COUNT(profit) AS missing_profit
FROM ecommerce_sales;

-- Q8. Find the rows that contain missing values

SELECT *
FROM ecommerce_sales
WHERE customer_name IS NULL
   OR region IS NULL
   OR discount IS NULL;


-- Q9. Find the missing customer's name using customer_id

SELECT DISTINCT
    customer_id,
    customer_name
FROM ecommerce_sales
WHERE customer_id = 'CUST-0082'
  AND customer_name IS NOT NULL;

  -- Q10. Find the missing customer's region using customer_id

SELECT DISTINCT
    customer_id,
    region
FROM ecommerce_sales
WHERE customer_id = 'CUST-0121'
  AND region IS NOT NULL;

  -- Q11. Analyze discount values for the same product

SELECT
    product,
    discount,
    COUNT(*) AS total_orders
FROM ecommerce_sales
WHERE product = 'Cookware Set'
GROUP BY product, discount
ORDER BY discount;

-- Q12. Update the missing customer name

UPDATE ecommerce_sales
SET customer_name = 'Customer 0082'
WHERE customer_id = 'CUST-0082'
  AND customer_name IS NULL;

-- Q13. Update the missing region

UPDATE ecommerce_sales
SET region = 'East'
WHERE customer_id = 'CUST-0121'
  AND region IS NULL;

-- The discount value is missing, so it was kept as NULL.
-- No value was added because the actual discount is unknown.


-- Q14. Check whether any order_id appears more than once

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM ecommerce_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Q15. Review the duplicate rows before removing anything

SELECT *
FROM ecommerce_sales
WHERE order_id IN (
    'ORD-10101',
    'ORD-10201',
    'ORD-10301'
)
ORDER BY order_id;

-- Q16. Remove duplicates and keep one row for each order_id
DELETE FROM ecommerce_sales
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM ecommerce_sales
    GROUP BY
        order_id,
        order_date,
        customer_id,
        customer_name,
        segment,
        category,
        product,
        region,
        sales_channel,
        quantity,
        unit_price,
        discount,
        sales,
        cost,
        profit
);

-- Alternative duplicate-removal approach using a CTE (use only one method)

WITH duplicate_rows AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY
                order_id,
                order_date,
                customer_id,
                customer_name,
                segment,
                category,
                product,
                region,
                sales_channel,
                quantity,
                unit_price,
                discount,
                sales,
                cost,
                profit
            ORDER BY ctid
        ) AS row_num
    FROM ecommerce_sales
)

DELETE FROM ecommerce_sales
WHERE ctid IN (
    SELECT ctid
    FROM duplicate_rows
    WHERE row_num > 1
);

-- Q17. Confirm that duplicate order_ids are gone

SELECT
    order_id,
    COUNT(*) AS record_count
FROM ecommerce_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Q18. Check the row count after cleaning

SELECT COUNT(*) AS total_records
FROM ecommerce_sales;

-- =====================================================
-- Quick data validation checks
-- =====================================================

-- Q19. Check for invalid quantity values

SELECT *
FROM ecommerce_sales
WHERE quantity <= 0;

-- Q20. Check for negative sales values

SELECT *
FROM ecommerce_sales
WHERE sales < 0;

-- Q21. Check for negative cost values

SELECT *
FROM ecommerce_sales
WHERE cost < 0;

-- Q22. Check for invalid discount values

SELECT *
FROM ecommerce_sales
WHERE discount < 0
   OR discount > 0.20;

-- Q23. Calculate the total number of orders

SELECT COUNT(order_id) AS total_orders
FROM ecommerce_sales;

-- Q24. Calculate total sales

SELECT SUM(sales) AS total_sales
FROM ecommerce_sales;

-- Q25. Calculate total profit

SELECT SUM(profit) AS total_profit
FROM ecommerce_sales;

-- Q26. Find the average sales per order

SELECT  round(AVG(sales),2) AS average_sales
FROM ecommerce_sales;

-- Q27. Find the average profit per order

SELECT AVG(profit) AS average_profit
FROM ecommerce_sales;

-- Q28. Check the highest and lowest order sales

SELECT
    MAX(sales) AS highest_sales,
    MIN(sales) AS lowest_sales
FROM ecommerce_sales;

-- Q29. Check the highest and lowest order profit

SELECT
    MAX(profit) AS highest_profit,
    MIN(profit) AS lowest_profit
FROM ecommerce_sales;

-- Q30. Add up the total quantity sold

SELECT SUM(quantity) AS total_quantity_sold
FROM ecommerce_sales;

-- =====================================================
-- Phase 4: Summarize the data with GROUP BY
-- =====================================================

-- Q31. What is the total sales by category?

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q32. What is the total profit by category?

SELECT
    category,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY category
ORDER BY total_profit DESC;

-- Q33. What is the total quantity sold by category?

SELECT
    category,
    SUM(quantity) AS total_quantity_sold
FROM ecommerce_sales
GROUP BY category
ORDER BY total_quantity_sold DESC;

-- Q34. What is the total sales by region?

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;


-- Q35. What is the total profit by region?

SELECT
    region,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY region
ORDER BY total_profit DESC;

-- Q36. What is the sales performance by customer segment?

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY segment
ORDER BY total_sales DESC;

-- Q37. What is the sales performance by sales channel?

SELECT
    sales_channel,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY sales_channel
ORDER BY total_sales DESC;

-- =====================================================
-- Phase 5: Filter grouped results with HAVING
-- =====================================================

-- Q38. Which categories have total sales greater than 100,000?

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY category
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC;

-- Q39. Which regions have more than 350 orders?

SELECT
    region,
    COUNT(order_id) AS total_orders
FROM ecommerce_sales
GROUP BY region
HAVING COUNT(order_id) > 350
ORDER BY total_orders DESC;

-- Q40. Which products have generated total profit greater than 10,000?

SELECT
    product,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY product
HAVING SUM(profit) > 10000
ORDER BY total_profit DESC;

-- Q41. Group orders into profit categories
-- Profit >= 500: High Profit
-- Profit >= 100: Medium Profit
-- Otherwise: Low Profit

SELECT
    order_id,
    profit,
    CASE
        WHEN profit >= 500 THEN 'High Profit'
        WHEN profit >= 100 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS profit_category
FROM ecommerce_sales;

-- Q42. See how much sales comes from each profit category
-- Profit >= 500: High Profit
-- Profit >= 100: Medium Profit
-- Otherwise: Low Profit

SELECT
    CASE
        WHEN profit >= 500 THEN 'High Profit'
        WHEN profit >= 100 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS profit_category,
    SUM(sales) AS total_sales
FROM ecommerce_sales
GROUP BY
    CASE
        WHEN profit >= 500 THEN 'High Profit'
        WHEN profit >= 100 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END;

-- Q43. Calculate the profit margin

SELECT
    order_id,
    sales,
    profit,
    (profit / sales) * 100 AS profit_margin,

    CASE
        WHEN (profit / sales) * 100 >= 30 THEN 'Excellent'
        WHEN (profit / sales) * 100 >= 15 THEN 'Good'
        WHEN (profit / sales) * 100 >= 5 THEN 'Average'
        ELSE 'Low'
    END AS margin_category

FROM ecommerce_sales;

-- Q44. Group orders by discount level and calculate sales
-- Discount >= 20%: High Discount
-- Discount >= 10%: Medium Discount
-- Otherwise: Low Discount

SELECT
    CASE
        WHEN discount >= 0.20 THEN 'High Discount'
        WHEN discount >= 0.10 THEN 'Medium Discount'
        ELSE 'Low Discount'
    END AS discount_category,
    SUM(sales) AS total_sales
FROM ecommerce_sales
GROUP BY
    CASE
        WHEN discount >= 0.20 THEN 'High Discount'
        WHEN discount >= 0.10 THEN 'Medium Discount'
        ELSE 'Low Discount'
    END;

-- Q45. Count profitable orders by region
-- An order is considered profitable when its profit margin is 15% or higher.

SELECT
    region,
    COUNT(
        CASE
            WHEN (profit / sales) * 100 >= 15 THEN 1
        END
    ) AS profitable_orders
FROM ecommerce_sales
GROUP BY region;

-- Q45. Compare profitable and unprofitable orders by region
-- An order is profitable when its profit margin is 15% or higher.

SELECT
    region,

    COUNT(
        CASE
            WHEN (profit / sales) * 100 >= 15 THEN 1
        END
    ) AS profitable_orders,

    COUNT(
        CASE
            WHEN (profit / sales) * 100 < 15 THEN 1
        END
    ) AS unprofitable_orders

FROM ecommerce_sales
GROUP BY region;


-- Q46. Compare sales and profit across sales channels
-- Then classify each sales channel based on its total profit.
-- Total Profit >= 50000: High Profit
-- Total Profit >= 20000: Medium Profit
-- Otherwise: Low Profit

SELECT
    sales_channel,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    CASE
        WHEN SUM(profit) >= 50000 THEN 'High Profit'
        WHEN SUM(profit) >= 20000 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS profit_category
FROM ecommerce_sales
GROUP BY sales_channel;

-- Q47. Compare the average profit margin across regions
-- Then classify each region based on its average profit margin.
-- Average Profit Margin >= 25%: Excellent
-- Average Profit Margin >= 15%: Good
-- Otherwise: Needs Improvement

SELECT
    region,
    ROUND(AVG((profit / sales) * 100), 2) AS avg_profit_margin,
    CASE
        WHEN AVG((profit / sales) * 100) >= 25 THEN 'Excellent'
        WHEN AVG((profit / sales) * 100) >= 15 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM ecommerce_sales
GROUP BY region;

-- Q48. Find orders with sales above the overall average

SELECT
    order_id,
    sales,
    category,
    region
FROM ecommerce_sales
WHERE sales > (
    SELECT AVG(sales)
    FROM ecommerce_sales
);

-- Q49. Find products with sales above the average for their category
-- within the same category.

SELECT
    order_id,
    category,
    sales,
    profit
FROM ecommerce_sales AS e
WHERE sales > (
    SELECT AVG(sales)
    FROM ecommerce_sales
    WHERE category = e.category
);

-- Q50. Show categories whose total sales are above the average category sales
-- and show only categories whose total sales are higher than
-- the average category sales.

WITH category_sales AS (
    SELECT
        category,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY category
)
SELECT
    category,
    total_sales
FROM category_sales
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM category_sales
);

-- Q51. Find the region with the highest total profit
-- Then show only the region with the highest total profit.

WITH region_performance AS (
    SELECT
        region,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM ecommerce_sales
    GROUP BY region
)
SELECT
    region,
    total_sales,
    total_profit
FROM region_performance
WHERE total_profit = (
    SELECT MAX(total_profit)
    FROM region_performance
);


-- Advanced analysis using CTEs, subqueries, and window functions
----------
-- Find the top 3 products in each category based on total sales.

WITH product_ranking AS (

    SELECT
        category,
        product,
        SUM(sales) AS total_sales,

        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS product_rank

    FROM ecommerce_sales

    GROUP BY category, product
)

SELECT
    category,
    product,
    total_sales,
    product_rank
FROM product_ranking
WHERE product_rank <= 3
ORDER BY category, product_rank;


-- Compare each product's total sales with the average product sales in its category.
--
-- Also identify the highest-sales product in each category.

WITH product_sales AS (
    SELECT
        category,
        product,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY category, product
)

SELECT
    category,
    product,
    total_sales,

    ROUND(
        AVG(total_sales) OVER (
            PARTITION BY category
        ),
        2
    ) AS category_avg_sales,

    ROUND(
        total_sales
        - AVG(total_sales) OVER (
            PARTITION BY category
        ),
        2
    ) AS difference_from_average,

    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_sales DESC
    ) AS product_rank

FROM product_sales

ORDER BY category, product_rank;


-- Calculate product-level profit within each region and rank the products.
--
-- Show how each product compares with the regional average product profit.

WITH product_profit AS (
    SELECT
        region,
        product,
        SUM(profit) AS total_profit
    FROM ecommerce_sales
    GROUP BY region, product
)

SELECT
    region,
    product,
    total_profit,

    ROUND(
        AVG(total_profit) OVER (
            PARTITION BY region
        ),
        2
    ) AS average_region_profit,

    ROUND(
        total_profit
        - AVG(total_profit) OVER (
            PARTITION BY region
        ),
        2
    ) AS profit_difference,

    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_rank

FROM product_profit

ORDER BY region, profit_rank;

--- Date-wise analysis
-- Total sales by year 
SELECT DISTINCT
    EXTRACT(YEAR FROM order_date) AS year
FROM ecommerce_sales
ORDER BY year;

--- Year-wise total sales
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

-- Find the month with the highest sales in each year.

WITH monthly_sales AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
),

ranked_months AS (
    SELECT
        year,
        month,
        TO_CHAR(
            TO_DATE(month::text, 'MM'),
            'Month'
        ) AS month_name,
        ROUND(total_sales, 2) AS total_sales,
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales
)

SELECT
    year,
    TRIM(month_name) AS month,
    total_sales
FROM ranked_months
WHERE sales_rank = 1
ORDER BY year;

-- ============================================================================
-- Section 6: Additional data quality checks
-- ============================================================================

-- Q52. Check whether order_id is unique.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_order_ids,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_id_difference
FROM ecommerce_sales;

-- Q53. Check business-rule violations in one summary.
SELECT
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantity_rows,
    COUNT(*) FILTER (WHERE sales < 0) AS negative_sales_rows,
    COUNT(*) FILTER (WHERE cost < 0) AS negative_cost_rows,
    COUNT(*) FILTER (WHERE profit < 0) AS negative_profit_rows,
    COUNT(*) FILTER (WHERE discount < 0 OR discount > 0.20) AS invalid_discount_rows,
    COUNT(*) FILTER (WHERE sales = 0) AS zero_sales_rows
FROM ecommerce_sales;

-- Q54. Validate the basic financial relationship: sales - cost = profit.
SELECT
    COUNT(*) AS inconsistent_profit_rows
FROM ecommerce_sales
WHERE ROUND(sales - cost, 2) <> ROUND(profit, 2);

-- Q55. Check whether sales is reasonably aligned with quantity and unit price.
-- This is a diagnostic check because discount/business rules may affect sales.
SELECT
    order_id,
    quantity,
    unit_price,
    discount,
    sales,
    ROUND(quantity * unit_price * (1 - COALESCE(discount, 0)), 2) AS estimated_sales
FROM ecommerce_sales
WHERE ABS(
    sales - (quantity * unit_price * (1 - COALESCE(discount, 0)))
) > 0.05
ORDER BY order_id;

-- ============================================================================
-- Section 7: Core business KPIs
-- ============================================================================

-- Q56. Executive KPI summary.
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product) AS unique_products,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT region) AS total_regions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS overall_profit_margin,
    ROUND(AVG(sales), 2) AS average_order_value,
    SUM(quantity) AS total_quantity_sold
FROM ecommerce_sales;

-- Q57. KPI summary by year.
SELECT
    EXTRACT(YEAR FROM order_date)::INT AS year,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

-- Q58. KPI summary by month.
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month_start,
    TO_CHAR(DATE_TRUNC('month', order_date), 'Mon YYYY') AS month_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month_start;

-- ============================================================================
-- Section 8: Customer-level analysis
-- ============================================================================

-- Q59. Customer-level performance.
SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS average_order_value
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q60. Top 10 customers by sales.
SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

-- Q61. Repeat customers (more than one order).
SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC, total_sales DESC;

-- Q62. Customer concentration: contribution of each customer to total sales.
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        total_sales / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS sales_contribution_pct
FROM customer_sales
ORDER BY total_sales DESC;

-- ============================================================================
-- SECTION 9: PRODUCT & CATEGORY ANALYTICS
-- ============================================================================

-- Q63. Product performance with margin.
SELECT
    category,
    product,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY category, product
ORDER BY total_sales DESC;

-- Q64. Top 3 products in every category (ROW_NUMBER gives exactly 3 rows
-- where enough products exist; RANK may return ties).
WITH product_summary AS (
    SELECT
        category,
        product,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY category, product
),
ranked_products AS (
    SELECT
        category,
        product,
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC, product
        ) AS product_rank
    FROM product_summary
)
SELECT
    category,
    product,
    ROUND(total_sales, 2) AS total_sales,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY category, product_rank;

-- Q65. Highest-margin products with a minimum order threshold.
SELECT
    category,
    product,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY category, product
HAVING COUNT(*) >= 10
ORDER BY profit_margin DESC;

-- Q66. Category contribution to total sales.
WITH category_summary AS (
    SELECT category, SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY category
)
SELECT
    category,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        total_sales / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS sales_contribution_pct
FROM category_summary
ORDER BY total_sales DESC;

-- ============================================================================
-- SECTION 10: REGION, SEGMENT & CHANNEL ANALYSIS
-- ============================================================================

-- Q67. Region performance with order share and margin.
SELECT
    region,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin,
    ROUND(
        COUNT(*)::NUMERIC / NULLIF(SUM(COUNT(*)) OVER (), 0) * 100,
        2
    ) AS order_share_pct
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;

-- Q68. Segment performance.
SELECT
    segment,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY segment
ORDER BY total_sales DESC;

-- Q69. Sales channel performance.
SELECT
    sales_channel,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin,
    ROUND(AVG(sales), 2) AS average_order_value
FROM ecommerce_sales
GROUP BY sales_channel
ORDER BY total_sales DESC;

-- Q70. Region x category performance matrix.
SELECT
    region,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS total_orders
FROM ecommerce_sales
GROUP BY region, category
ORDER BY region, total_sales DESC;

-- ============================================================================
-- SECTION 11: TIME-SERIES & GROWTH ANALYSIS
-- ============================================================================

-- Q71. Monthly sales with previous month comparison.
WITH monthly_summary AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month_start,
        SUM(sales) AS total_sales
    FROM ecommerce_sales
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month_start,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        LAG(total_sales) OVER (ORDER BY month_start),
        2
    ) AS previous_month_sales,
    ROUND(
        (
            total_sales - LAG(total_sales) OVER (ORDER BY month_start)
        ) / NULLIF(LAG(total_sales) OVER (ORDER BY month_start), 0) * 100,
        2
    ) AS month_over_month_growth_pct
FROM monthly_summary
ORDER BY month_start;

-- Q72. Year-over-year comparison.
WITH yearly_summary AS (
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM ecommerce_sales
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(LAG(total_sales) OVER (ORDER BY year), 2) AS previous_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year))
        / NULLIF(LAG(total_sales) OVER (ORDER BY year), 0) * 100,
        2
    ) AS yoy_sales_growth_pct,
    ROUND(total_profit, 2) AS total_profit
FROM yearly_summary
ORDER BY year;

-- Q73. Best-performing month overall.
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month_start,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY total_sales DESC
LIMIT 1;

-- ============================================================================
-- SECTION 12: DISCOUNT & PROFITABILITY ANALYSIS
-- ============================================================================

-- Q74. Discount band performance.
SELECT
    CASE
        WHEN discount IS NULL THEN 'Unknown'
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.15 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_band,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
GROUP BY 1
ORDER BY total_sales DESC;

-- Q75. Orders with low profit margin.
SELECT
    order_id,
    category,
    product,
    sales,
    profit,
    ROUND(profit / NULLIF(sales, 0) * 100, 2) AS profit_margin
FROM ecommerce_sales
WHERE profit / NULLIF(sales, 0) * 100 < 10
ORDER BY profit_margin;

-- Q76. Profitability classification by order.
SELECT
    order_id,
    sales,
    profit,
    ROUND(profit / NULLIF(sales, 0) * 100, 2) AS profit_margin,
    CASE
        WHEN profit / NULLIF(sales, 0) * 100 >= 30 THEN 'Excellent'
        WHEN profit / NULLIF(sales, 0) * 100 >= 15 THEN 'Good'
        WHEN profit / NULLIF(sales, 0) * 100 >= 5 THEN 'Average'
        ELSE 'Low'
    END AS margin_category
FROM ecommerce_sales
ORDER BY profit_margin DESC;

-- ============================================================================
-- Section 13: Queries that support business insights
-- ============================================================================

-- Q77. Top category by sales.
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

-- Q78. Top region by profit.
SELECT
    region,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY region
ORDER BY total_profit DESC
LIMIT 1;

-- Q79. Top product by sales.
SELECT
    product,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY product
ORDER BY total_sales DESC
LIMIT 1;

-- Q80. Channel with the highest average order value.
SELECT
    sales_channel,
    ROUND(AVG(sales), 2) AS average_order_value
FROM ecommerce_sales
GROUP BY sales_channel
ORDER BY average_order_value DESC
LIMIT 1;

-- ============================================================================
-- SECTION 14: BUSINESS INSIGHTS (BASED ON THE PROVIDED CSV SNAPSHOT)
-- ============================================================================

/*
DATASET SNAPSHOT
----------------
- Raw rows: 1,503
- Columns: 15
- Missing values found:
    customer_name: 1
    region: 1
    discount: 1
- Duplicate order_id rows found: 3
- Total sales in the raw CSV snapshot: 1,169,025.67
- Total profit in the raw CSV snapshot: 324,811.28
- Overall profit margin in the raw CSV snapshot: approximately 27.78%

KEY OBSERVATIONS
----------------
1. Electronics generated the highest category sales in the provided snapshot.
2. West generated the highest regional sales and regional profit.
3. Online, Retail Store and Marketplace were relatively close in total sales,
   so channel-level margin and average order value should be compared together.
4. Laptop was the highest-sales product in the provided product summary.
5. The year-level comparison should be interpreted carefully because the
   dataset contains only the available dates in the CSV, not a guaranteed
   complete calendar year.
6. NULL discount values were kept as unknown rather than assuming zero discount.
7. Duplicate records should be removed only after confirming whether they are
   true duplicates or legitimate repeated orders.

*/

-- ============================================================================
-- END OF PROJECT
-- ============================================================================
