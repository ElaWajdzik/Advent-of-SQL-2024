-----------------------------
--day 15: Santa is missing!--
-----------------------------

--Author: Ela Wajdzik
--Date: 18.12.2024
--Tool used: PostgreSQL 17.2

--https://adventofsql.com/challenges/15

/*
Using the list of areas you need to find which city the last sleigh_location is located in.
*/

--tables - sleigh_locations, areas

--geometry
--postGIS; ne_10m_populated_places


SELECT 
--find the last location of Santa
    sl.timestamp,
    a.place_name AS area    --name of the city
FROM sleigh_locations sl
LEFT JOIN areas a
ON 
    ST_Contains(
        a.polygon::geometry,    --the geometry of the area
        sl.coordinate::geometry --the geometry of the sleigh location
    )
ORDER BY sl.timestamp DESC
LIMIT 1; 
