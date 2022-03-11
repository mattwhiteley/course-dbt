{{
    config(materialized='table'
    )
}}

with addresses as (
    SELECT * from {{source ('postgres', 'addresses')}}
)

SELECT
    address_id,
    address,
    zipcode,
    state,
    country
FROM addresses