------------------------------------
--day 24: Santas banging tunes 🎶--
------------------------------------

--Author: Ela Wajdzik
--Date: 30.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/24


/*
Find the most popular song by determining the one with the highest number of plays and the lowest number of skips, in that order.
*/

--tables - user_plays, users, songs

--CTE, Count

WITH song_plays AS (
	SELECT 
		s.song_title,
		1 AS has_played,
		CASE 
			--if user's play duration is less than the song's total duration or is NULL, consider it a skip
			WHEN up.duration < s.song_duration OR up.duration IS NULL THEN 1 
			ELSE 0
		END AS has_skipped
	FROM songs s
	LEFT JOIN user_plays up
	ON up.song_id = s.song_id
	)

SELECT 
--aggregate data to find the total plays and skips for each song
	song_title,
	SUM(has_played) AS total_plays,
	SUM(has_skipped) AS total_skips
FROM song_plays
GROUP BY song_title
ORDER BY total_plays DESC, total_skips ASC
LIMIT 10;