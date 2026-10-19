# E-Commerce Data Warehouse and ETL Pipeline
# MySQL Warehouse Loading
#22
create database datawarehouse;
use datawarehouse;
create table dim_customers(customer_id bigint primary key,customer_name varchar(250),
email varchar(100),city varchar(150),state varchar(200),signup_date date);
create table dim_order_items(order_item_id bigint primary key,order_id int,product_id bigint,
quantity bigint,unit_price bigint,discount_pct int);
create table dim_orders(order_id int primary key,customer_id int,order_date datetime,order_status 
varchar(150),shipping_city varchar(100));
create table dim_payments(payment_id int primary key,order_id bigint,payment_method varchar(150),
payment_amount decimal(10,5),payment_status varchar(100));
create table dim_products(product_id bigint primary key,product_name varchar(250),
category varchar(150),unit_price bigint,unit_cost decimal(10,3),supplier varchar(150));

#23
use datawarehouse;
show tables;
# Dimension Table 
select * from dim_customers;
select * from dim_orders; 
select * from dim_payments;
select * from dim_products;

# Fact table 
select * from dim_order_items;

#24
use datawarehouse;
select * from dim_customers;
select * from dim_order_items;
select * from dim_orders;
select * from dim_payments;
select * from dim_products;
create table etlaudit(pipeline_run_id bigint,run_start_time time,
run_end_time time,source_row_count bigint,target_row_count bigint,
pipeline_status varchar(150));

desc etlaudit;

# Section F- SQL Analytics
#25
use datawarehouse;
alter table customers modify column signup_date date;
alter table orders modify column order_date date;
# Total Revenue by month
select year(o.order_date)as year,month(o.order_date)as Month,
sum(od.quantity*od.unit_price)as Total_Revenue 
from orders o left join order_items od 
on o.order_id=od.order_id  
group by year(o.order_date),month(o.order_date);

# Total Profit by month 
use datawarehouse;
select o.order_date,year(o.order_date)as Year,month(o.order_date)as Month,
round(sum(od.quantity*(p.unit_price-p.unit_cost)),2) as Total_Profit from orders o 
left join order_items od on o.order_id=od.order_id  
left join products p on od.product_id=p.product_id
group by o.order_date,year(o.order_date),month(o.order_date);

#26
use datawarehouse;
select * from(
select p.product_id,p.product_name,sum(od.quantity*od.unit_price)as Total_Revenue,dense_rank()
over(order by sum(od.quantity*od.unit_price)desc)
as ProductRankings 
from products p left join order_items od 
on p.product_id=od.product_id 
group by p.product_id,p.product_name)t 
where ProductRankings<=10;

#27
use datawarehouse;
select p.category,sum(od.quantity*od.unit_price)as Total_Revenue,
sum(od.quantity*od.unit_price)*100/sum(sum(od.quantity*od.unit_price))over() 
as Percentage_Contribution 
from products p left join order_items od 
on p.product_id=od.product_id 
group by p.category;

#28
use datawarehouse;
select year(o.order_date)as year,month(o.order_date)as month
,sum(od.quantity*od.unit_price)as Total_Revenue,
lag(sum(od.quantity*od.unit_price))over() as Previous_Amount 
from orders o left join order_items od 
on o.order_id=od.order_id 
group by year(o.order_date),month(o.order_date);












