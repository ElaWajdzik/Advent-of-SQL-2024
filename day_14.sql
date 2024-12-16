----------------------------------------
--day 14: Where is Santa's green suit?--
----------------------------------------

--Author: Ela Wajdzik
--Date: 16.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/14

/*
Find the dry cleaning receipt for Santa's green suit.
*/

--table - SantaRecords

--array functions, json functions


WITH all_santa_records AS (
	SELECT 
		record_id,
		record_date,
		jsonb_array_elements(cleaning_receipts) AS receipt_details --expand JSON array into individual rows
	FROM SantaRecords
	)

SELECT 
	receipt_details ->> 'color' AS color,
	receipt_details ->> 'garment' AS garment,
	(receipt_details ->> 'drop_off')::date AS drop_off,
	record_id,
	record_date,
	receipt_details
FROM all_santa_records
WHERE receipt_details ->> 'garment' = 'suit' --filter for suits only
AND receipt_details ->> 'color' = 'green' --filter for green color only
ORDER BY drop_off DESC;