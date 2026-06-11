--Total Records
SELECT COUNT(*) AS Total_rows
FROM diabetic_data
--Total Records- 101766

--Missing Values
SELECT
SUM(CASE WHEN race='?' THEN 1 ELSE 0 END) AS MissingRace,
SUM(CASE WHEN weight='?' THEN 1 ELSE 0 END) AS MissingWeight,
SUM(CASE WHEN payer_code='?' THEN 1 ELSE 0 END) AS MissingPayerCode,
SUM(CASE WHEN medical_specialty='?' THEN 1 ELSE 0 END) AS MissingMedicalSpecialty
FROM diabetic_data;
--Missing Values - 2273	98569	40256	49949

--Gender Distribution
SELECT gender, COUNT(*) AS Patientcount
FROM diabetic_data
GROUP BY gender
--Gender Distribution Male-47055,Female-54708,Unknown/Invalid-3

--Readmission Distribution
SELECT readmitted, COUNT(*) AS Patientcount
FROM diabetic_data
GROUP BY readmitted
HAVING readmitted IN ('<30', '>30')
--Readmission Distribution <30-11357,>30-35545,NO-54864

-- Percentage of readmission encounters
SELECT
ROUND(COUNT(CASE WHEN readmitted = '<30' THEN 1 END)*100
/COUNT(*)
,2) AS Readmission_30_Day_Percentage  
FROM diabetic_data
--11.16% of patient encounters resulted in readmission within 30 days of discharge.

--Age Distribution
SELECT age, COUNT(*) AS Total_patients
FROM diabetic_data
GROUP BY age
ORDER BY age
--Majority of patients belong to age groups above 50 years.*/

/*### Data Profiling Summary
• The dataset contains 101,766 patient encounters.
• Weight, Medical Specialty, and Payer Code contain a significant number of missing values and require special handling during data preparation.
• Female patients (54,708) slightly outnumber male patients (47,055).
• 11.16% of patient encounters resulted in readmission within 30 days of discharge.
• Most readmissions occurred after 30 days (35,545 encounters).
• The 70–80 age group has the highest number of patient encounters (26,068).
• The majority of patients are above 50 years of age, indicating that diabetes-related hospitalizations are more common among older adults.*/







