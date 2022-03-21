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
        *
    FROM
        stg_events
    WHERE
        event_type = 'package_shipped'
)
SELECT
    *
FROM
    join_transform