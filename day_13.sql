-----------------------------------------
--day 13: Santas Christmas card list 💌--
-----------------------------------------

--Author: Ela Wajdzik
--Date: 15.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/13

/*
Create a list of all the domains that exist in the contacts list emails.
*/

--table - contact_list

--Window functions, Temporary tables, Array agg


WITH contact_email_addresses AS(
--extract individual email addresses and their corresponding domains
	SELECT
		UNNEST(email_addresses)::text AS email_address, --flatten the array and cast to text
		SPLIT_PART(UNNEST(email_addresses)::text, '@', 2) AS domain --extract domain part of the email
	FROM contact_list)

SELECT 
--aggregate data by domain
	domain,
	COUNT(*) AS total_users,
	ARRAY_AGG(email_address) AS users
FROM contact_email_addresses
GROUP BY domain
ORDER BY total_users DESC;