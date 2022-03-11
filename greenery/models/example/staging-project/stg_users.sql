{{
    config(materialized='table'
    )
}}

with users as (
    SELECT * from {{source ('postgres', 'users')}}
)

SELECT
    user_id as user_guid,
    first_name,
    last_name,
    email,
    phone_number,
    created_at,
    updated_at,
    address_id
FROM users