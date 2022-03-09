{{
    config(materialized='table'
    )
}}

with products as (
    SELECT * from {{source ('postgres', 'products')}}
)

SELECT
    product_id,
    name,
    price,
    inventory
FROM products