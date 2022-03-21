{{
  config(
    materialized = "table"
  )
}}

WITH stg_order_items AS (
    SELECT
        *
    FROM
        dbt_matt_w.stg_order_items
),
stg_orders AS (
    SELECT
        *
    FROM
        dbt_matt_w.stg_orders
),
max_created_at AS(
    -- using this as a proxy for 'last 24hrs' given this is static data, I'd use a system time function (NOW) in the WHERE clause below in a regular pipeline to account for 'yesterday' or something
    SELECT
        MAX(created_at) - INTERVAL '24' HOUR
    FROM
        stg_orders od
),
join_transform AS (
    SELECT
        oi.product_id,
        SUM(
            oi.quantity
        )
    FROM
        stg_orders od
        LEFT JOIN stg_order_items oi
        ON od.order_id = oi.order_id 
    WHERE
        od.created_at >= (
            -- date window shenanigans as explained above
            SELECT
                *
            FROM
                max_created_at
        )

    GROUP BY
        1
)
SELECT
    *
FROM
    join_transform