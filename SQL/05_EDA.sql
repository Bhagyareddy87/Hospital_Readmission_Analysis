-- # EDA Section 1: Executive KPIsSELECT #

/*Exploring the cleaned data to understand patterns, trends, and relationships.*/
-- Q1. How many unique patients exist?
SELECT COUNT(DISTINCT patient_nbr) AS Total_Patients
FROM diabetic_data_cleaned
-- 71515 Total_Patients

-- Q2. How many hospital encounters occurred?
SELECT COUNT(*) AS Total_Encounters
FROM diabetic_data_cleaned;
-- 101763 Total_Encounters

-- Q3. What percentage of encounters result in readmission within 30 days?
SELECT
ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
*100.00/COUNT(*),2) AS readmission_percentage
FROM diabetic_data_cleaned;
--11.16 readmission_percentage

-- Q4. How long do patients stay in the hospital?
SELECT
SUM(time_in_hospital)/COUNT(*)
FROM diabetic_data_cleaned;
/* # OR # */
SELECT
ROUND(AVG(time_in_hospital),2) AS Avg_LOS
FROM diabetic_data_cleaned;
-- 4 Avg_LOS

-- Q5. How many medications are patients receiving?
SELECT 
ROUND(AVG(num_medications),2) AS Average_Medications
FROM diabetic_data_cleaned;
--  16 Average_Medications

-- Q6.How many laboratory tests are performed per encounter?
SELECT
ROUND(AVG(num_lab_procedures),2) AS Avg_Lab_Procedures
FROM diabetic_data_cleaned;
-- Avg_Lab_Procedures 43

-- # EDA Section 2: Population Overview #

/* Who are our patients? */
-- AGE DISTRIBUTION
SELECT age, COUNT(*) AS Patient_Count
FROM diabetic_data_cleaned
GROUP BY age
ORDER BY Patient_Count DESC;

-- GENDER DISTRIBUTION
SELECT
gender,
COUNT(*) AS Patient_Count
FROM diabetic_data_cleaned
GROUP BY gender
ORDER BY Patient_Count DESC;

-- RACE DISTRIBUTION
SELECT
race,
COUNT(*) AS Patient_Count
FROM diabetic_data_cleaned
GROUP BY race
ORDER BY Patient_Count DESC;

/* =========================================================
                    EDA SUMMARY
=========================================================

Objective:
To understand the patient population, measure key healthcare
KPIs, and establish baseline metrics before identifying
factors contributing to hospital readmissions.

Key Findings:

1. Total Unique Patients: 71,515
   - Indicates multiple patients had repeated hospital encounters.

2. Total Hospital Encounters: 101,763
   - Reflects overall healthcare utilization across diabetic patients.

3. 30-Day Readmission Rate: 11.16%
   - Approximately 1 in 9 encounters resulted in readmission
     within 30 days of discharge.

4. Average Length of Stay (LOS): 4 Days
   - Most patients experienced relatively short hospital stays.

5. Average Medications per Encounter: 16
   - Indicates a moderate to high medication burden among patients.

6. Average Laboratory Procedures per Encounter: 43
   - Suggests extensive clinical monitoring and testing.

7. Age Distribution
   - Highest patient volume observed in the 70-80 age group.
   - Majority of encounters involved patients aged 50 years and above.

8. Gender Distribution
   - Female patients accounted for a slightly higher number of
     encounters compared to male patients.

9. Race Distribution
   - Majority of patients were Caucasian, followed by
     African American patients.

Conclusion:
The dataset primarily represents an elderly diabetic population
with an 11.16% 30-day readmission rate, moderate hospital
utilization, and high clinical activity. These findings provide
the foundation for Root Cause Analysis to identify the major
drivers of hospital readmissions.

========================================================= */

