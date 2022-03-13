{{
    config(materialized='table'
    )
}}

with events as (
    SELECT * from {{source ('postgres', 'events')}}
), 
rename as (
    SELECT
        event_id,
        session_id,
        user_id as user_guid,
        event_type,
        page_url,
        created_at,
        order_id,
        product_id
    FROM events
)

SELECT * FROM rename