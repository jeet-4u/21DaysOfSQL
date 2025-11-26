-- Calculate running total of patients admitted by week for each service.
SELECT
    service,
    week,
    patients_admitted,
    SUM(patients_admitted) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM services_weekly
ORDER BY service, week;

-- Find the moving average of patient satisfaction over 4-week periods.
SELECT
    service,
    week,
    patient_satisfaction,
    AVG(patient_satisfaction) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS moving_avg_4_weeks
FROM services_weekly
ORDER BY service, week;

-- Show cumulative patient refusals by week across all services.
SELECT
    week,
    SUM(patients_refused) AS weekly_refused,
    SUM(SUM(patients_refused)) OVER (
        ORDER BY week
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_refusals
FROM services_weekly
GROUP BY week
ORDER BY week;

-- Create a trend analysis showing for each service and week: week number, 
-- patients_admitted, running total of patients admitted (cumulative), 
-- 3-week moving average of patient satisfaction (current week and 2 prior weeks), 
-- and the difference between current week admissions and the service average. Filter for weeks 10-20 only.
SELECT
    service,
    week,
    patients_admitted,
    
    -- Running total (cumulative)
    SUM(patients_admitted) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_admissions,

    -- 3-week moving average of satisfaction
    AVG(patient_satisfaction) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_weeks,

    -- Difference between current admissions and service average
    patients_admitted
        - AVG(patients_admitted) OVER (PARTITION BY service)
        AS diff_from_service_avg

FROM services_weekly
WHERE week BETWEEN 10 AND 20
ORDER BY service, week;


