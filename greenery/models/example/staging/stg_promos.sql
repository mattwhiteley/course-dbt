{{
    config(materialized='table'
    )
}}

with promos as (
    SELECT * from {{source ('postgres', 'promos')}}
)

SELECT
    promo_id,
    discount,
    status
FROM promos