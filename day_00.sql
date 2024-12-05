-------------------------------------------------------
--day 0: The Great Christmas Analytics Crisis of 2024--
-------------------------------------------------------

--Author: Ela Wajdzik
--Date: 5.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/0

/*
Find the top cities in each country (max top 3 cities for each country) with the highest average naughty_nice_score 
for children who received gifts, but only include cities with at least 5 children. 
*/

-- tables
--      children
--      gifts
--      reindeer
--      christmaslist

-- CTE, Window functions, Aggregations

SELECT 
-- summarize the number of children and their average nice scores by city and country
	ch.city,
	ch.country,
	COUNT(*) AS children_count,
	AVG(ch.naughty_nice_score) AS avg_nice_score
FROM children ch
LEFT JOIN christmaslist clist
ON clist.child_id = ch.child_id	--join with the christmas list to find delivered gifts
WHERE clist.was_delivered = 'true'	--only include records where gifts were delivered

GROUP BY ch.city, ch.country
HAVING COUNT(*) >= 5	--include only city-country groups with at least 5 children
ORDER BY avg_nice_score DESC;
