USE crownfield_eye_hospital; 

-- Query 5 - stored procedure with input parameter 
DELIMITER $$ 

CREATE PROCEDURE get_patient_appointments( 
    IN p_patient_id VARCHAR(10) 
) 
BEGIN 
    SELECT 
        a.appointment_id, 
        a.appointment_date, 
        a.appointment_time, 
        CONCAT(c.first_name, ' ', c.last_name) AS clinician_name, 
        cl.clinic_name, 
        a.status 
    FROM appointment a 
    INNER JOIN clinician c 
        ON a.clinician_id = c.clinician_id 
    INNER JOIN clinic cl 
        ON a.clinic_id = cl.clinic_id 
    WHERE a.patient_id = p_patient_id 
    ORDER BY a.appointment_date; 
END $$ 
DELIMITER ; 
-- Call the procedure using a patient ID
CALL get_patient_appointments('OP001'); 

-- Query 6 - meaningful trigger 

DELIMITER $$ 

 CREATE TRIGGER trg_validate_followup_date 
BEFORE INSERT ON follow_up 
FOR EACH ROW 
BEGIN 
    DECLARE v_appointment_date DATE; 

	SELECT appointment_date 
    INTO v_appointment_date 
    FROM appointment 
    WHERE appointment_id = NEW.appointment_id; 

	IF NEW.due_date < v_appointment_date THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 
        'Follow-up date cannot be before appointment date'; 
    END IF; 
END $$ 

DELIMITER ;

INSERT INTO follow_up
(appointment_id, due_date, priority, status)
VALUES
(14, '2026-11-20', 'Routine', 'Pending');
 
INSERT INTO follow_up
(appointment_id, due_date, priority, status)
VALUES
(14, '2026-11-10', 'Routine', 'Pending');
 
