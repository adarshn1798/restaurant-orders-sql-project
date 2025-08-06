-- View all records in the order_details table
SELECT * FROM order_details;


-- TASK 1: Explore the menu_items table

-- View all menu items
SELECT * FROM menu_items;

-- Find the total number of items on the menu
SELECT COUNT(item_name) AS number_of_items 
FROM menu_items;  -- 32


-- Find the least expensive item(s) on the menu
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);  -- Edamame

-- Find the most expensive item(s) on the menu
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items);  -- Shrimp Scampi


-- Count the number of Italian dishes on the menu
SELECT COUNT(item_name) AS italian_item_count
FROM menu_items
WHERE category = 'Italian';  -- 9

-- Find the least expensive Italian dish
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian'); -- Tofu Pad Thai, Spaghetti, Fettuccine Alfredo

-- Find the most expensive Italian dish
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items WHERE category = 'Italian'); -- Shrimp Scampi


-- Count the number of dishes in each category
SELECT category, COUNT(item_name) AS dishes_count
FROM menu_items
GROUP BY category; -- American(6), Asian(8), Mexican(9), Italian(9)

-- Calculate the average price of dishes in each category
SELECT category, ROUND(AVG(price),2) AS avg_dish_price
FROM menu_items
GROUP BY category
ORDER BY avg_dish_price; -- American(10.07), Mexican(11.80), Asian(13.48), Italian(16.75)


-- TASK 2: Explore the order_details table

-- View all order details
SELECT * FROM order_details;

-- Find the date range of the orders
SELECT MIN(order_date), MAX(order_date)
FROM order_details; -- Jan 2023 to March 2023

-- Count the number of distinct orders and total items ordered
SELECT COUNT(DISTINCT order_id) AS orders_made,
       COUNT(*) AS items_ordered
FROM order_details; -- 5370 orders & 12234 items


-- Find the orders that had the highest number of items
SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC; -- Top: order_id 330 with 14 items


-- Count how many orders had more than 12 items
SELECT COUNT(*) AS more_than_12_items FROM
(SELECT order_id, COUNT(item_id) AS num_items
 FROM order_details
 GROUP BY order_id
 HAVING num_items > 12) sub; -- 20 orders


-- TASK 3: Join menu_items with order_details

-- Join tables to get full order information including item details
SELECT *
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id;


-- Identify the least ordered item and its category
SELECT item_name, category, COUNT(*) AS order_count
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY order_count; -- Least: Chicken Tacos (Mexican)


-- Identify the most ordered item and its category
SELECT item_name, category, COUNT(*) AS order_count
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY order_count DESC; -- Most: Hamburger (American)


-- Find the top 5 highest spending orders
SELECT order_id, SUM(price) AS total
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total DESC
LIMIT 5; -- Top order IDs: 440, 2075, 1957, 330, 2675


-- View category-wise item breakdown of the highest spend order (order_id = 440)
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category
ORDER BY num_items DESC; -- Italian tops the list


-- View category-wise breakdown for top 5 highest spend orders
SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category; -- Italian appears most frequently
