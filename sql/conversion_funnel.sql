-- Reading funnel per day and platform
WITH by_day AS (
  SELECT
    toDate(timestamp) AS dt,
    platform,
    uniqExactIf(user_id, event = 'book_open') AS openers,
    uniqExactIf(user_id, event = 'page_scroll') AS scrollers,
    uniqExactIf(user_id, event = 'book_finished') AS finishers
  FROM events
  WHERE source = 'reader'
  GROUP BY dt, platform
)
SELECT
  dt, platform, openers, scrollers, finishers,
  finishers / NULLIF(openers, 0) AS finish_rate
FROM by_day
ORDER BY dt, platform;