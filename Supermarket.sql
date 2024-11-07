use mydb1;
show tables;
select * from supermarket;
select count(*) from supermarket;
#Rename the dataset
alter table supermarket rename column `Invoice ID` to Invoice_id;
alter table supermarket rename column `Tax 5%` to Tax;
alter table supermarket rename column `customer type` to customer_type;
alter table supermarket rename column `product line` to product_line;
alter table supermarket rename column `unit price` to unit_price;
alter table supermarket rename column `gross margin percentage` to gross_percentage;
alter table supermarket rename column `gross income` to gross_income;


#understand the data structure
#check whether the datatype is valid for all data
describe supermarket;
select * from supermarket;
alter table supermarket modify unit_price float;
alter table supermarket modify tax float;
alter table supermarket modify total float;
alter table supermarket modify cogs float;
alter table supermarket modify unit_price float;
alter table supermarket modify gross_percentage float;
alter table supermarket modify gross_income float;
alter table supermarket modify rating float;
alter table supermarket modify date date;
alter table supermarket modify time time;

select * from supermarket;
#check missing values
select count(*)-count(invoice_id) from supermarket group by invoice_id ;
select count(*)-count(branch) from supermarket group by branch ;
select count(*)-count(city) from supermarket group by city ;
select count(*)-count(customer_type) from supermarket group by customer_type ;
select count(*)-count(gender) from supermarket group by gender ;
select count(*)-count(product_line) from supermarket group by product_line ;
select count(*)-count(unit_price) from supermarket group by unit_price ;
select count(*)-count(quantity) from supermarket group by quantity ;
select count(*)-count(tax) from supermarket group by tax;
select count(*)-count(total) from supermarket group by total;
select count(*)-count(date) from supermarket group by date;
select count(*)-count(time) from supermarket group by time ;
select count(*)-count(payment) from supermarket group by payment;
select count(*)-count(cogs) from supermarket group by cogs ;
select count(*)-count(gross_percentage) from supermarket group by gross_percentage ;
select count(*)-count(gross_income) from supermarket group by gross_income ;
select count(*)-count(rating) from supermarket group by rating ;
select count(distinct(Invoice_id)) from supermarket;

#Checking whether where is any NULL values
select count(*) from supermarket where Invoice_id is null;
select count(*) from supermarket where Branch is null;
select count(*) from supermarket where city is null;
select count(*) from supermarket where customer_type is null;
select count(*) from supermarket where gender is null;
select count(*) from supermarket where product_line is null;
select count(*) from supermarket where unit_price is null;
select count(*) from supermarket where Quantity is null;
select count(*) from supermarket where tax is null;
select count(*) from supermarket where total is null;
select count(*) from supermarket where date is null;
select count(*) from supermarket where time is null;
select count(*) from supermarket where payment is null;
select count(*) from supermarket where cogs is null;
select count(*) from supermarket where gross_percentage is null;
select count(*) from supermarket where gross_income is null;
select count(*) from supermarket where rating is null;


#checking outliers
select avg(gross_income) as avg_income,stddev(gross_income) as stddev_income from supermarket; #found the average income and standard deviation of the income
select * from supermarket where gross_income > (select avg(gross_income) + 3 * stddev(gross_income) from supermarket)
or gross_income < (select avg(gross_income) - 3 * stddev(gross_income) from supermarket); 
# A common approach is to consider values outside 3 standard deviations from the mean as potential outliers.
select * from supermarket where unit_price > (select avg(unit_price) + 3 * stddev(unit_price) from supermarket)
or unit_price < (select avg(unit_price) - 3 * stddev(unit_price) from supermarket);










#Feature engineering
alter table supermarket add column revenue_per_item float;
SET SQL_SAFE_UPDATES =0;
update supermarket set revenue_per_item = total / quantity; #add a column revenue (total_sales)
alter table supermarket add column original_price FLOAT;
update supermarket set original_price = unit_price / (1 - 0.1); # Assuming a 10% average discount
alter table supermarket add column discount_percentage FLOAT;
UPDATE supermarket
SET discount_percentage = 
    CASE 
        WHEN customer_type = 'Member' THEN ((original_price - unit_price) / original_price) * 100
        ELSE 0
    END; #the members are given 10% discount others have no discount
alter table supermarket add column day_part VARCHAR(10);
update supermarket 
set day_part = 
    case 
        when hour(Time) between 5 and 12 then 'Morning'
        when hour(Time) between 12 and 17 then 'Afternoon'
        else 'Evening'
    end;
select * from supermarket;


#UnivariateAnalysis
select * from supermarket order by Invoice_ID limit 5 ;
select * from supermarket order by rand() limit 5; #It is used to display random rows
select count(gross_income),min(gross_income),max(gross_income),avg(gross_income),std(gross_income) from supermarket;
select distinct(City) from supermarket ; #the supermarket of city
select Payment,count(*) as counts from supermarket group by Payment order by counts desc;
select product_line,avg(rating) from supermarket group by product_line order by avg(rating) desc; #highest rating product line
select product_line,sum(Quantity) as sum from supermarket 
group by product_line order by sum desc; #Find the product line purchased in high quantity
select distinct(branch) from supermarket;
select customer_type from supermarket where branch='A';
select customer_type from supermarket where branch='B';
select customer_type from supermarket where branch='C';
select count(customer_type) from supermarket  where gender='female';
select count(customer_type) from supermarket where gender='male';
select distinct(payment) from supermarket;
select count(Invoice_id) as counts from supermarket where payment='cash';
select count(Invoice_id) as counts from supermarket where payment='credit card';
select count(Invoice_id) as counts from supermarket where payment='ewallet';
select count(customer_type) as customer_count from supermarket where customer_type='Member';
select count(customer_type) as customer_count from supermarket where customer_type='normal';
select product_line,sum(tax) as total_tax from supermarket group by product_line order by sum(tax) desc;
select product_line, avg(Quantity) as average_quantity from supermarket group by product_line; #average quantity sold
select gender, count(distinct Invoice_id) AS unique_customers from supermarket group by gender;
select branch,count(Invoice_id) as sales_count from supermarket group by branch;
select city,count(Invoice_id) as sales_count from supermarket group by city;
select product_line,count(*) as transaction_count from supermarket group by 
product_line order by transaction_count desc;#count of rating based on transactions
select avg(cogs) from supermarket; #cost of goods sold
select customer_type from supermarket;
select customer_type from supermarket where discount_percentage !=0;
select avg(gross_income) from supermarket;
select Invoice_id,sum(quantity) as total_quantity from supermarket group by Invoice_id;
        
       
select * from supermarket;
#These queries perform univariate analysis by focusing on a single variable's distribution or 
#aggregated metrics across categories (like product_line, branch, Payment, customer_type, gender, etc.). 
#This approach helps in understanding the dataset from different perspectives while ensuring the uniqueness of 
#each query.















#Bivariate Analysis
select Branch,sum(gross_income) as sum_gross_income from supermarket 
group by Branch order by sum_gross_income desc; #Most profitable branch as per gross income
select dayname(date),dayofweek(date),sum(Total) from supermarket group by  dayname(date),dayofweek(date)
order by sum(total) desc;
select monthname(date) as name,month(date) as month,sum(Total) as total from supermarket
group by name,month order by total desc; #get the month with highest sales
select hour(Time) as hour,sum(Total) as total from supermarket
group by hour order by total desc;  #time at which sales are higher
select Gender,avg(gross_income) from supermarket group by gender;#which gender spends more 
select gender,count(*),product_line from supermarket where product_line='Health and beauty' group  by gender ;
select count(gender) as customer_count,product_line from supermarket group by product_line;
select product_line,avg(unit_price) as average_unit_price from supermarket group by product_line 
order by average_unit_price asc;
select distinct(product_line),gross_percentage from supermarket;
select product_line,avg(tax) as average_tax from supermarket group by product_line;
select product_line,min(tax) as minimum_tax from supermarket group by product_line
order by minimum_tax asc;
SELECT city,
    SUM(CASE WHEN Payment = "Cash" THEN 1 ELSE 0 END) AS "Cash",
    SUM(CASE WHEN Payment = "Ewallet" THEN 1 ELSE 0 END) AS "Ewallet",
    SUM(CASE WHEN Payment = "Credit card" THEN 1 ELSE 0 END) AS "Credit card"
FROM supermarket GROUP BY City; #payment methods used by city
select product_line,rating from supermarket order by rating desc; #checks rating based on product line
select distinct(product_line),rating from supermarket where rating>9;
select product_line,avg(gross_income) as average_gross from supermarket group by product_line;
#cost of goods sold(cogs)
select city,product_line,avg(cogs) from supermarket group by city,product_line;
select city,product_line,min(cogs) from supermarket group by city,product_line;
select city,product_line,max(cogs) from supermarket group by city,product_line order by max(cogs) desc;
SELECT Branch, customer_type, AVG(gross_income) AS average_gross_income 
FROM supermarket 
GROUP BY Branch, customer_type 
ORDER BY average_gross_income DESC; #Average gross income by branch and customer type
SELECT Gender, product_line, SUM(Total) AS total_sales 
FROM supermarket 
GROUP BY Gender, product_line 
ORDER BY total_sales DESC; #Total sales by gender and product line
SELECT product_line, city, AVG(tax) AS average_tax 
FROM supermarket 
GROUP BY product_line, city 
ORDER BY average_tax ASC;#Average tax by product line and city
SELECT product_line, MONTH(date) AS month, SUM(Quantity) AS total_quantity FROM supermarket 
GROUP BY product_line, month ORDER BY total_quantity DESC;
SELECT city, Payment, SUM(Total) AS total_sales_amount 
FROM supermarket 
GROUP BY city, Payment 
ORDER BY total_sales_amount DESC; #amount by city and payment method
SELECT Branch, product_line, AVG(rating) AS average_rating 
FROM supermarket 
GROUP BY Branch, product_line 
ORDER BY average_rating DESC; #Average rating by branch and product line



#Multivariate Analysis
SELECT date,product_line,SUM(quantity) AS total_quantity FROM supermarket 
GROUP BY date, product_line;
SELECT customer_type, Payment, AVG(Total) AS average_purchase
FROM supermarket GROUP BY customer_type, Payment ORDER BY average_purchase DESC;
SELECT city,product_line,SUM(Quantity) AS total_quantity FROM supermarket 
GROUP BY city, product_line ORDER BY city, total_quantity DESC;
SELECT customer_type, Payment, AVG(Total) AS average_purchase
FROM supermarket GROUP BY customer_type, Payment ORDER BY average_purchase DESC;
SELECT city,Date,time, product_line, SUM(Total) AS total_sales
FROM supermarket GROUP BY city,Date,time, product_line ORDER BY total_sales ASC; #Trend over time
SELECT branch, product_line, revenue_per_item FROM supermarket ORDER BY revenue_per_item DESC;
SELECT City, Branch, SUM(gross_income) AS sum FROM supermarket GROUP BY City, Branch;
SELECT customer_type, COUNT(*) AS visit_count,
    CASE 
        WHEN COUNT(*) >= 10 THEN 'Frequent'
        WHEN COUNT(*) BETWEEN 5 AND 9 THEN 'Moderate'
        ELSE 'Occasional'
    END AS frequency_category
FROM supermarket 
GROUP BY customer_type;
select Invoice_id,product_line,customer_type,(original_price-discount_percentage) as price_after_discount from supermarket
where customer_type='Member' or customer_type='Normal' ;
select distinct(city),total as total_sales from supermarket where day_part='Morning';
SELECT branch,product_line,customer_type,SUM(gross_income) AS total_gross_income 
FROM supermarket GROUP BY branch, product_line, customer_type ORDER BY total_gross_income DESC;
SELECT HOUR(time) AS hour_of_day,product_line,branch,SUM(Total) AS total_sales FROM supermarket 
GROUP BY hour_of_day, product_line, branch ORDER BY hour_of_day, total_sales DESC;







































    










































