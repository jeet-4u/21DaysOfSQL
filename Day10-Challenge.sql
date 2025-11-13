-- Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT name , 
CASE
	WHEN satisfaction >= 85 THEN 'High'
    WHEN satisfaction >=75 THEN 'Medium'
    ELSE 'Low'
END AS satisfaction_score
FROM patients;

-- Label staff roles as 'Medical' or 'Support' based on role type.
SELECT staff_name,
CASE
	WHEN role = 'doctor' THEN 'Medical'
    ELSE 'Support'
END AS staff_role
FROM staff;

-- Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT patient_id,name , 
CASE
	WHEN age BETWEEN 0 AND 18 THEN '0-18 (Minor)'
    WHEN age BETWEEN 19 AND 40 THEN '19-40 (Adult)'
    WHEN age BETWEEN 41 AND 65 THEN '41-65 (Middle Aged)'
    ELSE '65+ (SENIOR)'
END AS age_group
FROM patients;

-- Create a service performance report showing service name, 
-- total patients admitted, and a performance category based on 
-- the following: 'Excellent' if avg satisfaction >= 85, 
-- 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. 
-- Order by average satisfaction descending.
SELECT service, SUM(patients_admitted) AS total_patients_admitted,
AVG(patient_satisfaction) AS avg_satisfaction,
CASE
	WHEN AVG(patient_satisfaction) >= 85 THEN 'Excellent'
	WHEN AVG(patient_satisfaction) >= 75 THEN 'Good'
	WHEN AVG(patient_satisfaction) >= 65 THEN 'Fair'
	ELSE 'Needs Improvement'
END AS performance_category
FROM services_weekly
GROUP BY service
ORDER BY avg_satisfaction DESC;
