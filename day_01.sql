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

--example of wishes 
--"{""colors"":[""Brown"",""Purple"",""White"",""Yellow"",""Purple""],""first_choice"":""LEGO blocks"",""second_choice"":""Toy trains""}"

--json, join, case

SELECT 
	c.name,
	wl.wishes->>'first_choice' AS primary_wish,
	wl.wishes->>'second_choice' AS backup_wish,
	COALESCE(wl.wishes->'colors'->>0, 'no color') AS favorite_color,
	JSON_ARRAY_LENGTH(wl.wishes->'colors') AS color_count,
	CASE tc.difficulty_to_make
		WHEN 1 THEN 'Simple Gift'
		WHEN 2 THEN 'Moderate Gift'
		ELSE 'Complex Gift'
	END AS gift_complexity, --description of the gift complexity
	CASE tc.category
		WHEN 'outdoor' THEN 'Outside Workshop'
		WHEN 'educational' THEN 'Learning Workshop'
		ELSE 'General Workshop'
	END AS workshop_assignment --workshop assignment based on the toy category
FROM wish_lists wl
LEFT JOIN children c
    ON c.child_id = wl.child_id --join wish lists with children by child ID
LEFT JOIN toy_catalogue tc
    ON tc.toy_name = wl.wishes->>'first_choice' --match toy catalog with the child's first choice of toy
ORDER BY name ASC
LIMIT 5;