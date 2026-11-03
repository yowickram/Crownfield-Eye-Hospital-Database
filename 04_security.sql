USE crownfield_eye_hospital;
CREATE ROLE 
	'hospital_admin', 
    'doctor_role', 
    'receptionist_role', 
    'patient_role'; 

GRANT ALL PRIVILEGES 
ON crownfield_eye_hospital.* 
TO 'hospital_admin'; 

-- Doctor privileges 

GRANT SELECT 
ON crownfield_eye_hospital.* 
TO 'doctor_role'; 

GRANT INSERT, UPDATE 
ON crownfield_eye_hospital.diagnosis 
TO 'doctor_role'; 

GRANT INSERT, UPDATE 
ON crownfield_eye_hospital.prescription 
TO 'doctor_role'; 

GRANT INSERT, UPDATE 
ON crownfield_eye_hospital.prescription_item 
TO 'doctor_role'; 

GRANT INSERT, UPDATE 
ON crownfield_eye_hospital.follow_up 
TO 'doctor_role'; 

-- Receptionist privileges 

GRANT SELECT, INSERT, UPDATE 
ON crownfield_eye_hospital.patient 
TO 'receptionist_role'; 

GRANT SELECT, INSERT, UPDATE 
ON crownfield_eye_hospital.appointment 
TO 'receptionist_role'; 

GRANT SELECT 
ON crownfield_eye_hospital.clinic 
TO 'receptionist_role'; 

-- patient role:created a limited view
CREATE VIEW patient_appointment_summary AS 
SELECT 
    a.patient_id, 
    a.appointment_id, 
    a.appointment_date, 
    a.appointment_time, 
    a.status, 
    cl.clinic_name 
FROM appointment a 
JOIN clinic cl 
    ON a.clinic_id = cl.clinic_id; 

-- Grant patient role access to the view
GRANT SELECT 
ON 
crownfield_eye_hospital.patient_appointment_summary 
TO 'patient_role'; 

-- Create example users 

CREATE USER 'admin_user'@'localhost' 
IDENTIFIED BY 'AdminExample!2026'; 

CREATE USER 'doctor_user'@'localhost' 
IDENTIFIED BY 'DoctorExample!2026'; 

CREATE USER 'reception_user'@'localhost' 
IDENTIFIED BY 'ReceptionExample!2026'; 

CREATE USER 'patient_user'@'localhost' 
IDENTIFIED BY 'PatientExample!2026';

-- Assign roles to users

GRANT 'hospital_admin' 
TO 'admin_user'@'localhost'; 

GRANT 'doctor_role' 
TO 'doctor_user'@'localhost'; 

GRANT 'receptionist_role' 
TO 'reception_user'@'localhost'; 

GRANT 'patient_role' 
TO 'patient_user'@'localhost';

-- SET DEFAULT ROLES

SET DEFAULT ROLE ALL TO
'admin_user'@'localhost', 
'doctor_user'@'localhost', 
'reception_user'@'localhost', 
'patient_user'@'localhost'; 

-- Verify user permissions
 
SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'doctor_user'@'localhost';
SHOW GRANTS FOR 'reception_user'@'localhost';
SHOW GRANTS FOR 'patient_user'@'localhost';

-- password hashing demonstration
CREATE TABLE app_user ( 
    app_user_id INT AUTO_INCREMENT PRIMARY KEY, 
    username VARCHAR(50) NOT NULL UNIQUE, 
    password_hash CHAR(64) NOT NULL, 
    user_type VARCHAR(20) NOT NULL, 
	CHECK (user_type IN ( 
        'Administrator', 
        'Doctor', 
        'Receptionist', 
        'Patient')) 
); 

INSERT INTO app_user 
(username, password_hash, user_type) 
VALUES 
( 
    'doctor_demo', 
    SHA2('ExamplePassword123!', 256), 
    'Doctor' 
); 

-- display the hashed password

SELECT 
    username, 
    password_hash, 
    user_type 
FROM app_user; 

USE crownfield_eye_hospital; 
DESCRIBE patient;

-- Test 1:Duplicate patient ID (expected to fail)
INSERT INTO patient 
(patient_id, first_name, last_name, postcode) 
VALUES 
('OP001','Duplicate','Patient','ZZ1 1ZZ'); 

-- Test 2:invalid appointment status(expected to fail)

INSERT INTO appointment 
(patient_id, clinician_id, clinic_id, 
 appointment_date, appointment_time, status) 
VALUES 
('OP001',1,1,'2026-12-01','09:00:00','Finished'); 

-- Test 3: Invalid patient foreign key(expected to fail)

INSERT INTO appointment 
(patient_id, clinician_id, clinic_id, 
 appointment_date, appointment_time) 
VALUES 
('OP999',1,1,'2026-12-01','09:00:00');

-- Test 4: Duplicate medicine name (expected to fail)
INSERT INTO medicine
(medicine_name)
VALUES
('Latanoprost');





 
 