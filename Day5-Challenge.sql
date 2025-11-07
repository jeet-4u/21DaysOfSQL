-- Count the total number of patients in the hospital.
SELECT COUNT(*) AS total_patients
FROM patients;

-- Calculate the average satisfaction score of all patients.
SELECT AVG(satisfaction) as avg_score
FROM patients;

-- Find the minimum and maximum age of patients.
SELECT MIN(age) as min_age, MAX(age) as max_age
FROM patients;

-- Calculate the total number of patients admitted,
-- total patients refused, and the average patient
-- satisfaction across all services and weeks.
-- Round the average satisfaction to 2 decimal places.
SELECT COUNT(patients_admitted) AS total_patients, COUNT(patients_refused)  as patients_refused,
ROUND(AVG(patient_satisfaction),2) as avg_satisfaction
FROM services_weekly;