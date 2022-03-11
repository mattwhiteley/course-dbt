Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


Week 1 - SQL:
--How many Users do we have?
select count(*) from dbt_matt_w.stg_users;

--On average, how many orders do we receive per hour?
WITH hourly_orders as 
(select
DATE_TRUNC('day',created_at) as date,
date_PART('hour',created_at) as hour,
count(*) as ct_orders
from dbt_matt_w.stg_orders
group by 1,2
order by 1 asc, 2 desc)
SELECT avg(ct_orders) from hourly_orders;

--On average, how long does an order take from being placed to being delivered?
WITH order_delivery_lag as (
SELECT 
created_at,
delivered_at,
extract (EPOCH from (delivered_at - created_at)) as difference
FROM dbt_matt_w.stg_orders o
where o.status='delivered')
select 
avg(difference)/3600 as diff_hours,
avg(difference)/86400 as diff_days from order_delivery_lag;


--How many users have only made one purchase? Two purchases? Three+ purchases?
WITH user_orders as (SELECT user_guid, count(*) as total_orders FROM dbt_matt_w.stg_orders group by user_guid)
select 
CASE WHEN total_orders>=3 then '3+' else total_orders::varchar END,
count(*)
from user_orders
group by 1
order by 1 asc;

--Check users who did't order
select 
  * 
from  dbt_matt_w.stg_users u
FULL OUTER JOIN  dbt_matt_w.stg_orders o 
on o.user_guid=u.user_guid
where o.order_id is NULL OR u.user_guid is NULL;

--On average, how many unique sessions do we have per hour?
WITH hourly_sessions as 
(select
DATE_TRUNC('day',created_at) as date,
date_PART('hour',created_at) as hour,
count(DISTINCT session_id) as ct_sessions
from dbt_matt_w.stg_events
group by 1,2
order by 1 asc, 2 desc)
SELECT avg(ct_sessions) from hourly_sessions;