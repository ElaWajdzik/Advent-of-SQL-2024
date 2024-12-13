-------------------------------------------------
--day 10: The Christmas party drinking list 🍸--
-------------------------------------------------

--Author: Ela Wajdzik
--Date: 13.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/10

/*
Find the date when the following total quantities of drinks were consumed:
    Hot  Cocoa: 38
    Peppermint Schnapps: 298
    Eggnog: 198
*/

--table - drinks

--pivot, CTE

WITH list_of_dates AS (
--get a distinct list of all dates from the drinks table
	SELECT 
		date
	FROM drinks
	GROUP BY date
	),

pivot_table AS (
--a pivot table to sum the quantities of each drink by date
	SELECT 
		ld.date,
		SUM(CASE d.drink_name 
				WHEN 'Eggnog' THEN d.quantity
				ELSE 0 
			END) AS eggnog,
		SUM(CASE d.drink_name 
				WHEN 'Hot Cocoa' THEN d.quantity
				ELSE 0 
			END) AS hot_cocoa,
		SUM(CASE d.drink_name 
				WHEN 'Peppermint Schnapps' THEN d.quantity
				ELSE 0 
			END) AS peppermint_schnapps
	FROM list_of_dates ld
	INNER JOIN drinks d 
		ON d.date = ld.date
	GROUP BY ld.date)

SELECT 
--filter the results to find the date where the specific quantities were consumed
	*
FROM pivot_table
WHERE eggnog = 198
AND hot_cocoa = 38
AND peppermint_schnapps = 298;