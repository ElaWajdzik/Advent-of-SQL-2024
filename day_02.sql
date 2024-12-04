----------------------------------
--day 2: Santa's jumbled letters--
----------------------------------

--Author: Ela Wajdzik
--Date: 3.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/2

/*
Decode the message contained in these tables. They contain pieces of a child's 
Christmas wish, but they're all mixed up with magical interference from 
the Northern Lights!

Valid characters
    All lower case letters a - z
    All upper case letters A - Z
    Special characters Space   !   "   '   (   )   ,   -   .   :   ;   ?
*/

--union, cte, ascii, string_agg

WITH letters_without_noise AS (
	SELECT *
	FROM letters_a
	WHERE 
		(
		value IN (32,33,34,39,40,41,44,45,46,58,59,63) --special characters
		OR value BETWEEN 65 AND 90 --upper case letters
		OR value BETWEEN 97 AND 122 --lower case letters
		)
	UNION
	SELECT *
	FROM letters_b
	WHERE 
		(
		value IN (32,33,34,39,40,41,44,45,46,58,59,63) --special characters
		OR value BETWEEN 65 AND 90 --upper case letters
		OR value BETWEEN 97 AND 122 --lower case letters
		)
	)

SELECT 
	STRING_AGG(
		CHR(value), --the CHR function returns the character corresponding to the given ASCII code
		''
		ORDER BY id ASC)
FROM letters_without_noise;


--final message: "Dear Santa, I hope this letter finds you well in the North Pole! I want a SQL course for Christmas!"