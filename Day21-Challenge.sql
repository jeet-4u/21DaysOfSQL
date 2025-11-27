-- Create a CTE to calculate service statistics, then query from it.
WITH service_stats AS (
    SELECT
        service,
        SUM(patients_admitted) AS total_admissions,
        SUM(patients_refused) AS total_refusals,
        AVG(patient_satisfaction) AS avg_satisfaction,
        AVG(staff_morale) AS avg_morale
    FROM services_weekly
    GROUP BY service
)
SELECT
    service,
    total_admissions,
    total_refusals,
    ROUND(avg_satisfaction, 2) AS avg_satisfaction,
    ROUND(avg_morale, 2) AS avg_morale
FROM service_stats
ORDER BY total_admissions DESC;

-- Use multiple CTEs to break down a complex query into logical steps.
WITH total AS (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admitted
    FROM services_weekly
    GROUP BY service
),
avg_values AS (
    SELECT 
        AVG(total_admitted) AS avg_admissions
    FROM total
)
SELECT
    service,
    total_admitted,
    total_admitted - (SELECT avg_admissions FROM avg_values) AS diff_from_avg
FROM total
ORDER BY total_admitted DESC;

-- Build a CTE for staff utilization and join it with patient data.
WITH staff_util AS (
    SELECT
        service,
        COUNT(*) AS staff_count
    FROM staff
    GROUP BY service
)

SELECT
    p.patient_id,
    p.name AS patient_name,
    p.service,
    p.satisfaction,
    u.staff_count
FROM patients p
JOIN staff_util u
    ON p.service = u.service
ORDER BY p.service, p.name;

-- Create a comprehensive hospital performance dashboard using CTEs. Calculate: 1) Service-level metrics 
-- (total admissions, refusals, avg satisfaction), 2) Staff metrics per service (total staff, avg weeks present), 3) 
-- Patient demographics per service (avg age, count). Then combine all three CTEs to create a final report showing service name, 
-- all calculated metrics, and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.
WITH service_stats AS (
    SELECT service,SUM(patients_admitted) AS total_admissions,SUM(patients_refused) AS total_refusals,AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
),
staff_stats AS (
    SELECT service,COUNT(*) AS total_staff,AVG(present) AS avg_weeks_present
    FROM staff_schedule
    GROUP BY service
),
patient_stats AS (
    SELECT service,AVG(age) AS avg_age,COUNT(*) AS total_patients
    FROM patients
    GROUP BY service
)
SELECT 
	s.service,
    s.total_admissions,
    s.total_refusals,
    ROUND(s.avg_satisfaction, 2) AS avg_satisfaction,st.total_staff,
    ROUND(st.avg_weeks_present, 1) AS avg_weeks_present,p.total_patients,
    ROUND(p.avg_age, 1) AS avg_age,
    ROUND(
        (s.total_admissions * 0.6) +
        (s.avg_satisfaction * 0.4),
        2
    ) AS performance_score
FROM service_stats s
LEFT JOIN staff_stats st
    ON s.service = st.service
LEFT JOIN patient_stats p
    ON s.service = p.service
ORDER BY performance_score DESC;