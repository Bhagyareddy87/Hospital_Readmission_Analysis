/* # Feature Engineering #
***Creating new business-friendly columns from existing raw data.***
for example - Management doesn't understand:readmitted = <30
			  Management understands:High Risk Patient
That's Feature Engineering.*/

/*Feature 1: Risk Category
Q1.Which patients are high risk?*/
-- Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD Risk_Category VARCHAR(20);
-- Populate COLUMN
UPDATE diabetic_data_cleaned
SET Risk_Category =
CASE
WHEN readmitted = '<30' THEN 'High Risk'
WHEN readmitted = '>30' THEN 'Medium Risk'
ELSE 'Low Risk'
END;
--Verify
SELECT Risk_Category, COUNT(Risk_Category) AS Total_Patients
FROM diabetic_data_cleaned
GROUP BY Risk_Category;

/*Feature 2: LOS Category
Do patients with longer hospital stays get readmitted more?*/
SELECT * FROM diabetic_data_cleaned;
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD LOS_Category VARCHAR(20);
--Populate COLUMN 
UPDATE diabetic_data_cleaned
SET LOS_Category =
CASE 
WHEN time_in_hospital BETWEEN 1 AND 3 THEN '1-3 Days'
WHEN time_in_hospital BETWEEN 4 AND 7 THEN '4-7 Days'
ELSE '8+ Days'
END;
--Verify
SELECT
    LOS_Category,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY LOS_Category
ORDER BY LOS_Category;

/* Feature 3: Visitor Category
Who are the frequent hospital users?*/
SELECT * FROM diabetic_data_cleaned;
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD Visitor_Category VARCHAR (20);
--Populate Column
UPDATE diabetic_data_cleaned
SET Visitor_Category =
CASE
WHEN
(number_outpatient +
 number_emergency +
 number_inpatient) >= 5
THEN 'Frequent Visitor'
ELSE 'Normal Visitor'
END;
--Verify
SELECT Visitor_Category,
COUNT(*) AS PatientCount
FROM diabetic_data_cleaned
GROUP BY Visitor_Category;
--Are frequent hospital visitors more likely to be readmitted?
SELECT
    Visitor_Category,
    readmitted,
    COUNT(*) AS PatientCount
FROM diabetic_data_cleaned
GROUP BY Visitor_Category, readmitted
ORDER BY Visitor_Category;

/* Feature 4: Medication Load Category
Do patients taking many medications have higher readmission risk?*/
SELECT * FROM diabetic_data_cleaned;
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD Medication_load VARCHAR(20);
--Populate COLUMN
UPDATE diabetic_data_cleaned
SET Medication_load =
CASE
WHEN num_medications <10 THEN 'Low'
WHEN num_medications BETWEEN 10 AND 20 THEN 'Medium'
ELSE 'High'
END;
--Verify
SELECT readmitted, Medication_load,COUNT(*) AS Patient_Count
FROM diabetic_data_cleaned
GROUP BY readmitted,Medication_load
ORDER BY Medication_load;

/* Feature 5: Clinical Complexity Category
Do patients with multiple diagnoses get readmitted more often?*/
SELECT * FROM diabetic_data_cleaned;
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD  Clinical_Complexity VARCHAR(20);
--Populate COLUMN
UPDATE diabetic_data_cleaned
SET Clinical_Complexity =
CASE
WHEN number_diagnoses <= 3 THEN 'Low'
WHEN number_diagnoses <= 6 THEN 'Medium'
ELSE 'High'
END;
--VERIFY
SELECT readmitted, Clinical_Complexity, COUNT(*) AS Patient_Count
FROM diabetic_data_cleaned
GROUP BY readmitted, Clinical_Complexity
ORDER BY Clinical_Complexity;

/* Feature 6: Prior Utilization Score
Who are heavy healthcare users?*/
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD Prior_Utilization INT;
ALTER TABLE diabetic_data_cleaned
ADD Utilization_Category VARCHAR(20);

--Populate CLOUMN 
UPDATE diabetic_data_cleaned
SET Prior_Utilization =
number_outpatient +
number_emergency +
number_inpatient;
UPDATE diabetic_data_cleaned
SET Utilization_Category =
CASE
    WHEN Prior_Utilization = 0 THEN 'No Prior Visits'
    WHEN Prior_Utilization BETWEEN 1 AND 3 THEN 'Low'
    WHEN Prior_Utilization BETWEEN 4 AND 7 THEN 'Medium'
    ELSE 'High'
END;
--Verify
SELECT
    Utilization_Category,
    COUNT(*) AS PatientCount
FROM diabetic_data_cleaned
GROUP BY Utilization_Category;
--Do heavy healthcare users have higher readmission rates?
SELECT
    Utilization_Category,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Utilization_Category
ORDER BY Readmission_Rate DESC;

/* Feature 7: Senior Citizen Flag
Are elderly patients more likely to be readmitted?*/
--Create COLUMN
ALTER TABLE diabetic_data_cleaned
ADD Senior_Citizen VARCHAR(10);
-- Populate COLUMN
UPDATE diabetic_data_cleaned
SET Senior_Citizen =
CASE
WHEN age IN ('[70-80)','[80-90)','[90-100)')
THEN 'Senior'
ELSE 'Non-Senior'
END;
--Verify
SELECT readmitted, Senior_Citizen,COUNT(*) AS Patient_count
FROM diabetic_data_cleaned
GROUP BY Senior_Citizen,readmitted
ORDER BY readmitted,Senior_Citizen

/*# Feature Engineering Summary

The feature engineering phase transformed raw healthcare data into business-friendly attributes that support patient risk assessment and readmission analysis.
The following derived features were created:

1. Risk_Category
    * Categorized patients as High Risk, Medium Risk, or Low Risk based on readmission status.

2. LOS_Category
   * Grouped patients by length of stay to evaluate the relationship between hospitalization duration and readmission.

3. Visitor_Category
   * Identified frequent healthcare users based on prior hospital visits.

4. Medication_Load
   * Categorized patients according to medication burden to assess treatment complexity.

5. Clinical_Complexity
   * Measured patient complexity using the number of diagnoses recorded.

6. Prior_Utilization and Utilization_Category
   * Quantified previous healthcare utilization and classified patients into utilization groups.

7. Senior_Citizen
   * Identified elderly patients for age-based risk analysis.

These engineered features simplify business reporting and provide meaningful dimensions for exploratory analysis, root cause analysis, patient segmentation, and dashboard development.
