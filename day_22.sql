-----------------------------------------
--day 22: Conscripting SQL loving elves--
-----------------------------------------

--Author: Ela Wajdzik
--Date: 23.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/22


/*
Find all the elves who have 'SQL' as a skill. Count each elf only once. 
Only the skill 'SQL' is valid, similar skills like 'MySQL' do not count.
*/

--table - elves

--SPLIT, CROSS JOIN

SELECT 
--count the number of elves who have "SQL" as a skill, without duplicates
	COUNT(*) AS numofelveswithsql 
FROM elves
WHERE skills ~ '((^|,)SQL(,|$))'; --match "SQL" at the beginning, middle (comma-separated), or end of the skills list

