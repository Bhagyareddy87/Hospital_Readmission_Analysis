--Create Backup,to Keep original raw data unchanged.
SELECT * INTO diabetic_data_backup
FROM diabetic_data;

--Create Cleaned Table,Perform all cleaning on this table.
SELECT *
INTO diabetic_data_cleaned
FROM diabetic_data;

--Replace missing Race.
UPDATE diabetic_data_cleaned
SET race = 'Unknown'
WHERE race = '?';
--Verify:
SELECT race, COUNT(*)
FROM diabetic_data_cleaned
GROUP BY race

--Replace missing Payer Code.
UPDATE diabetic_data_cleaned
SET payer_code='Unknown'
WHERE payer_code='?';

--Replace missing Medical Specialty.
UPDATE diabetic_data_cleaned
SET medical_specialty='Unknown'
WHERE medical_specialty='?';

--Handle Weight,96.86% missing,Do NOT use weight in analysis.
UPDATE diabetic_data_cleaned
SET weight='Unknown'
WHERE weight='?';
--Weight column excluded from major analysis due to excessive missing values.

--Remove Invalid Gender
DELETE
FROM diabetic_data_cleaned
WHERE gender='Unknown/Invalid';
--Verify:
SELECT gender, COUNT(*)
FROM diabetic_data_cleaned
GROUP BY gender;

--Cleaning Validation
SELECT COUNT(*)
FROM diabetic_data_cleaned;

/*  # Data Cleaning Summary #

The data cleaning process was performed to improve data quality and prepare the dataset for analysis.

Key cleaning activities included:

* Created a backup table to preserve the original dataset.
* Created a separate cleaned table for all transformation activities.
* Replaced missing values ('?') in race, payer_code, medical_specialty, and weight with 'Unknown'.
* Removed 3 records with invalid gender values ('Unknown/Invalid').
* Retained all valid patient encounter records to avoid unnecessary data loss.
* Identified that the weight column contains approximately 96.86% missing values and will not be used for major analytical insights.

## Key Decisions

* Missing demographic and administrative values were retained as 'Unknown' instead of deleting records.
* Invalid gender records were removed due to their negligible count.
* Weight was retained in the dataset but excluded from meaningful analysis because of excessive missing data.

## Outcome

The dataset is now cleaner, more consistent, and ready for Feature Engineering, Exploratory Data Analysis (EDA), and Readmission Risk Analysis.*/
