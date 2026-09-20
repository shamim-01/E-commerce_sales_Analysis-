
# 🛒 E-Commerce Sales & Business Analytics

![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/Main%20Focus-SQL-blue?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Visualization-Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Data Analysis](https://img.shields.io/badge/Project-Data%20Analytics-orange?style=for-the-badge)

## 📌 Project Overview

This project is an end-to-end **E-Commerce Sales & Business Analytics project** focused primarily on SQL-based data analysis using PostgreSQL.

The main objective was to explore, clean, validate, and analyze e-commerce sales data to identify meaningful business insights related to sales, profit, customers, products, regions, and sales channels.

**SQL was the primary focus of this project, while Power BI was used to visualize and present the analytical results through interactive dashboards.**

---

## 🎯 Project Objectives

- Perform data exploration using SQL.
- Clean and validate raw e-commerce data.
- Analyze sales and profit performance.
- Identify top-performing products and categories.
- Understand regional and customer segment performance.
- Analyze sales channel performance.
- Apply advanced SQL concepts for business analysis.
- Create interactive Power BI dashboards for data visualization.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Database management and SQL analysis |
| SQL | Data cleaning, transformation, and analysis |
| pgAdmin | SQL query execution |
| Power BI | Interactive dashboard and data visualization |
| Git & GitHub | Project documentation and version control |

---

## 📂 Dataset Information

The dataset contains e-commerce sales records with information about:

- Orders
- Customers
- Products
- Categories
- Regions
- Sales Channels
- Quantity
- Sales
- Cost
- Profit
- Discounts

### Main Columns

| Column | Description |
|---|---|
| `order_id` | Unique order identifier |
| `order_date` | Order date |
| `customer_id` | Customer identifier |
| `customer_name` | Customer name |
| `segment` | Customer segment |
| `category` | Product category |
| `product` | Product name |
| `region` | Sales region |
| `sales_channel` | Sales channel |
| `quantity` | Quantity sold |
| `unit_price` | Unit price |
| `discount` | Applied discount |
| `sales` | Total sales amount |
| `cost` | Product cost |
| `profit` | Generated profit |

---

## 🧹 Data Cleaning & Validation

Data cleaning and validation were performed using PostgreSQL.

### Data Quality Checks

- Checked missing values across important columns.
- Identified missing customer names.
- Identified missing region values.
- Analyzed missing discount values.
- Checked duplicate order records.
- Removed duplicate records while keeping one copy.
- Validated quantity values.
- Checked negative sales and cost values.
- Validated discount ranges.

### Data Correction Approach

- Updated missing customer information where reference data was available.
- Updated missing region information where reference data was available.
- Kept unknown discount values as `NULL` instead of making assumptions.
- Verified the dataset after cleaning.

---

## 📊 SQL Analysis

SQL was the **primary analytical component** of this project.

### 1. Exploratory Data Analysis

- Total number of records
- Unique customer count
- Available categories
- Available regions
- Customer segments
- Sales channels

### 2. Key Performance Indicators

Calculated the following business metrics:

- Total Orders
- Total Sales
- Total Profit
- Average Sales per Order
- Average Profit per Order
- Highest Sales Value
- Lowest Sales Value
- Highest Profit Value
- Lowest Profit Value
- Total Quantity Sold

### 3. Category Analysis

- Total sales by category
- Total profit by category
- Total quantity sold by category
- Categories exceeding a sales threshold

### 4. Regional Analysis

- Total sales by region
- Total profit by region
- Regional order count
- Profitable orders by region
- Average regional profit margin

### 5. Customer Analysis

- Customer-level order summary
- Total sales by customer
- Total profit by customer
- Average order value
- Customer performance comparison

### 6. Sales Channel Analysis

- Sales performance by sales channel
- Profit performance by sales channel
- Profit-based channel classification

### 7. Profit & Discount Analysis

Used `CASE` statements to:

- Categorize orders based on profit.
- Classify discount levels.
- Categorize profit margins.
- Identify profitable and unprofitable orders.

### 8. Advanced SQL Analysis

Applied advanced SQL concepts including:

- Common Table Expressions (CTEs)
- Subqueries
- Window Functions
- `RANK()`
- `ROW_NUMBER()`
- Category-level comparisons
- Product ranking
- Regional product profitability
- Yearly sales analysis
- Monthly sales analysis

---

## 🏆 Advanced SQL Example

### Top 3 Products in Each Category

```sql
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
````

### Business Purpose

This query identifies the top-performing products within each category based on total sales.

It helps businesses understand which products contribute most to category-level revenue.

## 📈 Power BI Dashboard

Power BI was used as a visualization and reporting tool after completing the SQL analysis.

### Dashboard Focus

* Sales Performance

* Profit Performance

* Category Analysis

* Regional Analysis

* Customer Segment Analysis

* Sales Channel Comparison

* Product Performance

* Business KPI Overview

### Dashboard Features

* Interactive visuals

* KPI cards

* Category-wise analysis

* Region-wise performance

* Sales and profit comparisons

* Business-focused insights

* User-friendly dashboard layout

> SQL was used for the core data analysis, while Power BI was used to communicate the findings visually.

## 🔍 Business Questions Answered

* What is the total sales and profit?

* Which category generates the highest sales?

* Which region generates the highest profit?

* Which customer segment performs better?

* Which sales channel generates more sales?

* Which products generate the highest profit?

* What are the top 3 products in each category?

* Which orders have sales above the average?

* Which region has the highest average profit margin?

* Which month generates the highest sales in each year?

## 🧠 SQL Concepts Practiced

* `SELECT`

* `WHERE`

* `GROUP BY`

* `HAVING`

* `ORDER BY`

* Aggregate Functions

* `COUNT()`

* `SUM()`

* `AVG()`

* `MIN()`

* `MAX()`

* `CASE`

* Subqueries

* CTEs

* Window Functions

* `RANK()`

* `ROW_NUMBER()`

* Date Functions

* Data Cleaning

* Data Validation


## 🚀 Key Learning Outcomes

Through this project, I developed practical experience in:

* Solving business problems using SQL.

* Cleaning and validating real-world-style datasets.

* Performing sales and profitability analysis.

* Writing structured and optimized SQL queries.

* Applying CTEs and window functions.

* Ranking products within categories and regions.

* Creating business-focused Power BI dashboards.

* Presenting analytical findings through data visualization.

## 🔮 Future Improvements

* Customer retention analysis

* Customer Lifetime Value analysis

* Monthly sales growth analysis

* Repeat customer analysis

* Profitability forecasting

* Advanced Power BI dashboard enhancements

* Automated data refresh and reporting

## 👨‍💻 Author

### Shamim Alam

Aspiring Data Analyst | SQL | PostgreSQL | Power BI

GitHub: [shamim-01](https://github.com/shamim-01) 

## ⭐ Project Highlights

* SQL-focused e-commerce data analysis

* PostgreSQL-based data cleaning and validation

* Advanced SQL business queries

* Product and regional performance analysis

* Power BI dashboard visualization

* Practical business-oriented analytics

⭐ If you find this project useful, feel free to explore the SQL queries and provide feedback.



