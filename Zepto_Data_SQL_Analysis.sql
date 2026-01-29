
CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) not null,
    mrp numeric(8,2),
    discount_percent Numeric(5,2),
    available_quantity INTEGER,
    discounted_selling_price Numeric(8,2),
    weight_in_gms INTEGER,
    out_of_stock BOOL EAN,
    quantity INTEGER

);
-- sample data
select *from zepto limit 10;

-- count 
select count(*) from zepto ;

-- null data 
select *from zepto where 
name is null or 
category is null or 
sku_id is null or 
mrp is null or 
discount_percent is null or 
available_quantity is null or 
discounted_selling_price is null or 
weight_in_gms is null or 
out_of_stock is null or 
quantity is null 
;

-- different types of products 
select distinct(name),count(*) from zepto group by name order by count(*) desc;

-- Diffrent categories 
select distinct(category) from zepto;

-- PRODUCTS IN STOCK AND OUT OF STOCK 
select out_of_stock , count(sku_id) from zepto group by out_of_stock;

-- PRODUCT NAME PRESENT MULTIPLES TIME 
select name , count(sku_id) as Number_Of_SKU from zepto
group by name 
having count(sku_id)>1  
order by count(sku_id) desc;

-- DATA CLEANING -->
select *from zepto where mrp=0 or discounted_selling_price=0;

delete from zepto where mrp=0;

-- converting the currency from paise to rupees: 
update zepto
set mrp=mrp/100.0,
discounted_selling_price=discounted_selling_price/100.0;

-- BUISNESS INSIGHTS : 

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name ,mrp, discount_percent from zepto 
order by discount_percent desc limit 10;

-- Q2. What are the products that have high MRP but out of stock? 

select distinct name , mrp from zepto 
where out_of_stock=true and mrp>300
order by mrp desc ;

-- Q3. Calculate estimated revenue for each category.

select category , sum(discounted_selling_price*available_quantity) as total_revenue from zepto 
group by category 
order by total_revenue desc;

--Q4. Find all the products where mrp is greater 500 and discount is less than 10%.

select distinct name , mrp,discount_percent from zepto 
where mrp>500 and discount_percent<10
order by discount_percent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percent.

select category , avg(discount_percent) as "Average Discount"  from zepto 
group by category 
order by avg(discount_percent) desc limit 5;

-- Q6. Find price per gram for products above 100gm and sort by best value.

select distinct name ,weight_in_gms , discounted_selling_price, round((discounted_selling_price/weight_in_gms),2) as "Price Per Gram" from zepto 
where weight_in_gms >100 
order by "Price Per Gram" desc ;

-- Q7. Group products into categories like Low , Medium , Bulk.

select distinct name , weight_in_gms ,
case 
    when weight_in_gms <1000 then 'Low' 
    when weight_in_gms between 1000 and 5000 then 'Medium'
    else 'Bulk'
  end as Weight_Categories
from zepto ;


-- Q8. What is the total Inventory weight per category? 

select category , round(sum((weight_in_gms/1000.0)*available_quantity),2) as Inventory_Weight_KG from zepto
group by category
order by Inventory_Weight_KG desc;



