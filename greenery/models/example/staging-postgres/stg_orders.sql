{{
    config(materialized='table'
    )
}}

with orders as (
    SELECT * from {{source ('postgres', 'orders')}}
)

SELECT
    order_id,
    promo_id,
    user_id as user_guid,
    address_id,
    created_at,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    status
FROM orders