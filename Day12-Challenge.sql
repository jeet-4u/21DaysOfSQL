-- Find all weeks in services_weekly where no special event occurred.
SELECT DISTINCT week
FROM services_weekly
WHERE event = 'none'
OR event is NULL;

-- Count how many records have null or empty event values.
SELECT COUNT(event) AS empty_event_values
FROM services_weekly
WHERE event IS NULL
OR event = 'none';

-- List all services that had at least one week with a special event.
SELECT DISTINCT(service)
FROM services_weekly
WHERE event IS NULL
OR event = 'none';

-- Analyze the event impact by comparing weeks with events vs weeks without events. 
-- Show: event status ('With Event' or 'No Event'), count of weeks, average patient 
-- satisfaction, and average staff morale. Order by average patient satisfaction descending.
SELECT 
CASE
	WHEN event IS NULL OR event = 'none' THEN 'No Event'
    ELSE 'With Event'
END AS event_status,
COUNT(*) AS week_count,
ROUND(AVG(patient_satisfaction),2) AS avg_patient_satisfaction,
ROUND(AVG(staff_morale),2) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;