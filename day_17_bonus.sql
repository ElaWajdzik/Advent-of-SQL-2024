---------------------------------------------
--day 17 BONUS: Christmas time zone madness--
---------------------------------------------

--Author: Ela Wajdzik
--Date: 19.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/17

/*
Find the 60-minute time windows during which the maximum number of workshops can participate within their business hours.
*/

--table - Workshops

--CTE, Timezone, generate_series

WITH working_hours_in_utc AS (
	SELECT 
	    workshop_id,
		--convert business start and end times to UTC time zone
	    (TIMESTAMP '2024-12-19 ' + business_start_time) AT TIME ZONE timezone AT TIME ZONE 'UTC' AS business_start_utc,
	    (TIMESTAMP '2024-12-19 ' + business_end_time) AT TIME ZONE timezone AT TIME ZONE 'UTC' AS business_end_utc
	FROM Workshops
	),

workshop_hours AS (
	SELECT 
        workshop_id,
		--generate time slots (every 30 minutes) between business start and end times
		TO_CHAR(generate_series(
            business_start_utc, 
            business_end_utc - INTERVAL '1 second', 
            INTERVAL '30 minutes'), 'HH24:MI') AS hour
    FROM working_hours_in_utc
	)

SELECT 
--select time slots and count the number of workshops that can participate in each slot
	hour,
	COUNT(*) AS number_of_workshops
FROM workshop_hours
GROUP BY hour
ORDER BY number_of_workshops DESC, hour ASC;