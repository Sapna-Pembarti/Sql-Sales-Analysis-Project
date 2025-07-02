# SQL Retail Sales Analysis Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_sales_project1 `

This project showcases essential SQL techniques used in real-world data analysis, focusing on a retail sales dataset. It includes setting up a database, cleaning the data, performing exploratory analysis, and solving key business questions through structured SQL queries. Designed for aspiring data analysts, this project provides a solid foundation in querying, interpreting data, and drawing insights.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_sales_project1 `.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_sales_project1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

-- Record count 
SELECT COUNT(*) FROM retail_sales;

-- Unique Customer
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Unique Category
SELECT DISTINCT category FROM retail_sales;

-- Check NULL value 
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete NULL value
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

 1.  **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

   ```sql
      SELECT * 
      FROM retail_sales
      WHERE sale_date='2022-11-05';
   ```

 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

  ```sql
     SELECT * FROM retail_sales 
     WHERE 
        category='Clothing'
        AND
        TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
        AND 
        quantity>=4;
   ```

3.  **Write a SQL query to calculate the total sales (total_sale) for each category**:

```sql
   SELECT
      category,
      SUM(total_sale),
      COUNT(*) as order
    FROM retail_sales 
    GROUP BY category;
```

4.  **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**:
```sql
   SELECT 
  	 ROUND(AVG(age)) AS average_age
   FROM retail_sales 
   WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**:
```sql
   SELECT transactions_id,total_sale FROM retail_sales WHERE total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:
```sql
   SELECT
    	category, 
    	gender, 
    	COUNT(*) AS Total_Transaction
   FROM retail_sales 
   GROUP BY 
    	gender, 
    	category 
    ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
   SELECT
       year,
       month,
       average_sale
   FROM
   (
   SELECT
        EXTRACT('Month' FROM sale_date::date) as month,
        EXTRACT('year' FROM sale_date::date) as year,
        AVG(total_sale) AS average_sale,
        RANK() OVER(PARTITION BY EXTRACT('year' FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales 
    GROUP BY 1,2 
    ) AS T1
    WHERE rank=1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
   SELECT
        customer_id,
        SUM(total_sale)
   FROM retail_sales
   GROUP BY customer_id
   ORDER BY 2 DESC
   LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category**:
```sql
   SELECT
      category,
      COUNT(DISTINCT customer_id) AS total_customers
   FROM retail_sales
   GROUP BY 1;
 ```

10. **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**:
```sql
   SELECT 
      shift,
      count(*) as total_orders
   FROM
    (
    SELECT *,
          CASE
            WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) Between 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
          END AS Shift
    FROM retail_sales
    ) AS hourly_sale
    GROUP BY shift;
```

11. **Find the average total_sale by gender**:
```sql
   SELECT
      gender,
      round(AVG(total_sale)::numeric, 2) As avg_purchase
   FROM retail_sales
   GROUP BY gender
   ORDER BY avg_purchase DESC;
```

12. **Find the day with the highest total sales**:
```sql
   SELECT
       sale_date,
       sum(total_sale) as daily_revenue
   FROM retail_sales
   GROUP BY sale_date
   ORDER BY daily_revenue DESC
   LIMIT 1;
 ```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Best-Performing Months**: The highest-performing month each year was identified using average sales, showing when customer activity is at its peak.
- **Category Performance**: Clothing and Beauty categories generated strong revenue and customer engagement. These appear to be core product segments.
- **Order Timing Patterns**: Majority of transactions occurred in the Afternoon (12 PM – 5 PM), followed by Morning and Evening — useful for staff planning and timed promotions.
- **Top Revenue Day**: The day with the highest total sales was identified, which can be analyzed for campaign impact or seasonal spikes.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

##  Project Status
- Database setup: ✔️ Completed
- Data cleaning: ✔️ Completed
- EDA and insights: ✔️ Completed  
- SQL business queries: ✔️ 12+ solved


## Conclusion

The findings from this project demonstrate how SQL can support data-driven business decisions by uncovering patterns in customer behavior, sales performance, and seasonal trends.

## 🙋 About Me

This project is part of my personal data analytics portfolio, created to showcase my SQL skills including data cleaning, querying, and business insights using PostgreSQL and pgAdmin.

![Status](https://img.shields.io/badge/Project-Completed-brightgreen)
![SQL](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-lightgrey)
![Tool](https://img.shields.io/badge/Tool-pgAdmin-blue)
