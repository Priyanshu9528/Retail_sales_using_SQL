Create database retail_sales;

use retail_sales;

-- Create Table
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,	
customer_id	int,
gender	varchar(10),
age	int,
category varchar(20),	
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float
);

-- How many sales we have ?
select count(*) as total_sales from retail_sales;


-- How many distinct (unique) customers we have ?
select count(distinct customer_id) as total_customers from retail_sales;


select distinct category from retail_sales;

select * from retail_sales limit 5;

-- Data Analysis and Business key problems

-- Q1. Write a SQL Query to retrieve all columns for sales made on '2022-10-06' or '2022-10-07'.

select * from retail_sales where sale_date = '2022-10-6' or sale_date='2022-10-07';


-- Q2. Write a SQL Query to retrieve all transactions where the category is 'Electronics' and  the quantity sold 
--     is more than 3 in the month of Oct-2022.

select * from retail_sales 
where 
     category = 'Electronics'
     and
      DATE_FORMAT(sale_date, '%Y-%m') = '2022-10'
      and
      quantiy>=3;



-- Q3. Write a SQL Query to calculate the total sales for each category.

select category, sum(total_sale) as Total_Sales from retail_sales group by category;


-- Q4. Write a SQL Query to find the average age of customers who purchased items from the 'Electronics' category.

select round(avg(age),2) as avg_age from retail_sales where category = 'Electronics';


-- Q5. Write a SQL Query to find all transactions where the total_sale is greater than 1500.

select * from retail_sales where total_sale >= 1500; 


-- Q6. Write a SQL Query to find the total number of transactions (transactions_id) made by each gender in each category.
select category,  gender, count(transactions_id) as total_transactions from retail_sales group by category , gender  order by category;

--  Q7. Write a SQL Query to calculate the average sale for each  month also find out the best selling month in each year. 

select
sale_year,
sale_month,
avg_sale
from
(
select  
year(sale_date) as sale_year,
month(sale_date) as sale_month,
round(avg(total_sale),2) as avg_sale,
rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rank1
from retail_sales
group by 1,2
) as t1
where rank1=1;


-- Q 8. Wrtie a SQL Query to find the top 3 customers based on the highest total sales. 

select 
customer_id,
sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 3; 


-- Q 9. Wrtie a SQL Query to find the number of unique customers who purchased items from each category.

select 
category,
count(distinct customer_id) as total_customers
from retail_sales
group by category;


-- Q 10. Wrtie a SQL Query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12  and 17 , Evening >=16).

with hourly_sale
as
(select *,
case
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales)
select 
shift,
count(*) as total_orders
from hourly_sale
group by shift
order by total_orders desc;


