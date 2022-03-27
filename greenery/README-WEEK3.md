# Week 3 Submission

## Product Metrics

### Top-line Conversion Rate:

Defining as % of Sessions that feature a Checkout Event. Using the Existing fact_sessions table
Checkout Events: 361
Sessions: 578
Conversion Rate: 62.5%

```
SELECT
    SUM(checkout_ct) AS checkout_events,
    COUNT(*) AS sessions,
    (SUM(checkout_ct) :: DECIMAL) / (COUNT(*) :: DECIMAL) AS conversion_rate
FROM
    dbt_matt_w.fact_sessions
```

### Conversion Rate by Product: