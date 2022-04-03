# Week 4 Submission

## Part 1 - Snapshots:
- [Snapshot Model](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/snapshots/orders_snapshot.sql)

### SQL to check changes:

A core query such as the one below could be used to identify rows that have a non-null `dbt_valid_to` and so have been updated elsewhere - this could power a further model for insights on shipping lags, carrier or address changes etc.

```sql
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

### 2.1 - Funnel Models:
- Model: [reporting_product_funnel.sql](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/models/example/marts/product/reporting_product_funnel.sql)

- Cohort Year/Week: I added a week/year cohort grouping  to allow a product team to track funnel performance over time, should a particular release affect customer behaviour in adding products/checking-out

- Current Performance:

Funnel Stage|Sessions|Sessions, previous stage|Stage Conversion Rate
---
All Sessions|578|-|-|
Engaged Sessions|467|578|0.81
Converted Sessions|361|467|0.77

Currently the performance of the funnel is pretty impressive, 81% of users viewing a product page add something to their basket, and 77% of those go on to make a purchase. The largest drop off here is with 23% of baskets being abandoned.

Generated with:

```sql
SELECT
    stage AS "Funnel Stage",
    COUNT AS "Sessions",
    LAG(
        COUNT,
        1
    ) over () AS "Sessions, previous stage",
    ROUND((COUNT :: numeric / LAG(COUNT, 1) over ()), 2) AS "Stage Conversion Rate"
FROM
    dbt_matt_w.reporting_product_funnel;
```

ref:[PopSQL article on Funnel Analysis](https://popsql.com/sql-templates/marketing/running-a-funnel-analysis)

### 2.2 - Exposure:
- Exposure definition: [exposures.yml](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/models/example/marts/product/exposures.yml)

## Part 3 - Reflection Questions:

### 3A : If your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?

We're just setting up our entire data stack, with dbt as our modelling layer, so I'm gathering ideas on some principles that I think I'd like us to apply:

- Exposures appear to be a great way to articulate in the docs where reporting tables are being consumed. For example, we're providing SQL access and publishing some data connections in Tableau, so it adds a good complrehensive view of where users can get to this data for their reports and analysis. I was worried there might be some disconnect in understanding the data in the dbt docs to being able to access and consume the data we're providing. I would love to be able to investigate how Tableau could inherit a data quality/certification flag from dbt docs/exposures so we only need to update ths flag in one location.
- Our current position is to perform only simple tasks with macros, as I'm concerned about abstracting too much complexity into harder to understand macros for newer developers and docs readers.
