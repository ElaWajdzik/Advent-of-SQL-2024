-----------------------------------
--day 18: Who has the most peers?--
-----------------------------------

--Author: Ela Wajdzik
--Date: 19.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/18

/*
Finds the number of peers for the employee who has the highest number of peers. Peers are defined 
as employees who share both the same manager and the same level within the organizational hierarchy.
*/

--table - staff

--Recursive CTE, Aggregates

WITH RECURSIVE hierarchy AS(
	SELECT 
		staff_id,
		staff_name,
		1 AS level,
		CAST(staff_id AS VARCHAR) AS path_hierarchy,
		manager_id
	FROM staff
	WHERE manager_id IS NULL --select root-level employees

	UNION ALL

	SELECT 
		s.staff_id,
		s.staff_name,
		level + 1 AS level,
		CONCAT(h.path, ',', s.staff_id) AS path_hierarchy,
		s.manager_id
	FROM staff s
	INNER JOIN hierarchy h
	ON h.staff_id = s.manager_id)

SELECT 
	*,
	COUNT(*) OVER(PARTITION BY manager_id) AS peers_same_manager, --count peers with the same supervisor
	COUNT(*) OVER(PARTITION BY level) AS total_peers_same_level --count peers at the same hierarchy level
FROM hierarchy
ORDER BY total_peers_same_level DESC, level ASC, staff_id ASC;

