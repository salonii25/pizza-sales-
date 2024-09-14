-- Join the necessary tables to find the total quantity of each pizza category ordered.

select  pizza_types.category, sum(order_details.quantity) as Total_quantity from pizza_types join pizzas on pizza_types.pizza_type_id= pizzas.pizza_type_id 
join order_details on order_details.pizza_id= pizzas.pizza_id group by pizza_types.category;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.order_time) AS hour,
    COUNT(order_details.order_id) AS orders
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY hour
ORDER BY hour;

-- Join relevant tables to find the category-wise distribution of pizzas
SELECT 
    pizza_types.category,
    count(name) as pizza_variety from pizza_types group by category;
    
    -- Group the orders by date and calculate the average number of pizzas ordered per day.
    
SELECT 
    round(avg(orders_quantity),0) as average_order_per_day
FROM
    (SELECT 
        orders.order_date AS order_date,
            SUM(order_details.quantity) AS orders_quantity
    FROM
        orders
    JOIN order_det ails ON orders.order_id = order_details.order_id
    GROUP BY order_date) AS order_per_day;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name as pizza_name, sum(pizzas.price * order_details.quantity) as revenue
 from pizza_types join pizzas on pizza_types.pizza_type_id= pizzas.pizza_type_id 
 join order_details on order_details.pizza_id= pizzas.pizza_id
 group by pizza_name order by revenue desc limit 3;
 
 SELECT 
    pizza_revenue.name,
 round((revenue / total_revenue) * 100,2) AS percentage
FROM 
    (SELECT pizza_types.name
            SUM(pizzas.price * order_details.quantity) AS revenue, 
            SUM(SUM(pizzas.price * order_details.quantity)) OVER () AS total_revenue
     FROM pizza_types
     JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
     JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
     GROUP BY pizza_types.name
    ) AS pizza_revenue;
 