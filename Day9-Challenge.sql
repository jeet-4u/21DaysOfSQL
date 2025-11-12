-- Extract the year from all patient arrival dates.
-- select * from patients;
SELECT arrival_date, YEAR(arrival_date) AS arrival_year
FROM patients;

-- Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT arrival_date, departure_date, DATEDIFF(departure_date,arrival_date) AS stay_in_hospital
FROM patients;

-- Find all patients who arrived in a specific month.
SELECT *
FROM patients
WHERE MONTH(arrival_date) = 4;

-- Calculate the average length of stay (in days) for each service, 
-- showing only services where the average stay is more than 7 days. 
-- Also show the count of patients and order by average stay descending.
SELECT 
SERVICE, ROUND(AVG(DATEDIFF(departure_date,arrival_date)),2) AS avg_stay , 
COUNT(*) AS total_patients
FROM patients
GROUP BY service
HAVING avg_stay > 7
ORDER BY avg_stay DESC;