-- SQL Retail Sales Analysis 
CREATE DATABASE sql_sales_project1;

-- Create TABLE
CREATE TABLE retail_sales
           (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT 
    COUNT(*) 
FROM retail_sales

--Data Cleaning--
SELECT * FROM retail_sales 
where 
	transactions_id IS NULL 
	OR 
	sale_date IS NULL 
	OR 
	sale_time IS NULL 
	OR 
	sale_time IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--
Delete FROM retail_sales 
where 
	transactions_id IS NULL 
	OR 
	sale_date IS NULL 
	OR 
	sale_time IS NULL 
	OR 
	sale_time IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

------DATA EXPLORATION------

-- How many sales we have?
SELECT Count(*) FROM retail_sales

-- How many uniuque customers we have ?
SELECT count(DISTINCT customer_id) as total_sales From retail_sales

-- unique category we have ?
SELECT DISTINCT category FROM retail_sales



-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q11: Find the average total_sale by gender
-- Q12: Find the day with the highest total sales

	
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales 
WHERE sale_date='2022-11-05'

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales 
WHERE 
	category='Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND 
	quantity>=4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale),
	COUNT(*) as order
FROM retail_sales 
GROUP BY category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age)) AS average_age
FROM retail_sales 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id,total_sale FROM retail_sales WHERE total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category, 
	gender, 
	COUNT(*) AS Total_Transaction
FROM retail_sales 
GROUP BY 
	gender, 
	category 
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
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
GROUP BY shift

-- Q11: Find the average total_sale by gender
SELECT 
	gender,
	round(AVG(total_sale)::numeric, 2) As avg_purchase
FROM retail_sales
GROUP BY gender
ORDER BY avg_purchase DESC

-- Q12: Find the day with the highest total sales
SELECT 
	sale_date,
	sum(total_sale) as daily_revenue
FROM retail_sales
GROUP BY sale_date
ORDER BY daily_revenue DESC
LIMIT 1
		
--Poject Completed---
