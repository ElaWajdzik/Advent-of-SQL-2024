--Author: Ela Wajdzik
--Date: 8.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/6

/*
Identify all children who received gifts costing more than the average price of gifts in the North Pole's gift database.
*/
-- tables - children, gifts

-- Subquery, Aggregates

WITH result_all AS (
	SELECT 
		ch.name AS child_name,
		g.name AS gift_name,
		g.price AS gift_price,
		AVG(g.price) OVER() AS avg_price --average price of delivered gifts
	FROM children ch
	LEFT JOIN gifts g
	ON g.child_id = ch.child_id)

SELECT 
	*
FROM result_all
WHERE gift_price > avg_price --select gifts that are more expensive than the average price
ORDER BY gift_price ASC
LIMIT 1; --return only the cheapest gift above the average
