------------------------------------------
--day 16: Santa's Delivery Time Analysis--
------------------------------------------

--Author: Ela Wajdzik
--Date: 19.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/16

/*
In which timezone has Santa spent the most time?
*/

--tables - sleigh_locations, areas

--LAG, LEAD, Geometry, CTE

WITH time_spent_in_locations AS (
--calculate the total time Santa and his sleigh spent in each area
	SELECT 
	    sl.timestamp AS start_visit,
	    a.place_name,    --name of the city
        --calculate the time spent in the location by subtracting the current timestamp from the next timestamp (using LEAD function)
		(LEAD(sl.timestamp) OVER(ORDER BY sl.timestamp ASC) - sl.timestamp) :: time AS hours_spent
	FROM sleigh_locations sl
	LEFT JOIN areas a
	ON 
	    ST_Contains(
	        a.polygon::geometry,    --the geometry of the area
	        sl.coordinate::geometry --the geometry of the sleigh location
	    )
	)

SELECT 
	place_name,
	SUM(hours_spent) AS total_hours_spent
FROM time_spent_in_locations
GROUP BY place_name
ORDER BY total_hours_spent DESC NULLS LAST;