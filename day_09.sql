----------------------------------------
--day 9: Reindeer Training Records 🦌--
----------------------------------------

--Author: Ela Wajdzik
--Date: 13.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/9

/*
Analyze speed records for each reindeer and find the new leaders.
*/
--tables - training_sessions, reindeers

--CTE, Aggregate functions


WITH average_speeds AS (
--the average speed for each reindeer and exercise
	SELECT 
		reindeer_id,
		exercise_name,
		ROUND(AVG(speed_record), 2) AS avg_speed
	FROM training_sessions
	GROUP BY reindeer_id, exercise_name 
	),

ranked_average_speeds AS (
--rank the average speeds for each reindeer across different exercises
	SELECT 
		*,
		--rank the average speeds for each reindeer, highest speed first
		ROW_NUMBER() OVER(PARTITION BY reindeer_id ORDER BY avg_speed DESC) AS rank --
	FROM average_speeds
	)
	
SELECT 
--select the best-performing exercise for each reindeer
	r.reindeer_name,
	s.avg_speed
FROM reindeers r
INNER JOIN ranked_average_speeds s
	ON s.reindeer_id = r.reindeer_id
WHERE s.rank = 1
ORDER BY s.avg_speed DESC
LIMIT 3;