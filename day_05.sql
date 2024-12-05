---------------------------------------
--day 5: Santa's production dashboard--
---------------------------------------

--Author: Ela Wajdzik
--Date: 5.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/5

/*
Analyzes daily toy production trends by comparing each date's production to the previous day's.
*/
-- table - toy_production

-- LAG, ROUND, Window functions

WITH toy_production_analysis AS (
--analyze daily toy production change, comparing today's production to the previous day's.
	SELECT 
		production_date,
	    toys_produced,
	    LAG(toys_produced) OVER (ORDER BY production_date) AS previous_day_units --previous day's production
	FROM toy_production)

SELECT 
--calculate the production change (units and percentage) for each day compared to the previous day
	*,
	toys_produced - previous_day_units AS production_change,
	ROUND((toys_produced - previous_day_units) * 100.0 / previous_day_units, 2) AS production_change_percentage
FROM toy_production_analysis
WHERE previous_day_units IS NOT NULL --filter out the first day with no previous day's data
ORDER BY production_change_percentage DESC --order by the largest percentage change.
LIMIT 5;

