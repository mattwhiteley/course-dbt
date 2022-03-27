{{
  config(
    materialized = "table"
  )
}}

WITH stg_users AS (
    SELECT
        *
    FROM
        {{ ref ('stg_users') }}
),
stg_addresses AS (
    SELECT
        *
    FROM
        {{ ref ('stg_addresses') }}
),
join_transform AS (
    SELECT
        u.user_guid,
        SUBSTRING(u.email, POSITION('@' IN u.email)+1) AS email_suffix, -- keeping this to identify users potentiallu from the same company for corporate orders
        u.created_at,
        u.updated_at,
        a.zipcode,
        a.state,
        a.country
    FROM
        stg_users u
        LEFT JOIN stg_addresses a
        ON u.address_id = a.address_id
)
SELECT
    *
FROM
    join_transform