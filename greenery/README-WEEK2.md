## Week 2 - Answers & SQL:

### What is our user repeat rate?
79.8% (as 0.7983.... returned from query)

```
WITH user_purchases AS(
        SELECT
            user_guid,
            COUNT(
                DISTINCT order_id
            ) AS total_orders
        FROM
            dbt_matt_w.stg_orders
        GROUP BY
            1
    )
SELECT
    (SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) :: numeric) / (COUNT(total_orders) :: numeric) AS repeat_rate
FROM
    user_purchases
```

### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again?  If you had more data, what features would you want to look into to answer this question?


I would expectfeature
Order value over a certain value 

Product types: Some products might lend themselves to a one-off purchase (larger plants), versus smaller pots
Order Value
Delivery time: Long delivery times, or those where the actual delivery time was later than estimated might lead to poor customer expeirences, similarly, those customers who have received fast/next day delvieries might consider Greenery for future deliveries

Additonal features I'd like to see would ideally be those to be able to segment the customers into clusters based on similarity

### Creating marts & intermediate models
Marts folders: