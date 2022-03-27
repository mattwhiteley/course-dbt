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

    stg_products AS (
    SELECT
        *
    FROM
        {{ ref ('stg_products') }}
    ),

    checkout_sessions as (
        SELECT
            session_id,
            event_type,
            1 as checkout_session
        FROM stg_events
        WHERE event_type='checkout'
        GROUP BY 1,2,3
    ),

    join_transform AS (
        SELECT
            e.session_id,
            e.product_id,
            p.name,
            e.user_guid,
            min(e.created_at) as session_started_at,
        -- using case whens, to be replaced with a macro later in week 3 progress
            sum(case when e.event_type='page_view' then 1 else 0 end) as page_view_ct,
            sum(case when e.event_type='add_to_cart' then 1 else 0 end) as add_to_cart_ct,
            coalesce(max(cs.checkout_session),0) as checkout
        FROM
            stg_events e
        LEFT JOIN
            checkout_sessions cs
            on cs.session_id=e.session_id
        LEFT JOIN
            stg_products p
            ON e.product_id=p.product_id
        WHERE e.product_id IS NOT NULL
        GROUP BY 1,2,3,4
    )

SELECT
    *
FROM
    join_transform