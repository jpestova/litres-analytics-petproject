-- Top genres by unique users and finishes
SELECT
  genre,
  countDistinct(user_id) AS users,
  sum(event = 'book_finished') AS finishes_reader,
  sum(event = 'track_finished') AS finishes_player
FROM events
GROUP BY genre
ORDER BY users DESC
LIMIT 20;