
-- Project: Healthcare Patient Insights Dashboard

-- Create Tables
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    symptoms VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    visit_id INT,
    drug_name VARCHAR(100),
    dosage VARCHAR(50),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

-- Sample Queries

-- 1. Top 5 most prescribed drugs
SELECT drug_name, COUNT(*) AS total_prescriptions
FROM Prescriptions
GROUP BY drug_name
ORDER BY total_prescriptions DESC
LIMIT 5;

-- 2. Patients with frequent visits (>3)
SELECT p.name, COUNT(*) AS visit_count
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY p.name
HAVING visit_count > 3;

-- 3. Follow-up gap detection (patients not returning for >30 days)
SELECT p.name, MAX(v.visit_date) AS last_visit
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
GROUP BY p.name
HAVING DATEDIFF(CURRENT_DATE, MAX(v.visit_date)) > 30;
