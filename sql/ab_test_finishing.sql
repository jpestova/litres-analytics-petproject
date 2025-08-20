-- AB test: does badge notification (group B) increase finishing rate?
-- Finish rate is book_finished/book_open for reader source.
WITH user_open AS (
  SELECT user_id, any(ab_group) AS ab_group
  FROM events
  WHERE source = 'reader' AND event = 'book_open'
  GROUP BY user_id
),
opens AS (
  SELECT user_id, countIf(event = 'book_open') AS opens
  FROM events
  WHERE source = 'reader'
  GROUP BY user_id
),
finishes AS (
  SELECT user_id, countIf(event = 'book_finished') AS finishes
  FROM events
  WHERE source = 'reader'
  GROUP BY user_id
)
SELECT
  u.ab_group,
  sum(finishes.finishes) AS total_finishes,
  sum(opens.opens) AS total_opens,
  total_finishes / NULLIF(total_opens, 0) AS finish_rate
FROM user_open u
LEFT JOIN opens ON opens.user_id = u.user_id
LEFT JOIN finishes ON finishes.user_id = u.user_id
GROUP BY u.ab_group;