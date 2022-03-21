{{
  config(
    materialized = "table"
  )
}}

WITH stg_events AS (
    SELECT
        *
    FROM
        {{ ref ('stg_events') }}
),
join_transform AS (
    SELECT
        session_id,
        user_guid,
        min(created_at) as session_started_at,
    -- using case whens instead of pivot, cos I'm being a bit lazy, sry
        sum(case when event_type='add_to_cart' then 1 else 0 end) as add_to_cart_ct,
        sum(case when event_type='checkout' then 1 else 0 end) as checkout_ct,
        sum(case when event_type='page_view' then 1 else 0 end) as page_view_ct,
        sum(case when event_type='package_shipped' then 1 else 0 end) as package_shipped_ct
    FROM
        stg_events
    GROUP BY 1,2
)
SELECT
    *
FROM
    join_transform