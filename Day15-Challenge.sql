-- Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT p.patient_id, p.name, p.service, s.staff_id, s.staff_name, ss.present AS staff_availability
FROM patients AS P
JOIN staff AS s ON p.service = s.service 
JOIN staff_schedule AS ss ON s.staff_id = ss.staff_id;

-- Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
SELECT sw.service, sw.week, sw.month, SUM(sw.patients_admitted) AS total_admitted, COUNT(ss.present) AS total_staff_present
FROM services_weekly AS sw
JOIN staff AS s ON sw.service=s.service JOIN staff_schedule AS ss ON s.staff_id=ss.staff_id AND sw.week=ss.week
GROUP BY sw.service, sw.week, sw.month;

-- Create a multi-table report showing patient admissions with staff information.
SELECT s.staff_id,s.staff_name,  sw.service, sw.patients_admitted, ss.present
FROM services_weekly AS sw
JOIN staff AS s ON sw.service=s.service JOIN staff_schedule as ss ON s.staff_id=ss.staff_id;

-- Create a comprehensive service analysis report for week 20 showing: service name, 
-- total patients admitted that week, total patients refused, average patient satisfaction, 
-- count of staff assigned to service, and count of staff present that week. Order by patients admitted descending.
SELECT 
	sw.service, SUM(sw.patients_admitted) AS total_pat_admitted, 
	SUM(sw.patients_refused) AS total_pat_refused,
	ROUND(AVG(sw.patient_satisfaction),2) AS avg_pat_satisfaction, 
	COUNT(DISTINCT s.staff_id) AS staff_assigned_to_service, 
	COUNT(DISTINCT CASE WHEN ss.present = 1 THEN 1 ELSE 0 END) AS staff_present
FROM services_weekly AS sw
JOIN staff AS s ON sw.service=s.service AND sw.week=20 
JOIN staff_schedule AS ss ON s.staff_id=ss.staff_id AND ss.week=20
GROUP BY sw.service
ORDER BY total_pat_admitted DESC;