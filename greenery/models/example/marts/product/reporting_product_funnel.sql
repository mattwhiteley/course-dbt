{{
  config(
    materialized = "table"
  )
}}
WITH fact_sessions AS (
    SELECT
        *
    FROM
        {{ ref ('fact_sessions') }}
),
all_sessions AS (
    SELECT
        *,
        DATE_PART(
            'WEEK',
            session_started_at
        ) AS cohort_week,
        DATE_PART(
            'YEAR',
            session_started_at
        ) AS cohort_year
    FROM
        fact_sessions
    WHERE
        page_view_ct > 0
        OR add_to_cart_ct > 0
        OR checkout_ct > 0
),
-- defining an 'engaged' session AS those containing POSITIVE buying signals (adding TO cart,OR checking OUT) 
engaged_sessions AS (
    SELECT
        *,
        date_part(
            'week',
            session_started_at
        ) AS cohort_week,
        date_part(
            'YEAR',
            session_started_at
        ) AS cohort_year
    FROM
        fact_sessions
    WHERE
        add_to_cart_ct > 0
        OR checkout_ct > 0
),
converted_sessions AS(
    SELECT
        *,
        date_part(
            'week',
            session_started_at
        ) AS cohort_week,
        date_part(
            'YEAR',
            session_started_at
        ) AS cohort_year
    FROM
        fact_sessions
    WHERE
        checkout_ct > 0
),
funnel_stages AS (
    SELECT
        cohort_year,
        cohort_week,
        'All Sessions' AS stage,
        COUNT(*)
    FROM
        all_sessions
    GROUP BY 1,2,3
    UNION
    SELECT
        cohort_year,
        cohort_week,
        'Engaged Sessions' AS step,
        COUNT(*)
    FROM
        engaged_sessions
    GROUP BY 1,2,3
    UNION
    SELECT
        cohort_year,
        cohort_week,
        'Converted Sessions' AS step,
        COUNT(*)
    FROM
        converted_sessions
    GROUP BY 1,2,3
    ORDER BY
        4 DESC
)
SELECT
    *
FROM
    funnel_stages