----------------------------------------------
--day 4: The Great Toy Tag Migration of 2024--
----------------------------------------------

--Author: Ela Wajdzik
--Date: 4.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/4

/*
Find the toy with the most added tags, (there is only 1). Submit the toy_id, added_tags length, unchanged_tags length, removed_tags length.
*/
-- table - toy_production

-- Array functions, SET operations

WITH tag_changes_analysis AS (
--identify changes in toy tags (added, unchanged, and removed tags)
	SELECT 
		toy_id,
		toy_name,

		-- tags added in the new version of the toy
		ARRAY(
			SELECT DISTINCT tag
			FROM unnest(new_tags) AS tag
			WHERE tag NOT IN (SELECT unnest(previous_tags))
		) AS added_tags,

		-- tags that remain unchanged between versions
		ARRAY(
			SELECT DISTINCT tag
			FROM unnest(previous_tags) AS tag
			WHERE tag = ANY(new_tags)
		) AS unchanged_tags,

		-- tags removed in the new version of the toy
		ARRAY(
			SELECT DISTINCT tag
			FROM unnest(previous_tags) AS tag
			WHERE tag NOT IN (SELECT unnest(new_tags))
		) AS removed_tags
	FROM toy_production
	)

SELECT 
--count the number of added, unchanged, and removed tags for each toy
	toy_id,
	COALESCE(array_length(added_tags, 1),0) AS added_tags_count,
	COALESCE(array_length(unchanged_tags, 1),0) AS unchanged_tags_count,
	COALESCE(array_length(removed_tags, 1), 0) AS removed_tags_count
FROM tag_changes_analysis
ORDER BY added_tags_count DESC
LIMIT 1;


-- example:
-- toy_id = 1
-- previous_tags
--			ARRAY['vintage', 'frosty', 'energizing', 'strategic', 'snowy', 'child-friendly', 'color-changing', 'contemporary', 'classic', 'soft', 'safety-tested', 'squeezable', 'bendable', 'all-ages', 'modern', 'rare', 'exciting', 'santa-approved', 'light-up', 'motion-sensing', 'outdoor', 'collectible', 'size-changing', 'educational', 'animated', 'polar-protected', 'self-wrapping', 'mechanical', 'transforming', 'empowering', 'wind-up', 'athletic', 'poseable', 'traditional', 'voice-activated', 'multicolor', 'scientific', 'analog', 'rainbow', 'enchanted', 'jingling', 'battery-powered', 'shape-shifting', 'mathematical', 'artistic', 'stackable', 'therapeutic', 'durable']
-- new_tags
--			ARRAY['squeezable', 'artistic', 'santa-approved', 'flying', 'workshop-exclusive', 'wind-up', 'elven-made', 'reindeer-tested', 'puzzle', 'toddler-safe', 'snowy', 'pearlescent', 'eco-friendly', 'shape-shifting', 'strategic', 'artisanal', 'north-pole-certified', 'floating', 'twinkling', 'portable', 'analog', 'wooden', 'temperature-sensitive', 'teen-approved', 'smart', 'sparkly', 'safety-tested', 'athletic', 'metallic', 'soft', 'recycled', 'energizing', 'electronic', 'rainbow', 'calming', 'size-changing', 'mysterious', 'imaginative', 'collectible', 'musical', 'magical', 'building', 'contemporary', 'light-up', 'therapeutic', 'self-wrapping', 'outdoor', 'glowing', 'cheerful', 'pastel', 'stackable', 'multicolor', 'iridescent', 'mechanical', 'plush', 'indoor', 'limited-edition', 'all-ages', 'voice-activated', 'enchanted', 'child-friendly', 'arctic-safe', 'inspiring', 'weatherproof', 'educational', 'battery-powered', 'transforming', 'festive', 'polar-protected', 'parent-approved', 'exciting', 'motion-sensing', 'frosty', 'poseable', 'timeless', 'mathematical']


------------
--second version using functions
------------


--function to calculate the difference between two arrays
--returns elements in `array1` that are not present in `array2`
CREATE OR REPLACE FUNCTION array_difference(array1 TEXT[], array2 TEXT[])
RETURNS TEXT[] AS $$
BEGIN
    RETURN ARRAY(
        SELECT elem
        FROM unnest(array1) AS elem -- breaks `array1` into individual elements
        WHERE elem NOT IN (SELECT unnest(array2)) -- excludes elements found in `array2`
    );
END;
$$ LANGUAGE plpgsql;

--function to calculate the intersection of two arrays
--returns elements that are present in both `array1` and `array2`
CREATE OR REPLACE FUNCTION array_intersection(array1 TEXT[], array2 TEXT[])
RETURNS TEXT[] AS $$
BEGIN
    RETURN ARRAY(
        SELECT elem
        FROM unnest(array1) AS elem --breaks `array1` into individual elements
        WHERE elem = ANY(array2) --includes elements also found in `array2`
    );
END;
$$ LANGUAGE plpgsql;



SELECT 
--uses the above functions to identify added, unchanged, and removed tags
    toy_id, 
    toy_name,
    array_difference(new_tags, previous_tags) AS added_tags,
    array_intersection(new_tags, previous_tags) AS unchanged_tags, 
    array_difference(previous_tags, new_tags) AS removed_tags 
FROM toy_production;
