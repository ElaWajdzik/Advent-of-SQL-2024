--------------------------------------
--day 12: The Great Gift Ranking 🧢--
--------------------------------------

--Author: Ela Wajdzik
--Date: 14.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/12

/*
Find the toy with the second highest percentile of requests. Submit the name of the toy and the percentile value.
*/

--tables - gifts, gift_requests

--percentile, window functions


SELECT 
--calculate the percentile rank of requests for each toy
	g.gift_name,
	ROUND(CAST(PERCENT_RANK() OVER (ORDER BY COUNT(*) ASC) AS NUMERIC),2) AS overall_rank
FROM gift_requests gr
INNER JOIN gifts g
	ON g.gift_id = gr.gift_id --join with the gifts table to get toy names
GROUP BY g.gift_name
ORDER BY overall_rank DESC, g.gift_name ASC;

/*
You can use the LIMIT and OFFSET clauses if there is a need to restrict the number of results
returned by the query. For example, LIMIT 1 OFFSET 1 can be used to skip the first result and
return only the second-highest ranked item.
*/