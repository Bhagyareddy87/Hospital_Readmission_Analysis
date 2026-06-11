-- creating the Healthcare_Readmission_DB
CREATE DATABASE Healthcare_Readmission_DB;

-- to use the ealthcare_Readmission_DB
USE Healthcare_Readmission_DB;
-- Verify Import
--Verify Row Count
SELECT COUNT(*) FROM diabetic_data
--Check Column Count
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='diabetic_data'
