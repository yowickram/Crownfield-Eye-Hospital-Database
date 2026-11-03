CREATE DATABASE crownfield_eye_hospital;
USE crownfield_eye_hospital; 
SELECT DATABASE(); 

-- 1.specialty
CREATE TABLE specialty ( 
    specialty_id INT AUTO_INCREMENT PRIMARY KEY, 
    specialty_name VARCHAR(60) NOT NULL UNIQUE ); 
SELECT * FROM Specialty; 

-- 2.Patient 
CREATE TABLE patient ( 
    patient_id VARCHAR(10) PRIMARY KEY, 
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    postcode VARCHAR(10) NOT NULL, 
    date_of_birth DATE, 
    phone VARCHAR(20), 
    email VARCHAR(100) UNIQUE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ); 
SELECT * FROM patient;

-- 3.Clinician 

CREATE TABLE clinician ( 
	clinician_id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    specialty_id INT NOT NULL, 
    email VARCHAR(100) UNIQUE, 

	CONSTRAINT fk_clinician_specialty 
	FOREIGN KEY (specialty_id) 
	REFERENCES specialty(specialty_id)); 
SELECT * FROM clinician;

-- 4.Clinic 

CREATE TABLE clinic ( 
    clinic_id INT AUTO_INCREMENT PRIMARY KEY, 
    clinic_name VARCHAR(80) NOT NULL UNIQUE, 
    address VARCHAR(150) );
SELECT * FROM clinic;

-- 5.Appointment table 

CREATE TABLE appointment ( 
    appointment_id INT AUTO_INCREMENT PRIMARY KEY, 
    patient_id VARCHAR(10) NOT NULL, 
    clinician_id INT NOT NULL, 
    clinic_id INT NOT NULL, 
    appointment_date DATE NOT NULL, 
    appointment_time TIME NOT NULL, 
    notes VARCHAR(255), 
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled', 

    CONSTRAINT chk_appointment_status 
        CHECK (status IN (
        'Scheduled', 
        'Completed', 
		'Cancelled', 
        'Did Not Attend' )), 

	CONSTRAINT fk_appointment_patient 
     FOREIGN KEY (patient_id) 
     REFERENCES patient(patient_id), 

	CONSTRAINT fk_appointment_clinician 
	 FOREIGN KEY (clinician_id) 
	 REFERENCES clinician(clinician_id), 

     CONSTRAINT fk_appointment_clinic 
	 FOREIGN KEY (clinic_id) 
     REFERENCES clinic(clinic_id)); 
SELECT * FROM appointment;

-- 6.Diagnosis table 

CREATE TABLE diagnosis ( 
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY, 
    appointment_id INT NOT NULL, 
    diagnosis_name VARCHAR(100) NOT NULL, 
    diagnosis_notes VARCHAR(255), 

	CONSTRAINT fk_diagnosis_appointment 
	FOREIGN KEY (appointment_id) 
    REFERENCES appointment(appointment_id) 
    ON DELETE CASCADE); 
SELECT * FROM diagnosis;

-- 7.Medicine table 

CREATE TABLE medicine ( 
    medicine_id INT AUTO_INCREMENT PRIMARY KEY, 
    medicine_name VARCHAR(100) NOT NULL UNIQUE ); 
SELECT * FROM medicine;

 -- 8.Prescription table 

CREATE TABLE prescription ( 
    prescription_id INT AUTO_INCREMENT PRIMARY KEY, 
    appointment_id INT NOT NULL, 
    prescription_date DATE NOT NULL, 

     CONSTRAINT fk_prescription_appointment 
	    FOREIGN KEY (appointment_id) 
        REFERENCES appointment(appointment_id) 
        ON DELETE CASCADE ); 
 SELECT * FROM prescription;
 
 --  9.Prescription item table 
CREATE TABLE prescription_item ( 
    prescription_item_id INT AUTO_INCREMENT PRIMARY KEY, 
    prescription_id INT NOT NULL, 
    medicine_id INT NOT NULL, 
    dose VARCHAR(50) NOT NULL, 
    route VARCHAR(30) NOT NULL, 
    frequency VARCHAR(50) NOT NULL, 
    duration_days INT NOT NULL, 

	CONSTRAINT chk_duration 
      CHECK (duration_days > 0), 

     CONSTRAINT uq_prescription_medicine 
       UNIQUE (prescription_id, medicine_id), 

      CONSTRAINT fk_item_prescription 
        FOREIGN KEY (prescription_id) 
        REFERENCES prescription(prescription_id) 
        ON DELETE CASCADE,
        
	  CONSTRAINT fk_item_medicine 
        FOREIGN KEY (medicine_id) 
        REFERENCES medicine(medicine_id));
 SELECT * FROM prescription item;
 
-- 10.Follow-up table 
CREATE TABLE follow_up ( 
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY, 
    appointment_id INT NOT NULL UNIQUE, 
    due_date DATE NOT NULL, 
    priority VARCHAR(20) NOT NULL, 
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', 
     
     CONSTRAINT chk_followup_priority 
        CHECK (priority IN ('Routine', 'High', 'Urgent')), 

     CONSTRAINT chk_followup_status 
         CHECK (status IN ('Pending', 'Booked', 'Completed', 'Cancelled')), 

     CONSTRAINT fk_followup_appointment 
        FOREIGN KEY (appointment_id) 
        REFERENCES appointment(appointment_id) 
        ON DELETE CASCADE ); 
SELECT * FROM follow_up;

USE crownfield_eye_hospital; 
SHOW TABLES;
DESCRIBE patient; 
DESCRIBE appointment; 
DESCRIBE prescription_item; 

-- Specialty values insert
INSERT INTO specialty (specialty_name) 
VALUES 
('Glaucoma'), 
('Retina'), 
('Cornea'), 
('Cataract'), 
('Paediatric Ophthalmology'), 
('Neuro-Ophthalmology'), 
('Oculoplastics'), 
('General Ophthalmology'), 
('Uveitis'), 
('Medical Retina'); 
SELECT * FROM Specialty
ORDER BY specialty_id ASC;

-- Insert clinicians 

INSERT INTO clinician 
(first_name, last_name, specialty_id, email) 
VALUES 
('Maya', 'Shah', 1, 'maya.shah@crownfield.hos'), 
('Leo', 'Grant', 2, 'leo.grant@crownfield.hos'), 
('Priya', 'Nair', 3, 'priya.nair@crownfield.hos'), 
('James', 'Collins', 4, 'james.collins@crownfield.hos'), 
('Sarah', 'Ahmed', 5, 'sarah.ahmed@crownfield.hos'), 
('Peter', 'Wong', 6, 'peter.wong@crownfield.hos'), 
('Helen', 'Brooks', 7, 'helen.brooks@crownfield.hos'), 
('David', 'Okafor', 8, 'david.okafor@crownfield.hos'), 
('Nina', 'Patel', 9, 'nina.patel@crownfield.hos'), 
('Grace', 'Morgan', 10, 'grace.morgan@crownfield.hos'); 
SELECT * FROM clinician;

-- Insert clinic
INSERT INTO clinic (clinic_name, address) 
VALUES 
('City Road', '12 City Road'), 
('Bedford', '5 Bedford Street'), 
('Croydon', '18 High Street'), 
('North Wing', 'Crownfield Hospital North Wing'), 
('South Wing', 'Crownfield Hospital South Wing'), 
('Retina Centre', '22 Medical Avenue'), 
('Glaucoma Suite', '14 Vision Lane'), 
('Cornea Unit', '7 Eye Care Road'), 
('Paediatric Clinic', '10 Children Way'), 
('Urgent Eye Clinic', '1 Emergency Road');
SELECT * FROM clinic;

-- Insert patients 
INSERT INTO patient 
(patient_id, first_name, last_name, postcode, date_of_birth, phone, email) 
VALUES 
('OP001','Amina','Yusuf','NE1 4AB','1981-03-15','0711111111','amina.yusuf@example.test'), 
('OP002','Daniel','Reed','N16 7QP','1975-09-21','0722222222','daniel.reed@example.test'), 
('OP003','Sofia','Bennett','E8 2LD','1990-06-12','0733333333','sofia.bennett@example.test'), 
('OP004','Michael','Okoro','SE6 3RT','1986-11-02','07444444444','michael.okoro@example.test'), 
('OP005','Grace','Taylor','B1 2AA','1968-01-28','07555555555','grace.taylor@example.test'), 
('OP006','Ahmed','Khan','M1 4QT','1959-05-13','07666666666','ahmed.khan@example.test'), 
('OP007','Lucy','Brown','LS1 3AF','2001-08-19','07777777777','lucy.brown@example.test'), 
('OP008','Samuel','Green','S2 4BB','1984-04-08','07888888888','samuel.green@example.test'), 
('OP009','Chloe','Wilson','CV1 5RT','1994-12-11','07999999999','chloe.wilson@example.test');
SELECT * FROM patient;

-- Insert appointment
INSERT INTO appointment 
(patient_id, clinician_id, clinic_id, appointment_date, appointment_time, notes, status) 
VALUES 
('OP001',1,1,'2026-10-05','09:00:00','Review IOP','Completed'), 
('OP002',2,1,'2026-10-05','09:30:00','OCT before review','Completed'), 
('OP001',1,2,'2026-11-16','10:15:00','Visual field test','Scheduled'), 
('OP003',1,1,'2026-10-06','11:00:00','Monitor','Completed'), 
('OP004',3,3,'2026-10-07','14:00:00','Corneal topography','Completed'), 
('OP005',4,4,'2026-10-08','09:00:00','Cataract assessment','Completed'), 
('OP006',8,5,'2026-10-09','11:30:00','General eye review','Completed'), 
('OP007',5,9,'2026-10-10','10:00:00','Paediatric review','Completed'), 
('OP008',2,6,'2026-10-11','13:00:00','Retina review','Completed'), 
('OP009',9,4,'2026-10-12','15:30:00','Inflammation review','Completed'), 
('OP010',6,1,'2026-10-13','10:30:00','Neurological visual assessment','Scheduled');
SELECT * FROM appointment;
SELECT * FROM clinician;
SELECT * FROM patient;

-- Insert patients 
INSERT INTO patient 
(patient_id, first_name, last_name, postcode, date_of_birth, phone, email) 
VALUES 
('OP010','David','Mensah','NG1 1AB','1979-07-30','07000000010','david.mensah@example.test');
SELECT * FROM patient;

 -- Insert diagnoses 
INSERT INTO diagnosis 
(appointment_id, diagnosis_name, diagnosis_notes) 
VALUES 
(12,'Ocular hypertension','Raised intraocular pressure'), 
(13,'Diabetic macular oedema','OCT changes noted'), 
(15,'Glaucoma suspect','Observation required'), 
(16,'Keratoconus','Corneal thinning confirmed'), 
(17,'Cataract','Reduced lens clarity'), 
(18,'Dry eye syndrome','Moderate symptoms'), 
(19,'Amblyopia','Reduced visual acuity'), 
(20,'Retinal vein occlusion','Retinal swelling'), 
(21,'Anterior uveitis','Inflammation present'),
(22,'Optic neuritis','Further investigation required'); 
SELECT * FROM diagnosis;

-- Insert medicines 
INSERT INTO medicine (medicine_name) 
VALUES 
('Latanoprost'),
('Timolol'), 
('Aflibercept'), 
('Sodium chloride drops'), 
('Prednisolone eye drops'), 
('Artificial tears'), 
('Cyclopentolate'), 
('Dorzolamide'), 
('Moxifloxacin'), 
('Acetazolamide');
SELECT * FROM medicine
ORDER BY medicine_id ASC;

-- Insert prescriptions 
INSERT INTO prescription 
(appointment_id, prescription_date) 
VALUES 
(12,'2026-10-05'), 
(13,'2026-10-05'), 
(15,'2026-10-06'), 
(16,'2026-10-07'), 
(17,'2026-10-08'), 
(18,'2026-10-09'), 
(19,'2026-10-10'), 
(20,'2026-10-11'), 
(21,'2026-10-12'), 
(22,'2026-10-13');
SELECT * FROM prescription;

-- Insert prescription items 
INSERT INTO prescription_item 
(prescription_id, medicine_id, dose, route, frequency, duration_days) 
VALUES 
(1,1,'1 drop','Ocular','Once daily',30), 
(1,2,'1 drop','Ocular','Twice daily',30), 
(2,3,'2 mg','Intravitreal','Single dose',1), 
(3,8,'1 drop','Ocular','Twice daily',30), 
(4,4,'1 drop','Ocular','Four times daily',14), 
(5,9,'1 drop','Ocular','Four times daily',7), 
(6,6,'1 drop','Ocular','As required',30), 
(7,7,'1 drop','Ocular','Twice daily',7), 
(8,3,'2 mg','Intravitreal','Single dose',1), 
(9,5,'1 drop','Ocular','Four times daily',14), 
(10,10,'250 mg','Oral','Twice daily',5);
SELECT * FROM prescription_item;

-- Insert follow-up plans 
INSERT INTO follow_up 
(appointment_id, due_date, priority, status) 
VALUES 
(12,'2026-11-16','High','Booked'), 
(13,'2026-11-02','Urgent','Booked'), 
(15,'2027-04-06','Routine','Pending'), 
(16,'2026-12-02','Routine','Pending'), 
(17,'2026-12-03','Routine','Pending'), 
(18,'2026-11-20','Routine','Pending'), 
(19,'2026-12-01','High','Pending'), 
(20,'2026-11-08','Urgent','Pending'), 
(21,'2026-10-26','High','Pending'), 
(22,'2026-11-10','High','Pending');
SELECT * FROM follow_up;

-- Controlled UPDATE 
SELECT * 
FROM follow_up 
WHERE follow_up_id = 13;

UPDATE follow_up 
SET status = 'Completed' 
WHERE follow_up_id = 13; 

-- Verify: 
SELECT * 
FROM follow_up 
WHERE follow_up_id = 13;

-- Controlled DELETE 
INSERT INTO patient 
(patient_id, first_name, last_name, postcode) 
VALUES 
('TEST01','Test','Patient','ZZ1 1ZZ'); 

-- Verify: 
SELECT * 
FROM patient 
WHERE patient_id = 'TEST01';

-- Delete: 
DELETE FROM patient 
WHERE patient_id = 'TEST01';

-- Verify: 
SELECT * 
FROM patient 
WHERE patient_id = 'TEST01';


 



 



 

 