-----------------------------------------------------------
--day 23: 🎄 The Case of the Missing Reindeer ID Tags 🦌--
-----------------------------------------------------------

--Author: Ela Wajdzik
--Date: 23.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/23


/*
Find the missing tags.
*/

--table - sequence_table

--CTE, LEAD, Island problem


WITH sequence_with_next AS (
--generate a table with each `id` and the next `id` in the sequence
	SELECT 
		id,
		LEAD(id) OVER(order BY id) AS next_id
	FROM sequence_table)

SELECT 
--identify gaps between consecutive IDs and generate the missing numbers
	id + 1 AS gap_start,
	next_id - 1 AS gap_end,
	ARRAY(SELECT GENERATE_SERIES(id + 1, next_id - 1)) AS missing_numbers --array of missing numbers

FROM sequence_with_next
WHERE next_id - id > 1;


--The second version usig the islend problem

WITH numbers AS (
--step 1: Assign a unique row number to each `id` for creating groups
	SELECT 
		id,
		ROW_NUMBER() OVER(ORDER BY id) AS rn
	FROM sequence_table
	),

grouped AS (
--step 2: Calculate a group key by subtracting the row number from the `id`
--this allows grouping consecutive numbers into "islands"
	SELECT 
		id,
		id - rn AS group_key
	FROM numbers
	),

islands AS (
--step 3: Find the boundaries (start and end) of each "island"
	SELECT 
		min(id) AS start_id,
		max(id) AS end_id
	FROM grouped
	GROUP BY group_key
	),

gaps AS (
--step 4: Identify gaps between consecutive islands
	SELECT
		end_id + 1 AS gap_start, 
		LEAD(start_id) OVER(ORDER BY start_id) - 1 AS gap_end
	FROM islands
	)

SELECT 
--step 5: Generate the missing numbers for each identified gap
	gap_start,
	gap_end,
	ARRAY(SELECT GENERATE_SERIES(gap_start, gap_end)) AS missing_numbers
FROM gaps
WHERE gap_end IS NOT NULL;