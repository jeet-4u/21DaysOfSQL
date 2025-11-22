SELECT * FROM patients;
SELECT * FROM services_weekly;
SELECT * FROM staff;
SELECT * FROM staff_schedule;
-- Show each patient with their service's average satisfaction as an additional column.
SELECT p.service, (SELECT ROUND(AVG(satisfaction),2)
	FROM patients
    WHERE service = p.service) AS avg_satisfaction
FROM patients p
GROUP BY p.service;

-- Create a derived table of service statistics and query from it.
SELECT *
FROM (SELECT service,
        SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused,
        ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction,
        ROUND(AVG(staff_morale), 2) AS avg_morale
    FROM services_weekly
    GROUP BY service
) AS service_stats;

-- Display staff with their service's total patient count as a calculated field.
SELECT staff_id,staff_name,service,(SELECT SUM(patients_admitted)
        FROM services_weekly sw
        WHERE sw.service = s.service) AS total_service_patients
FROM staff s;


-- Create a report showing each service with: service name, total patients admitted, 
-- the difference between their total admissions and the average admissions across all services, 
-- and a rank indicator ('Above Average', 'Average', 'Below Average'). Order by total patients admitted descending.
SELECT 
    s.service,
    s.total_admitted,
    ROUND(s.total_admitted - overall.avg_admitted, 2) AS diff_from_avg,
    CASE
        WHEN s.total_admitted > overall.avg_admitted THEN 'Above Average'
        WHEN s.total_admitted = overall.avg_admitted THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admitted
    FROM services_weekly
    GROUP BY service
) AS s
CROSS JOIN (
    SELECT AVG(total_admitted) AS avg_admitted
    FROM (
        SELECT 
            service,
            SUM(patients_admitted) AS total_admitted
        FROM services_weekly
        GROUP BY service
    ) AS t
) AS overall
ORDER BY s.total_admitted DESC;
