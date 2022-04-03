# Week 4 Submission

## Part 1 - Snapshots:
    - Snapshot Model location: https://github.com/mattwhiteley/course-dbt/blob/main/greenery/snapshots/orders_snapshots.sql

### SQL to check changes:

A core query suach as the one below could be used to identify rows that have a `dbt_valid_to` and so have been updated elsewhere - this could power a further model for insights on shipping lags, carrier or address changes etc.

```
WITH updated_orders AS(
    SELECT
        order_id
    FROM
        snapshots.orders_snapshot
    WHERE
        dbt_valid_to IS NOT NULL
)
SELECT
    *
FROM
    snapshots.orders_snapshot so
WHERE
    so.order_id IN (
        SELECT
            *
        FROM
            updated_orders
    )

```

## Part 2 - Modelling Change:

## Part 3 - Reflection Questions:
