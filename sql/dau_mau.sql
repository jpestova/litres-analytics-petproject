-- DAU & MAU with ratio (ClickHouse-flavored)
WITH daily AS (
  SELECT
    toDate(timestamp) AS dt,
    countDistinct(user_id) AS dau
  FROM events
  GROUP BY dt
),
monthly AS (
  SELECT
    toStartOfMonth(timestamp) AS month,
    countDistinct(user_id) AS mau
  FROM events
  GROUP BY month
)
SELECT d.dt, d.dau, m.mau, d.dau / m.mau AS dau_mau_ratio
FROM daily d
JOIN monthly m ON toStartOfMonth(d.dt) = m.month
ORDER BY d.dt;