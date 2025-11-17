-- Join patients and staff based on their common 
-- service field (show patient and staff who work in same service).
SELECT p.patient_id, p.name, p.service, s.staff_name
FROM patients AS p
JOIN staff AS s ON p.service=s.service;
select * from staff_schedule;

-- Join services_weekly with staff to show weekly service data with staff information. 
SELECT *
FROM staff AS S
JOIN services_weekly AS p ON s.service=p.service;

-- Create a report showing patient information along with staff assigned to their service.
SELECT p.patient_id, p.name, p.age, p.service, s.staff_id, s.staff_name, s.role
FROM patients AS p
JOIN staff AS s ON p.service=s.service;

-- Create a comprehensive report showing patient_id, patient name, age, service, 
-- and the total number of staff members available in their service. 
-- Only include patients from services that have more than 5 staff members. 
-- Order by number of staff descending, then by patient name.
SELECT p.patient_id, p.name, p.age, p.service, COUNT(s.staff_id) AS total_staff
FROM patients AS  p
JOIN staff AS s ON p.service=s.service
GROUP BY p.patient_id, p.name, p.age, p.service
HAVING total_staff > 5
ORDER BY total_staff DESC, name ASC;