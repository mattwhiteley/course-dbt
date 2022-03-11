## Week 1 - Answers & SQL:

### How many Users do we have? 
- 130
'''
  SELECT 
      COUNT(DISTINCT id) 
  FROM
      dbt_matt_w.stg_users;
'''

### On average, how many orders do we receive per hour?
- 7.52

'''
WITH hourly_orders AS 
  (
  SELECT
      DATE_TRUNC('day',created_at) AS date,
      DATE_PART('hour',created_at) AS hour,
      COUNT(*) as ct_orders
  FROM dbt_matt_w.stg_orders
  GROUP BY 1,2
  ORDER BY 1 asc, 2 desc
  )

  SELECT
      AVG(ct_orders) 
  FROM 
      hourly_orders;
'''      

### On average, how long does an order take from being placed to being delivered?
- 3 days 21:24:11

'''
  SELECT AVG(delivered_at - created_at) AS difference
  FROM 
      dbt_matt_w.stg_orders;
'''

### How many users have only made one purchase? Two purchases? Three+ purchases?
- 1 order:   25
- 2 orders:  28
- 3+ orders: 71

'''
  --Doesn't include users who made zero orders
  WITH user_orders AS 
  (
  SELECT 
      user_guid, 
      count(*) AS total_orders 
  FROM 
      dbt_matt_w.stg_orders 
  GROUP BY
      user_guid)
  SELECT 
      CASE WHEN total_orders>=3 then '3+' else total_orders::varchar END,
      COUNT(*)
  FROM
      user_orders
  GROUP BY 1
  ORDER BY 1 ASC;

  --Check users who didn't order
  SELECT 
    * 
  FROM
      dbt_matt_w.stg_users u
  FULL OUTER JOIN  
      dbt_matt_w.stg_orders o 
      ON o.user_guid=u.user_guid
  WHERE 
      o.order_id is NULL
      OR u.user_guid is NULL;
'''

### On average, how many unique sessions do we have per hour?
- 16.3

'''
  WITH hourly_sessions AS 
  (
  SELECT
      DATE_TRUNC('day',created_at) AS date,
      DATE_PART('hour',created_at) AS hour,
      COUNT(DISTINCT session_id) AS ct_sessions
  FROM
      dbt_matt_w.stg_events
  GROUP BY 1,2
  ORDER BY 1 ASC, 2 DESC
  )
  SELECT 
      AVG(ct_sessions) 
  FROM
      hourly_sessions;
'''