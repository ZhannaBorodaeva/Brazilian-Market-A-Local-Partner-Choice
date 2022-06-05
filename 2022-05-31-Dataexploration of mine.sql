use magist;
select count(order_id)
from orders;
select * from orders;
select order_status, count(order_id) as order_numbers
from orders
group by order_status
order by count(order_id) desc;
select count(order_id), year(order_purchase_timestamp) as magist_year, month(order_purchase_timestamp) as magist_month
from orders
group by magist_year, magist_month
order by magist_year DESC, magist_month DESC;
select count(order_id), year(order_purchase_timestamp) as magist_year
from orders
group by magist_year
order by magist_year DESC;
select COUNT(DISTINCT product_id) as products_number 
from products;
use magist;
select COUNT(product_id) as list_of_products
from products;
SELECT COUNT(DISTINCT product_id) as sold_products
from order_items;
SELECT MIN(price) as min_price, MAX(price) as max_price
from order_items;
SELECT order_id, MAX(payment_value)
from order_payments;










