--------------------------------------------------
--day 3: The greatest Christmas dinner ever! 🍗--
--------------------------------------------------

--Author: Ela Wajdzik
--Date: 3.12.2024
--Tool used: PostgreSQL 17.2


--https://adventofsql.com/challenges/3

/*
Find the most popular dish from past events where more than 78 guests participated.
*/

--cte, xml

WITH menus_with_versions AS (
    -- extract total guests and identify XML version for each menu
	SELECT 
		*,
		(xpath('/*/@version', menu_data))[1]::text AS version,
		CASE (xpath('/*/@version', menu_data))[1]::text
			WHEN '3.0' THEN (xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text::integer
			WHEN '1.0' THEN (xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text::integer
			WHEN '2.0' THEN (xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text::integer
			ELSE 0
		END AS total_guests --extract the total number of guests based on the XML version structure
	FROM christmas_menus),

food_items_78_plus_guests AS (
    -- identify food items in menus with more than 78 guests
	SELECT 
		id,
		version,
		total_guests,
		unnest(xpath('//food_item_id/text()', menu_data))::text AS food_item_id --extract food item IDs from the XML for each menu entry
	FROM menus_with_versions
	WHERE total_guests > 78) --include only menu entries with more than 78 guests

SELECT 
	food_item_id,
	COUNT(*) AS frequency
FROM food_items_78_plus_guests
GROUP BY food_item_id
ORDER BY frequency DESC
LIMIT 1;


--example of xml in one of version
/*
"<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">
<polar_celebration version=""3.0"">
  <event_administration>
    <temporal_data>
      <calendar_details>
        <date_info>
          <year>2024</year>
          <month>12</month>
          <day>25</day>
        </date_info>
        <time_specifics>
          <start_time>18:00</start_time>
          <end_time>23:00</end_time>
        </time_specifics>
      </calendar_details>
    </temporal_data>
    <participant_metrics>
      <attendance_details>
        <headcount>
          <total_present>77</total_present>
          <divisions>
            <craft_division>45</craft_division>
            <logistics_division>32</logistics_division>
          </divisions>
        </headcount>
      </attendance_details>
    </participant_metrics>
    <culinary_records>
      <menu_analysis>
        <item_performance>
          <food_item_id>301</food_item_id>
          <success_metrics>
            <satisfaction_index>3.0</satisfaction_index>
            <reorder_probability>0.11981593305412996</reorder_probability>
          </success_metrics>
        </item_performance>
        <item_performance>
          <food_item_id>271</food_item_id>
          <success_metrics>
            <satisfaction_index>3.9</satisfaction_index>
            <reorder_probability>0.730437990451365</reorder_probability>
          </success_metrics>
        </item_performance>
        <item_performance>
          <food_item_id>267</food_item_id>
          <success_metrics>
            <satisfaction_index>2.4</satisfaction_index>
            <reorder_probability>0.5025128007481285</reorder_probability>
          </success_metrics>
        </item_performance>

            .....

      </menu_analysis>
    </culinary_records>
  </event_administration>
</polar_celebration>"
*/