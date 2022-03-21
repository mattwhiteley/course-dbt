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

I would expect a number of features to relate to the likelihood of repeat purchases:
- Delivery time: Long delivery times, or those where the actual delivery time was later than estimated might lead to poor customer expierences, similarly, those customers who have received fast/next day delvieries might consider Greenery for future deliveries
- Order value over a certain value - although I don't have a perspective which way this would be correlated, it might be interseting to see if there is a trend or threshold for a certain pend amount with likelood to repurchase.
- Product types: Some products might lend themselves to a one-off purchase (larger plants), versus smaller pots, maybe varieties that are notoriously hard to keep alive or with shorter lifespans (cut flowers)
- Perhaps capturing information about the context of the purchase might help too - people buying for recurring events: birthdays, anniversaries etc might be more likely (especially with a reminder email) to repurchase
- Additonal features I'd like to see would ideally be those to be able to segment the customers into clusters based on similarity: age, gender, location, and marketing profile similarities

### Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- I'd expect a build to be running frequently for at least a daily update of tests within the pipeline
- Notifications set via dbt Cloud (we're running dbt Cloud and [doing this](https://docs.getdbt.com/docs/dbt-cloud/using-dbt-cloud/cloud-slack-notifications))
- Write a script to parse [error] flags from the [dbt.log files](https://docs.getdbt.com/reference/events-logging) on a daily basis, post the results to Slack