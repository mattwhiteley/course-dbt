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
        e.session_id,
        e.user_guid,
    -- replacing the CASE WHENS with a macro
        {{ pivot_items('e.event_type',['add_to_cart','checkout','page_view','package_shipped']) }}
        min(e.created_at) as session_started_at
    FROM
        stg_events e
    GROUP BY 1,2
)
SELECT
    *
FROM
    join_transform



