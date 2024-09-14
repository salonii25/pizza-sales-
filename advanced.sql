-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_revenue.name, 
    (revenue / total_revenue) * 100 AS percentage
FROM 
    (SELECT pizza_types.name, 
            SUM(pizzas.price * order_details.quantity) AS revenue, 
            SUM(SUM(pizzas.price * order_details.quantity)) OVER () AS total_revenue
     FROM pizza_types
     JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
     JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
     GROUP BY pizza_types.name
    ) AS pizza_revenue;
    
    -- Analyze the cumulative revenue generated over time.
    
SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM 
    (SELECT order_date, SUM(pizzas.price * order_details.quantity) AS revenue
     FROM orders
     JOIN order_details ON orders.order_id = order_details.order_id
     JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
     GROUP BY order_date) AS daily_revenue
ORDER BY order_date;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, name,revenue from (select category, name, revenue,
rank() over(partition by category  order by revenue desc) as rn from 
 (select pizza_types.name, pizza_types.category, SUM(pizzas.price * order_details.quantity) AS revenue
FROM pizza_types
     JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
     JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
     group by pizza_types.name, pizza_types.category)as a)as b
     where rn<=3;
