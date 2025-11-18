-- Show all staff members and their schedule information (including those with no schedule entries).
SELECT s.staff_id, s.staff_name, s.role, sw.week, sw.present
FROM staff AS s
LEFT JOIN staff_schedule AS sw ON s.staff_id = sw.staff_id;

-- List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT sw.service, s.staff_name
FROM services_weekly AS sw
LEFT JOIN staff AS s ON sw.service = s.service;

-- Display all patients and their service's weekly statistics (if available).
SELECT p.patient_id, p.name, p.age, p.service, sw.patient_satisfaction
FROM patients AS p
LEFT JOIN services_weekly AS sw ON p.service = sw.service
WHERE sw.patient_satisfaction IS NOT NULL;

-- Create a staff utilisation report showing all staff members 
-- (staff_id, staff_name, role, service) and the count of weeks they 
-- were present (from staff_schedule). Include staff members even if 
-- they have no schedule records. Order by weeks present descending.
SELECT s.staff_id, s.staff_name, s.role, s.service, 
SUM(COALESCE(p.present, 0)) AS weeks_present
FROM staff AS s
LEFT JOIN staff_schedule AS p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service
ORDER BY weeks_present DESC;