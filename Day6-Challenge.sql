-- Count the number of patients by each service.
SELECT service, COUNT(*) as total_patients
FROM patients
GROUP BY service;

-- Calculate the average age of patients grouped by service.
SELECT service, ROUND(AVG(age), 2) AS avg_age
FROM patients
GROUP BY service;

-- Find the total number of staff members per role.
SELECT service, COUNT(*) as no_of_staff
FROM staff
GROUP BY service;

-- For each hospital service, calculate the 
-- total number of patients admitted, total patients refused,
-- and the admission rate (percentage of requests that were admitted). 
-- Order by admission rate descending.
SELECT service,
SUM(patients_admitted) AS total_admitted,
SUM(patients_refused) AS total_refused,
(SUM(patients_admitted) * 100.0) / (SUM(patients_admitted) + SUM(patients_refused)) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate DESC;
