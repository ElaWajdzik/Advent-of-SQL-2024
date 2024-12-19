---------------------------------------
--day 17: Christmas time zone madness--
---------------------------------------

--Author: Ela Wajdzik
--Date: 19.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/17

/*
Find all possible 60-minute meeting windows where all participating workshops are within their business hour.
*/

--table - Workshops

--CTE, Timezone


-- This query calculates the latest start time and the earliest end time for workshops in UTC time zone, based on their business hours.

WITH working_hours_in_utc AS (
	SELECT 
	    *,
		--convert business start and end times to UTC time zone
	    (TIMESTAMP '2024-12-19 ' + business_start_time) AT TIME ZONE timezone AT TIME ZONE 'UTC' AS business_start_utc,
	    (TIMESTAMP '2024-12-19 ' + business_end_time) AT TIME ZONE timezone AT TIME ZONE 'UTC' AS business_end_utc
	FROM Workshops
	)

SELECT 
	TO_CHAR(MAX(business_start_utc), 'HH24:MI:SS') AS max_start_hour_in_utc, --latest start time in UTC
	TO_CHAR(MIN(business_end_utc), 'HH24:MI:SS') AS min_start_hour_in_utc --earliest end time in UTC
FROM working_hours_in_utc;

-- There is no moment when all workshops are operating simultaneously and could have a 60-minute meeting, because the time window between the latest opening (14:30) and the earliest closing (12:30) is empty.
