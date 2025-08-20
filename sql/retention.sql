-- Simple D1/D7 retention by install date (first seen date per user)
WITH first_seen AS (
  SELECT user_id, min(toDate(timestamp)) AS install_dt
  FROM events
  GROUP BY user_id
),
user_activity AS (
  SELECT e.user_id, toDate(e.timestamp) AS dt
  FROM events e
  GROUP BY e.user_id, toDate(e.timestamp)
)
SELECT
  f.install_dt,
  countDistinctIf(a.user_id, a.dt = f.install_dt) AS day0,
  countDistinctIf(a.user_id, a.dt = date_add('day', 1, f.install_dt)) AS day1_retained,
  countDistinctIf(a.user_id, a.dt = date_add('day', 7, f.install_dt)) AS day7_retained,
  day1_retained / day0 AS d1_retention,
  day7_retained / day0 AS d7_retention
FROM first_seen f
LEFT JOIN user_activity a ON a.user_id = f.user_id
GROUP BY f.install_dt
ORDER BY f.install_dt;