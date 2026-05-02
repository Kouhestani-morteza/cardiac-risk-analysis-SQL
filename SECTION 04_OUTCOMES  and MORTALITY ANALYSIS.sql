-- ============================================================
-- SECTION 4: OUTCOMES & MORTALITY ANALYSIS
-- ============================================================
 
-- 4.1 Overall outcome distribution
-- DAMA = Discharged Against Medical Advice — clinically important category
SELECT
    outcome,
    COUNT(*) AS 'count',
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM admissions
GROUP BY outcome
ORDER BY count DESC;
 
-- 4.2 In-hospital mortality rate by gender
SELECT
    CASE gender 
	WHEN 'M' THEN 'Male' 
	WHEN 'F' THEN 'Female' 
	END AS gender,
    COUNT(*) AS total,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM admissions
GROUP BY gender;
 
-- 4.3 Mortality rate by age group
-- Expected to increase with age — confirms data quality and clinical logic
WITH age_data AS (
    SELECT *,
        CASE
            WHEN age < 50 THEN '< 50'
            WHEN age < 60 THEN '50–59'
            WHEN age < 70 THEN '60–69'
            WHEN age < 80 THEN '70–79'
            ELSE               '80+'
        END AS age_group
    FROM admissions
)
SELECT
    age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM age_data
GROUP BY age_group
ORDER BY MIN(age);
 
-- 4.4 Mortality rate by admission type
-- Emergency admissions should have higher mortality than OPD
SELECT
    CASE admission_type 
	WHEN 'E' THEN 'Emergency' 
	WHEN 'O' THEN 'OPD' 
	END AS 'type',
    COUNT(*) AS total,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM admissions
GROUP BY admission_type;
 
-- 4.5 Monthly mortality trend — identify high-risk periods
SELECT
    month_year,
    COUNT(*) AS total_admissions,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM admissions
GROUP BY month_year
ORDER BY MIN(doa);