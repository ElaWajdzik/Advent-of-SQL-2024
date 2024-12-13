--------------------------------------------------------
--day 8: The Great North Pole Bureaucracy Bust of 2024--
--------------------------------------------------------

--Author: Ela Wajdzik
--Date: 12.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/8

/*
Create an organizational hierarchy for all employees.
*/
--table - staff

--recursive_cte


WITH RECURSIVE staff_hierarchy AS (
--recursive CTE to generate staff hierarchy

    -- Base case: Select root-level staff (those with no manager)
    SELECT 
        staff_id,
        staff_name,
        manager_id,
        CAST(staff_id AS VARCHAR) AS hierarchy_path, --initialize hierarchy path with the root staff_id
        1 AS level -- level 1 for top-level staff
    FROM staff s
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Build hierarchy by joining subordinates to their managers
    SELECT 
        s.staff_id,
        s.staff_name,
        s.manager_id,
        CONCAT(h.hierarchy_path, ',', s.staff_id) AS hierarchy_path, --append staff_id to the hierarchy path
        h.level + 1 AS level --increment the level
    FROM staff s
    INNER JOIN staff_hierarchy h
    ON s.manager_id = h.staff_id --join subordinates with their respective managers
)


SELECT 
    staff_id,
    staff_name,
    level, --level in the hierarchy
    hierarchy_path --full path from root to the current staff member
FROM staff_hierarchy
ORDER BY level DESC;


/*
Generating a sequence of numbers:

WITH RECURSIVE numbers AS (
    
    --Start with the number 1
    SELECT 1 AS n

    UNION ALL

    --recursive case: add 1 to the previous value
    SELECT n + 1
    FROM numbers
    WHERE n < 10 -- termination condition
)
SELECT *
FROM numbers;
*/