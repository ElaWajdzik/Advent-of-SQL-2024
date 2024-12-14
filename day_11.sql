-----------------------------------------
--day 11: The Christmas tree famine 🎄--
-----------------------------------------

--Author: Ela Wajdzik
--Date: 13.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/11

/*
Analyze the tree farms. Show the 3-season moving average per field, per season, per year.
*/

--table - TreeHarvests

--Average over, Window functions

WITH tree_harvests_with_order AS( 
--add season order to the TreeHarvests table to ensure the correct seasonal sequence
	SELECT 
		*,
		CASE season
			WHEN 'Spring' THEN 1
			WHEN 'Summer' THEN 2
			WHEN 'Fall' THEN 3
			WHEN 'Winter' THEN 4 
		END AS season_order --numeric order for seasons to enable proper sorting
	FROM TreeHarvests)

SELECT 
--calculate the 3-season moving average per field, per season, and per year
	field_name,
	harvest_year,
	season,
	ROUND(AVG(trees_harvested) 
		OVER(
			PARTITION BY field_name, harvest_year 
			ORDER BY season_order 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW --define window to include the current season and the two preceding seasons
		)
	,2) AS three_season_moving_avg  --calculate the 3-season moving average and round to 2 decimal places
FROM tree_harvests_with_order
ORDER BY three_season_moving_avg DESC;


/*
{ROWS | RANGE} BETWEEN  <początek przedziału ramki> AND <koniec przedziału ramki>

Określanie rozmiaru ramki:
	* UNBOUNDED PRECEDING – wszystkie rekordy od początku ramki (poprzedzające wiersz, dla którego ramka jest wyznaczana)
	* <unsigned integer> PRECEDING – konkretna liczba wierszy poprzedzających
	* CURRENT ROW – reprezentuje konkretny, bieżący wiersz dla którego wyznaczana jest ramka
	* <unsigned integer> FOLLOWING – konkretna liczba wierszy następujących po danym elemencie
	* UNBOUNDED FOLLOWING – wszystkie wiersze do końca podzbioru okna

*/