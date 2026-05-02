-- ============================================================
-- SECTION 10: MORTALITY TABLE ANALYSIS
-- ============================================================
 
-- 10.1 Overview of patients brought dead (deceased on arrival)
SELECT COUNT(*) AS total_brought_dead 
FROM mortality;
 
-- 10.2 Age and gender distribution of brought-dead patients
SELECT
    CASE gender WHEN 'M' THEN 'Male' 
	WHEN 'F' THEN 'Female' 
	END AS gender,
    COUNT(*) AS count,
    ROUND(AVG(age), 1) AS avg_age,
    MIN(age) AS youngest,
    MAX(age) AS oldest
FROM mortality
GROUP BY gender;
 
-- 10.3 Monthly trend of brought-dead cases
-- Cross-reference with pollution to see if pollution spikes coincide
SELECT
    CAST(YEAR(date_brought) AS VARCHAR(4)) + '-' +
    RIGHT('0' + CAST(MONTH(date_brought) AS VARCHAR(2)), 2) AS month,
    COUNT(*) AS brought_dead_count
FROM mortality
GROUP BY
    YEAR(date_brought),
    MONTH(date_brought)
ORDER BY
    YEAR(date_brought),
    MONTH(date_brought);
 
-- 10.4 Combine admissions mortality with brought-dead for total hospital death burden
-- This gives the complete picture of cardiac mortality at this hospital
SELECT
    'In-Hospital Deaths (admitted)' AS category,
    COUNT(*) AS deaths
FROM admissions WHERE outcome = 'EXPIRY'
UNION ALL
SELECT
    'Brought Dead (DOA)',
    COUNT(*)
FROM mortality
UNION ALL
SELECT
    'Total Cardiac Deaths',
    (SELECT COUNT(*) FROM admissions WHERE outcome = 'EXPIRY') +
    (SELECT COUNT(*) FROM mortality);