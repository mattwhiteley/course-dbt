{{
    config(materialized='table'
    )
}}

with order_items as (
    SELECT * from {{source ('postgres', 'order_items')}}
)

SELECT
    order_id,
    product_id,
    quantity
FROM order_items