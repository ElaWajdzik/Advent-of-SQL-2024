-------------------------------------
--day 19: Performance review season--
-------------------------------------

--Author: Ela Wajdzik
--Date: 19.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/19

/*
What is the total salary paid to all employees, including bonuses?

Employees are eligible for a bonus if their last performance review score exceeds the average last 
performance review score of all employees. The bonus amounts to an additional 15% of their base salary.
*/

--table - employees

--CROSS JOIN, SUM, ROUND

WITH avg_performance_score AS (
--calculate the average performance score
    SELECT 
        AVG(year_end_performance_scores[array_length(year_end_performance_scores, 1)]) AS average_score
    FROM employees
),

employee_bonuses AS (
--calculate the bonus for each employee based on their last performance score
	SELECT
		employee_id,
		name,
		salary,
		CASE 
			WHEN COALESCE(year_end_performance_scores[array_length(year_end_performance_scores,1)],0) > a.average_score 
				THEN ROUND(salary * 0.15, 2) --15% bonus for employees exceeding the average
			ELSE 0
		END AS bonus
	FROM employees
	CROSS JOIN avg_performance_score a
)

SELECT 
--calculate the total salary including bonuses
 	SUM(salary) + SUM(bonus) AS total_salary_with_bonuses
FROM employee_bonuses;

