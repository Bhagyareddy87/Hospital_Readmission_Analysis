/* Root Cause Analysis (RCA) */
SELECT * FROM diabetic_data_cleaned
-- 01.Age vs Readmission
-- Do older patients have higher readmission rates?
WITH Age_rate AS
(SELECT age, COUNT(*) AS Patient_Count,
SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
*100.00 / COUNT(*),2) AS Readmission_rate
FROM diabetic_data_cleaned
GROUP BY age)
SELECT*,
DENSE_RANK() OVER(ORDER BY Readmission_rate DESC) AS Rank_Category
FROM Age_rate;

-- 02. Gender vs Readmission
--Are male or female patients more likely to be readmitted within 30 days?
SELECT gender , COUNT(*) AS Patient_Count,
SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
*100.00 / COUNT(*),2) AS Readmission_rate
FROM diabetic_data_cleaned
GROUP BY gender
ORDER BY Readmission_rate DESC

-- 03. Race vs Readmission
-- Do readmission patterns vary across racial groups?
SELECT
    race,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY race
ORDER BY Readmission_Rate DESC;

-- 04. LOS Category vs Readmission
--Do longer hospital stays increase readmission risk?
SELECT
    LOS_Category,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY LOS_Category
ORDER BY Readmission_Rate DESC;

-- 05. Visitor Category vs Readmission
--Are frequent hospital users more likely to be readmitted?
SELECT
    Visitor_Category,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Visitor_Category
ORDER BY Readmission_Rate DESC;

-- 06. Medication Load vs Readmission
-- Does medication burden impact readmission risk?
SELECT
    Medication_Load,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Medication_Load
ORDER BY Readmission_Rate DESC;

-- 07. Clinical Complexity vs Readmission
-- Do patients with multiple diagnoses have higher readmission risk?
SELECT
    Clinical_Complexity,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Clinical_Complexity
ORDER BY Readmission_Rate DESC;

-- 08. Utilization Category vs Readmission
-- Do heavy healthcare users have higher readmission rates?
SELECT
    Utilization_Category,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Utilization_Category
ORDER BY Readmission_Rate DESC;

-- 09. Senior Citizen vs Readmission
-- Are senior citizens more likely to be readmitted?
SELECT
    Senior_Citizen,
    COUNT(*) AS Patient_Count,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS Readmitted_30_Days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Readmission_Rate
FROM diabetic_data_cleaned
GROUP BY Senior_Citizen
ORDER BY Readmission_Rate DESC;

/* =========================================================
                ROOT CAUSE ANALYSIS SUMMARY
=========================================================

Objective:
Identify the major factors contributing to 30-day hospital
readmissions among diabetic patients.

---------------------------------------------------------
1. AGE VS READMISSION
---------------------------------------------------------

Finding:
Patients aged 70-80 and 80-90 contributed the largest number
of readmissions due to their large patient populations.

Business Insight:
Older adults represent the primary population at risk and
should be prioritized for follow-up care.

---------------------------------------------------------
2. GENDER VS READMISSION
---------------------------------------------------------

Finding:
Female patients had a readmission rate of 11.25% compared
to 11.06% for male patients.

Business Insight:
Gender showed minimal impact on readmission risk and is
not a major predictor of readmission.

---------------------------------------------------------
3. RACE VS READMISSION
---------------------------------------------------------

Finding:
Readmission rates were relatively similar across racial
groups, ranging from approximately 10% to 11%.

Business Insight:
Race does not appear to be a strong driver of readmission
within this dataset.

---------------------------------------------------------
4. LENGTH OF STAY (LOS) VS READMISSION
---------------------------------------------------------

Finding:
Patients staying 8+ days had the highest readmission rate
(13.38%), followed by 4-7 days (12.19%) and 1-3 days (9.69%).

Business Insight:
Longer hospital stays are associated with increased
readmission risk and may indicate greater illness severity.

---------------------------------------------------------
5. VISITOR CATEGORY VS READMISSION
---------------------------------------------------------

Finding:
Frequent visitors had a readmission rate of 21.35% compared
to 10.71% for normal visitors.

Business Insight:
Frequent healthcare users are approximately twice as likely
to be readmitted and represent a critical high-risk group.

---------------------------------------------------------
6. MEDICATION LOAD VS READMISSION
---------------------------------------------------------

Finding:
Patients with high medication burden showed the highest
readmission rate (12.78%), while low medication burden
patients had the lowest rate (8.83%).

Business Insight:
Higher medication burden is associated with increased
readmission risk and treatment complexity.

---------------------------------------------------------
7. CLINICAL COMPLEXITY VS READMISSION
---------------------------------------------------------

Finding:
Patients with high clinical complexity had a readmission
rate of 12.06%, compared with 9.44% for medium complexity
and 6.97% for low complexity patients.

Business Insight:
Multiple diagnoses significantly increase the likelihood
of hospital readmission.

---------------------------------------------------------
8. PRIOR UTILIZATION VS READMISSION
---------------------------------------------------------

Finding:
Patients with high prior healthcare utilization had the
highest readmission rate (21.89%), compared to only 8.18%
for patients with no prior visits.

Business Insight:
Previous healthcare utilization is one of the strongest
predictors of future readmissions.

---------------------------------------------------------
9. SENIOR CITIZEN VS READMISSION
---------------------------------------------------------

Finding:
Senior citizens had a readmission rate of 11.85% compared
to 10.59% among non-senior patients.

Business Insight:
Older patients experience higher readmission risk and may
require additional discharge support and monitoring.

---------------------------------------------------------
KEY ROOT CAUSES IDENTIFIED
---------------------------------------------------------

1. High Prior Healthcare Utilization
2. Frequent Hospital Visits
3. Long Hospital Stays
4. High Clinical Complexity
5. High Medication Burden
6. Advanced Age

These factors were identified as the strongest drivers
of hospital readmissions within the diabetic population.

========================================================= */