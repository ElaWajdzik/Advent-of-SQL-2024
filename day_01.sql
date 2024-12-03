-----------------------------------
--day 1: Santa's Gift List Parser--
-----------------------------------

--Author: Ela Wajdzik
--Date: 2.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/1

/*
The challenge: Create a report that helps Santa and the elves understand:
    Each child's primary and backup gift choices
    Their color preferences
    How complex each gift is to make
    Which workshop department should handle the creation
*/

----json, join, case

SELECT 
	c.name,
	wl.wishes->>'first_choice' AS primary_wish,
	wl.wishes->>'second_choice' AS backup_wish,
	wl.wishes->'colors'->>0 AS favorite_color,
	JSON_ARRAY_LENGTH(wl.wishes->'colors') AS color_count,
	CASE tc.difficulty_to_make
		WHEN 1 THEN 'Simple Gift'
		WHEN 2 THEN 'Moderate Gift'
		ELSE 'Complex Gift'
	END AS gift_complexity,
	CASE tc.category
		WHEN 'outdoor' THEN 'Outside Workshop'
		WHEN 'educational' THEN 'Learning Workshop'
		ELSE 'General Workshop'
	END AS workshop_assignment
FROM wish_lists wl
LEFT JOIN children c
    ON c.child_id = wl.child_id
LEFT JOIN toy_catalogue tc
    ON tc.toy_name = wl.wishes->>'first_choice'
ORDER BY name ASC
LIMIT 5;