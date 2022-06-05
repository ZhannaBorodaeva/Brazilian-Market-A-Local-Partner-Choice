# What categories of tech products does Magist have?
use magist;
SELECT DISTINCT product_category_name_english from product_category_name_translation as t #Shows English names of categories being sold
INNER JOIN products as p
on t.product_category_name = p.product_category_name;
SELECT COUNT(i.product_id), t.product_category_name_english #How many products in all categories have been sold?
from order_items as i 
INNER JOIN products as p
on i.product_id = p.product_id
INNER JOIN product_category_name_translation as t
on p.product_category_name = t.product_category_name
group by (t.product_category_name_english)
order by COUNT(i.order_item_id) DESC;
#End of ''How many products of all categories have been sold?''
SELECT COUNT(i.product_id), t.product_category_name_english #How many technical products  have been sold?
from order_items as i 
INNER JOIN products as p
on i.product_id = p.product_id
INNER JOIN product_category_name_translation as t
on p.product_category_name = t.product_category_name
where t.product_category_name_english IN ('audio','auto','air_conditioning','consoles_games','dvds_blu_ray','home_appliances','electronics','home_appliances_2','small_appliances','computer_accessories','pc_gamer','computers','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','signaling_and_security','tablets_printing_image','telephony','fixed_telephony')
group by (t.product_category_name_english)
order by COUNT(i.order_item_id) DESC;
#End of "How many tech products have been sold?
#What is the average, min, max price of the products sold?
select MIN(Price), MAX(Price), AVG(price)
from order_items;
#End of average, min, max price
SELECT t.product_category_name_english, AVG(i.price), COUNT(i.product_id), #Are expensive tech products popular?
case
when AVG(i.price)>120.65 then 'expensive'
else 'cheap'
END as Price_Level
from order_items as i 
INNER JOIN products as p
on i.product_id = p.product_id
INNER JOIN product_category_name_translation as t
on p.product_category_name = t.product_category_name
where t.product_category_name_english IN ('audio','auto','air_conditioning','consoles_games','dvds_blu_ray','home_appliances','electronics','home_appliances_2','small_appliances','computer_accessories','pc_gamer','computers','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','signaling_and_security','tablets_printing_image','telephony','fixed_telephony')
group by t.product_category_name_english
order by AVG(i.price) DESC;
#End of 'Are expensive tech products popular?'
#Second day of project work
#How many months of data are included in magist database?
use magist;
select * from orders;
select COUNT(distinct month(order_purchase_timestamp)) as months, year(order_purchase_timestamp) as year from orders
group by year
order by year DESC;
#End of "how many months are included?"
#How many sellers are there?
select * from sellers;
select COUNT(distinct seller_id)as sellers_number from sellers;
#How many tech sellers are there?
SELECT t.product_category_name_english as Tech_Category,  COUNT(distinct i.seller_id) as Tech_Sellers_Number #How many tech seller are there?
from order_items as i 
INNER JOIN products as p
on i.product_id = p.product_id
INNER JOIN product_category_name_translation as t
on p.product_category_name = t.product_category_name
where t.product_category_name_english IN ('audio','auto','air_conditioning','consoles_games','dvds_blu_ray','home_appliances','electronics','home_appliances_2','small_appliances','computer_accessories','pc_gamer','computers','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','signaling_and_security','tablets_printing_image','telephony','fixed_telephony')
group by (t.product_category_name_english)
order by COUNT(distinct i.seller_id) DESC;
#What is the total amount earned by sellers?
select * from order_items;
select distinct seller_id, sum(price) from order_items
group by seller_id;
#What is the total amount earned by technical sellers?
SELECT t.product_category_name_english as Tech_Category,  SUM(i.price) as Revenue #How many tech seller are there?
from order_items as i 
INNER JOIN products as p
on i.product_id = p.product_id
INNER JOIN product_category_name_translation as t
on p.product_category_name = t.product_category_name
where t.product_category_name_english IN ('audio','auto','air_conditioning','consoles_games','dvds_blu_ray','home_appliances','electronics','home_appliances_2','small_appliances','computer_accessories','pc_gamer','computers','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','signaling_and_security','tablets_printing_image','telephony','fixed_telephony')
group by (t.product_category_name_english)
order by SUM(i.price) DESC;
#How many orders are delivered on time vs orders delivered with a delay?
SELECT
CASE
WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date) THEN 'On time'
ELSE 'Delayed'
END AS delivery_status,
COUNT(order_id) AS Orders_Count
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status;
#Average time between order placed and order delivered
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) as Average_delivery_days from orders
where order_status = 'delivered';
use magist;
select 
AVG(product_length_cm) as AVG_Length, 
AVG(product_width_cm) as AVG_width, 
AVG(product_height_cm) as AVG_height 
from products;
select * from products;
select 
AVG(product_length_cm) * AVG(product_width_cm) * AVG(product_height_cm) as AVG_Volume
from products;
#Are there any patterns for delayed orders, e.g. big products being delayed more often? Big products are defined as products with volume more than average one
SELECT AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Average_Delivery_Days, COUNT(p.product_id) as Products_Quantity,
case
When (p.product_length_cm * p.product_width_cm * p.product_height_cm) > 12107.2 Then 'Big Product'
else 'Small Product'
END as 'Product_Size'
from orders as o
INNER JOIN order_items as i
ON  o.order_id = i.order_id
INNER JOIN products as p
on i.product_id = p.product_id
where DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
group by Product_Size; 
#Are there any patterns for delayed orders, e.g. big products being delayed more often? Big products are defined as products with weigth more than average one
select AVG(product_weight_g) as AVG_Product_Weight from products;
SELECT AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Average_Delivery_Days, COUNT(p.product_id) as Products_Quantity,
case
When p.product_weight_g > 2276.75 Then 'Heavy Product'
else 'Light Product'
END as 'Product_Weight'
from orders as o
INNER JOIN order_items as i
ON  o.order_id = i.order_id
INNER JOIN products as p
on i.product_id = p.product_id
where DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
group by Product_Weight; 
SELECT AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Average_Delivery_Days, COUNT(p.product_id) as Products_Quantity, #All products that are delivered
case
When p.product_weight_g > 2276.75 Then 'Heavy Product'
else 'Light Product'
END as 'Product_Weight'
from orders as o
INNER JOIN order_items as i
ON  o.order_id = i.order_id
INNER JOIN products as p
on i.product_id = p.product_id
where o.order_status = 'delivered'
group by Product_Weight; 
SELECT AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Average_Delivery_Days, COUNT(p.product_id) as Products_Quantity,#All products delivered group by volume size
case
When (p.product_length_cm * p.product_width_cm * p.product_height_cm) > 12107.2 Then 'Big Product'
else 'Small Product'
END as 'Product_Size'
from orders as o
INNER JOIN order_items as i
ON  o.order_id = i.order_id
INNER JOIN products as p
on i.product_id = p.product_id
where o.order_status = 'delivered'
group by Product_Size; 









