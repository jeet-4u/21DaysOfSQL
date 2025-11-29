-- Identify where and when the crime happened
SELECT 
    room AS crime_location,
    MIN(found_time) AS crime_time
FROM evidence
GROUP BY room
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Analyze who accessed critical areas at the time
SELECT 
    k.employee_id,
    e.name,
    k.room,
    k.entry_time,
    k.exit_time
FROM keycard_logs k
JOIN employees e ON k.employee_id = e.employee_id
WHERE 
    k.room IN ('CEO Office', 'Server Room') AND
    k.entry_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'
ORDER BY k.entry_time;

-- Cross-check alibis with actual logs
SELECT 
    a.employee_id,
    e.name AS employee_name,
    a.claimed_location,
    a.claim_time,
    k.room AS actual_location,
    k.entry_time,
    k.exit_time
FROM alibis a
JOIN employees e 
    ON a.employee_id = e.employee_id
JOIN keycard_logs k
    ON k.employee_id = a.employee_id
    -- Check if the keycard activity overlaps with the alibi claim time
    AND k.entry_time <= a.claim_time
    AND k.exit_time >= a.claim_time
WHERE a.claimed_location <> k.room;

-- What evidence was revovered from the crime scene?
SELECT
room,
description
FROM evidence
WHERE room = 'CEO office';

-- Identify all callers and receivers between 20:50-21:00
SELECT
e.name,
e.employee_id,
c.caller_id,
c.call_time,
c.duration_sec
FROM employees e
JOIN calls c
ON c.caller_id = e.employee_id
WHERE TIME(c.call_time) BETWEEN '20:50' AND '21:00';

-- Which suspect's location, statements, and phone activity fail to match?
WITH cte AS (
SELECT e.name, keylog.room As actual_location, a.claimed_location,
keylog.entry_time, a.claim_time, keylog.exit_time, c.call_time, c.duration_sec
FROM employees e
JOIN keycard_logs keylog
ON keylog.employee_id = e.employee_id
JOIN alibis a
ON a.employee_id = e.employee_id
JOIN calls c
ON c.caller_id = e.employee_id)
SELECT cl.*, ev.description
FROM cte cl
JOIN evidence ev
ON ev.room = cl.actual_location
WHERE cl.actual_location = 'CEO Office'
AND TIME(cl.call_time) < '21:00';