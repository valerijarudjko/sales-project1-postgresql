CREATE DATABASE sql_project_p2;
--Creating a table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
     (
      transactions_id	INT PRIMARY KEY,
	  sale_date DATE,
	  sale_time TIME,
	  customer_id	INT,
	  gender	VARCHAR(13),
	  age	INT,
	  category	VARCHAR (13),
	  quantiy INT,
	  price_per_unit	FLOAT,
	  cogs	FLOAT,
	  total_sale FLOAT
     );

-- Checking if there is any data in the table
SELECT * FROM retail_sales;
SELECT COUNT (*) FROM retail_sales;

--Data cleaning
--Check for NULLs
SELECT * FROM rentail_sales
WHERE transactions_id IS NULL;

SELECT * FROM reatail_sales
WHERE sale_date IS NULL;

--or 
SELECT * FROM retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	  OR
	 sale_time IS NULL
	  OR
	 gender IS NULL
	  OR
	 category IS NULL
	  OR
	 quantiy IS NULL
	  OR
	 cogs IS NULL
	   OR
	 total_sale IS NULL;

-- Delete NULLs
DELETE FROM retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	  OR
	 sale_time IS NULL
	  OR
	 gender IS NULL
	  OR
	 category IS NULL
	  OR
	 quantiy IS NULL
	  OR
	 cogs IS NULL
	   OR
	 total_sale IS NULL;

-- Double-check clean data
SELECT COUNT (*) FROM retail_sales;
--1997 rows (data cleaning done)

--Data exploration

--How many sales we have?
SELECT COUNT (*) as total_sale FROM retail_sales;

--How many UNIQUE customers do we have?
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales;
-- Total number of 155

--Total number of categories we have
SELECT (DISTINCT category) as total_sale FROM retail_sales;
-- (total number of 3)

SELECT DISTINCT category FROM retail_sales;
-- (electronics;clothing; beauty)


-- <<<<<<<Data analysis and solving business key problems>>>>>>>>>

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
--(11 sales)


--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:
SELECT
    *
FROM retail_sales
WHERE category = 'Clothing'
    AND 
	TO_CHAR (sale_date,'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;
-- (17 sales)


--Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
    category,
	SUM (total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
--("Electronics"= 684, "Clothing"= 701, "Beauty"= 612)

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';
--(40 years)

	
--Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;
--(306 records)


--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
   gender,
   category,
   COUNT (*) AS total_trans
FROM retail_sales
GROUP BY 
    category,
	gender
ORDER BY 1;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

--creating a subquery 
SELECT
   year,
   month,
   avg_sale
FROM 
(
SELECT 
   EXTRACT (YEAR FROM sale_date) as year,
   EXTRACT (MONTH FROM sale_date) as 07766month,
   AVG (total_sale) as avg_sale,
   RANK () OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) as rank
FROM retail_sales 
GROUP BY 1, 2
) as t1
WHERE rank = 1

--(2022/7; 2023/2; where avg is 541 & 535)

--Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
   customer_id,
   SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
--(customer id: 3;1;5;2;4)


--Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
    COUNT (DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
--( Beauty-141; Clothing-149; Electronics-144)

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

WITH hourly_sale
AS
(
SELECT *,
   CASE
	  WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
	  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening' 
   END as shift
FROM retail_sales
)
SELECT 
   shift,
   COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;
-- ( Morning-558; Afternoon-377; Evening-558)

--<<<<<< End of the project.>>>>>>

