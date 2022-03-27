# Week 3 Submission

## Part 1 - Product Metrics:

### Top-line Conversion Rate:

Defining as % of Sessions that feature a 'checkout' event. Using the existing fact_sessions table
- Checkout Events: 361
- Sessions: 578
- Conversion Rate: 62.5%

```
SELECT
    SUM(checkout_ct) AS checkout_events,
    COUNT(*) AS sessions,
    (SUM(checkout_ct) :: DECIMAL) / (COUNT(*) :: DECIMAL) AS conversion_rate
FROM
    dbt_matt_w.fact_sessions
```

### Conversion Rate by Product:

Using the [fact_product_sessions model](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/models/example/marts/marketing/fact_product_sessions.sql)

```
WITH product_session_purchases AS (
        SELECT
            session_id,
            product_id,
            NAME,
            (
                CASE
                    WHEN page_view_ct > 0 THEN 1
                    ELSE 0
                END
            ) AS pageview_in_session,
            (
                CASE
                    WHEN add_to_cart_ct > 0
                    AND checkout > 0 THEN 1
                    ELSE 0
                END
            ) AS purchase_in_session
        FROM
            dbt_matt_w.fact_product_sessions
    )
SELECT
    product_id,
    NAME,
    SUM(purchase_in_session) AS sessions_with_purchases,
    SUM(pageview_in_session) AS sessions_with_pageviews,
    ROUND((SUM(purchase_in_session) :: DECIMAL) / (SUM(pageview_in_session) :: DECIMAL), 2) AS product_conversion_rate
FROM
    product_session_purchases
GROUP BY
    1,
    2
ORDER BY
    5 DESC
```

product_id|name|sessions_with_purchases|sessions_with_pageviews|product_conversion_rate
---|---|---|---|---
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80|String of pearls|39|64|0.61
74aeb414-e3dd-4e8a-beef-0fa45225214d|Arrow Head|35|63|0.56
c17e63f7-0d28-4a95-8248-b01ea354840e|Cactus|30|55|0.55
b66a7143-c18a-43bb-b5dc-06bb5d1d3160|ZZ Plant|34|63|0.54
689fb64e-a4a2-45c5-b9f2-480c2155624d|Bamboo|36|67|0.54
579f4cd0-1f45-49d2-af55-9ab2b72c3b35|Rubber Plant|28|54|0.52
be49171b-9f72-4fc9-bf7a-9a52e259836b|Monstera|25|49|0.51
b86ae24b-6f59-47e8-8adc-b17d88cbd367|Calathea Makoyana|27|53|0.51
e706ab70-b396-4d30-a6b2-a1ccf3625b52|Fiddle Leaf Fig|28|56|0.50
615695d3-8ffd-4850-bcf7-944cf6d3685b|Aloe Vera|32|65|0.49
5ceddd13-cf00-481f-9285-8340ab95d06d|Majesty Palm|33|67|0.49
35550082-a52d-4301-8f06-05b30f6f3616|Devil's Ivy|22|45|0.49
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3|Philodendron|30|62|0.48
a88a23ef-679c-4743-b151-dc7722040d8c|Jade Plant|22|46|0.48
64d39754-03e4-4fa0-b1ea-5f4293315f67|Spider Plant|28|59|0.47
5b50b820-1d0a-4231-9422-75e7f6b0cecf|Pilea Peperomioides|28|59|0.47
37e0062f-bd15-4c3e-b272-558a86d90598|Dragon Tree|29|62|0.47
d3e228db-8ca5-42ad-bb0a-2148e876cc59|Money Tree|26|56|0.46
c7050c3b-a898-424d-8d98-ab0aaad7bef4|Orchid|34|75|0.45
05df0866-1a66-41d8-9ed7-e2bbcddd6a3d|Bird of Paradise|27|60|0.45
843b6553-dc6a-4fc4-bceb-02cd39af0168|Ficus|29|68|0.43
bb19d194-e1bd-4358-819e-cd1f1b401c0c|Birds Nest Fern|33|78|0.42
80eda933-749d-4fc6-91d5-613d29eb126f|Pink Anthurium|31|74|0.42
e2e78dfc-f25c-4fec-a002-8e280d61a2f2|Boston Fern|26|63|0.41
6f3a3072-a24d-4d11-9cef-25b0b5f8a4af|Alocasia Polly|21|51|0.41
e5ee99b6-519f-4218-8b41-62f48f59f700|Peace Lily|27|66|0.41
e18f33a6-b89a-4fbc-82ad-ccba5bb261cc|Ponytail Palm|28|70|0.40
e8b6528e-a830-4d03-a027-473b411c7f02|Snake Plant|29|73|0.40
58b575f2-2192-4a53-9d21-df9a0c14fc25|Angel Wings Begonia|24|61|0.39
4cda01b9-62e2-46c5-830f-b7f262a58fb1|Pothos|21|61|0.34



## Part 2 - Macros:
[Created a macro to pivot out items into aggregated columns](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/macros/pivot_items.sql)

[Model calling the Macro](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/models/example/marts/marketing/fact_sessions_wk3.sql)

[Example of the Model pre-macro](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/models/example/marts/marketing/fact_sessions.sql)

## Part 3 - Hooks:
[Added On Run End Hook to project yml](https://github.com/mattwhiteley/course-dbt/blob/main/greenery/dbt_project.yml)


## Part 4 - Packages: