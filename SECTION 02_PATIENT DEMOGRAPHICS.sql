-- ============================================================
-- SECTION 2: PATIENT DEMOGRAPHICS
-- ============================================================
 
-- 2.1 Gender distribution with percentage(using window function-over-)
SELECT
    CASE gender 
	WHEN 'M' THEN 'Male' 
	WHEN 'F' THEN 'Female' 
	ELSE 'Unknown' 
	END AS gender,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM admissions
GROUP BY gender
ORDER BY patient_count DESC;
 
-- 2.2 Urban vs Rural patient distribution
-- Important for public health — rural patients may have delayed presentation
SELECT
    CASE rural 
	WHEN 'R' THEN 'Rural' 
	WHEN 'U' THEN 'Urban' 
	ELSE 'Unknown' 
	END AS 'location',
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM admissions
GROUP BY rural
ORDER BY count DESC;
 
-- 2.3 Age group segmentation using clinical brackets (using CTE)
-- Standard epidemiological age banding for cardiac populations
WITH binned_admissions AS (
    SELECT *,
        CASE
            WHEN age < 40  THEN '< 40'
            WHEN age < 50  THEN '40–49'
            WHEN age < 60  THEN '50–59'
            WHEN age < 70  THEN '60–69'
            WHEN age < 80  THEN '70–79'
            ELSE                '80+'
        END AS age_group
    FROM admissions
)
SELECT 
    age_group,
    COUNT(*)                        AS patient_count,
    ROUND(AVG(ef), 1)               AS avg_ejection_fraction,
    ROUND(AVG(duration_of_stay), 1) AS avg_los_days
FROM binned_admissions
GROUP BY age_group
ORDER BY MIN(age);
 
-- 2.4 Rural vs Urban outcomes — does geography affect survival?
-- Tests whether rural patients have higher mortality rates
SELECT
    CASE rural 
	WHEN 'R' THEN 'Rural' 
	WHEN 'U' THEN 'Urban' 
	END AS 'location',
    COUNT(*) AS total,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate_pct
FROM admissions
GROUP BY rural
ORDER BY mortality_rate_pct DESC;