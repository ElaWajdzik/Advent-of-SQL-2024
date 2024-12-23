-----------------------------------------
--day 20: Santa takes on Site Analytics--
-----------------------------------------

--Author: Ela Wajdzik
--Date: 21.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/20


/*
Find the URL with the most query parameters that include `utm_source=advent-of-sql` in the query string.
*/

--table - web_requests

--JSON, CTE, JSON_OBJECT_AGG


WITH url_with_parameters AS (
--extract query parameters from the URL as individual key-value pairs
	SELECT 
        url,
        unnest(string_to_array(split_part(url, '?', 2), '&')) AS all_parameters
    FROM web_requests
	),

url_with_parameters_json AS (
--convert the extracted parameters into a JSONB object for easier manipulation
	SELECT 
	    url,
	    jsonb_object_agg(
            split_part(all_parameters, '=', 1), --extract the key (before '=')
            split_part(all_parameters, '=', 2) --extract the value (after '=')
        ) AS query_parameters
	FROM url_with_parameters
	GROUP BY url
	)

SELECT 
	url,
	query_parameters,
	array_length(
        array(SELECT jsonb_object_keys(query_parameters)), --count the keys in the JSONB object
        1
    ) AS count_params
FROM url_with_parameters_json
WHERE query_parameters ->> 'utm_source' = 'advent-of-sql'
ORDER BY count_params DESC, url ASC
LIMIT 1;