----------------------------------------
--day 21: Santa chooses his influencer--
----------------------------------------

--Author: Ela Wajdzik
--Date: 23.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/21


/*
Determine the quarter with the highest growth rate compared to the previous quarter's sales figures.
*/

--table - sales

--extract, LAG, CTE

WITH quarter_sales AS (
--aggregate quarterly sales data
	SELECT 
		DATE_PART('year', sale_date)::INTEGER AS year, --or EXTRACT(year FROM sale_date)
		DATE_PART('quarter', sale_date)::INTEGER AS quarter, --or EXTRACT(quarter FROM sale_date)
		SUM(amount) AS total_sales
 	FROM sales
	GROUP BY DATE_PART('year', sale_date), DATE_PART('quarter', sale_date)
)

SELECT 
--calculate growth rate relative to the previous quarter
	year,
    quarter,
    total_sales,
	(total_sales / LAG(total_sales) OVER (ORDER BY year, quarter)) - 1.0 AS growth_rate
FROM quarter_sales
ORDER BY growth_rate DESC NULLS LAST; --sort by highest growth rate, ignoring NULLs
