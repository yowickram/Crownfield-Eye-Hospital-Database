-- Query 1 - GROUP BY + HAVING 
USE crownfield_eye_hospital; 
SELECT 
    c.clinician_id, 
    CONCAT(c.first_name, ' ', c.last_name) 
AS clinician_name, 
    COUNT(a.appointment_id) AS 
appointment_count 
FROM clinician c 
JOIN appointment a 
    ON c.clinician_id = a.clinician_id 
GROUP BY 
    c.clinician_id, 
    c.first_name, 
    c.last_name 
HAVING COUNT(a.appointment_id) >= 2;

-- Query 2 - INNER JOIN across at least 3 tables 
SELECT 
    a.appointment_id, 
    CONCAT(p.first_name, ' ', p.last_name) 
AS patient_name, 
    CONCAT(c.first_name, ' ', c.last_name) 
AS clinician_name, 
    cl.clinic_name, 
    a.appointment_date, 
    a.appointment_time, 
    a.status 
FROM appointment a 
INNER JOIN patient p 
    ON a.patient_id = p.patient_id 
INNER JOIN clinician c 
    ON a.clinician_id = c.clinician_id 
INNER JOIN clinic cl 
    ON a.clinic_id = cl.clinic_id 
ORDER BY a.appointment_date; 

-- Query 3 - LEFT JOIN 
SELECT 
    a.appointment_id, 
    a.appointment_date, 
    CONCAT(p.first_name, ' ', p.last_name) 
AS patient_name, 
    d.diagnosis_name 
FROM appointment a 
INNER JOIN patient p 
    ON a.patient_id = p.patient_id 
LEFT JOIN diagnosis d 
    ON a.appointment_id = d.appointment_id 
WHERE d.diagnosis_id IS NULL;

-- Query 4 - subquery 
SELECT 
    c.clinician_id, 
    CONCAT(c.first_name, ' ', c.last_name) 
AS clinician_name, 
    COUNT(a.appointment_id) 
AS appointment_count 

FROM clinician c 

JOIN appointment a 
    ON c.clinician_id = a.clinician_id 
    
GROUP BY 
    c.clinician_id, 
    c.first_name, 
    c.last_name 
    
HAVING COUNT(a.appointment_id) > 
( 
    SELECT AVG(appointment_total) 
    FROM 
    ( 
        SELECT COUNT(*) AS appointment_total 
        FROM appointment 
        GROUP BY clinician_id 
    ) AS clinician_counts); 
