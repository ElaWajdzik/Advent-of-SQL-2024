--Author: Ela Wajdzik
--Date: 12.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/7

/*
Identify pairs of elves sharing the same primary_skill.
*/
-- table - workshop_elves

-- CTE, window_function


WITH workshop_elves_with_ranking AS (
--rank elves based on their experience for each skill
	SELECT 
		elf_id,
		primary_skill,
        --rank the least experienced elf for each skill
		ROW_NUMBER() OVER(PARTITION BY primary_skill ORDER BY years_experience ASC, elf_id ASC) AS ranking_less_experience_elf,
		--rank the most experienced elf for each skill
        ROW_NUMBER() OVER(PARTITION BY primary_skill ORDER BY years_experience DESC, elf_id ASC) AS ranking_most_experience_elf
	FROM workshop_elves
    ),

elves_with_most_experience AS (
--select elves with the most experience for each skill
	SELECT 
		elf_id,
		primary_skill
	FROM workshop_elves_with_ranking
	WHERE ranking_most_experience_elf = 1
    ),

elves_with_less_experience AS (
--select elves with the least experience for each skill
	SELECT
		elf_id,
		primary_skill
	FROM workshop_elves_with_ranking
	WHERE ranking_less_experience_elf = 1
    )

SELECT 
--pair elves with the most and least experience in each skill
	em.elf_id AS max_years_experience_elf_id,
	el.elf_id AS min_years_experience_elf_id,
	em.primary_skill AS shared_skill
FROM elves_with_most_experience em
LEFT JOIN elves_with_less_experience el
ON em.primary_skill = el.primary_skill;

/*
The difference between ROW_NUMBER() and RANK() is that ROW_NUMBER() assigns a unique 
sequential number to each row, while RANK() assigns the same rank to rows with tied values, 
causing gaps in the ranking sequence.

In this case, the functions ROW_NUMBER() and RANK() will give the same effect because in 
the ORDER BY clause I use elf_id (a column with unique values).
*/