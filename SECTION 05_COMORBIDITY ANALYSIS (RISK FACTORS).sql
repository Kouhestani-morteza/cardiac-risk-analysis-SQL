-- ============================================================
-- SECTION 5: COMORBIDITY ANALYSIS (RISK FACTORS)
-- ============================================================

-- 5.1 Prevalence of each comorbidity in the dataset(Risk Factor Prevalence Analysis)
-- Shows the burden of chronic disease in this cardiac population
SELECT
    'Diabetes (DM)' AS comorbidity,
    SUM(dm) AS count,
    ROUND(AVG(CAST(dm AS FLOAT)) * 100, 1) AS prevalence_pct
FROM admissions

UNION ALL

SELECT
    'Hypertension (HTN)',
    SUM(htn),
    ROUND(AVG(CAST(htn AS FLOAT)) * 100, 1)
FROM admissions

UNION ALL

SELECT
    'Coronary Artery Disease (CAD)',
    SUM(cad),
    ROUND(AVG(CAST(cad AS FLOAT)) * 100, 1)
FROM admissions

UNION ALL

SELECT
    'Chronic Kidney Disease (CKD)',
    SUM(ckd),
    ROUND(AVG(CAST(ckd AS FLOAT)) * 100, 1)
FROM admissions

UNION ALL

SELECT
    'Prior Cardiomyopathy',
    SUM(prior_cmp),
    ROUND(AVG(CAST(prior_cmp AS FLOAT)) * 100, 1)
FROM admissions

UNION ALL

SELECT
    'Smoking',
    SUM(smoking),
    ROUND(AVG(CAST(smoking AS FLOAT)) * 100, 1)
FROM admissions

UNION ALL

SELECT
    'Alcohol',
    SUM(alcohol),
    ROUND(AVG(CAST(alcohol AS FLOAT)) * 100, 1)
FROM admissions

ORDER BY count DESC;
 
-- 5.2 Comorbidity burden: how many conditions does each patient have?
-- Higher comorbidity burden correlates with worse outcomes
WITH scored_admissions AS (
    SELECT *,
        (ISNULL(dm, 0) + ISNULL(htn, 0) + ISNULL(cad, 0) + ISNULL(ckd, 0) + 
         ISNULL(prior_cmp, 0) + ISNULL(smoking, 0) + ISNULL(alcohol, 0)) AS comorbidity_score
    FROM admissions
)
SELECT
    comorbidity_score,
    COUNT(*) AS patients,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM scored_admissions
GROUP BY comorbidity_score
ORDER BY comorbidity_score;
 
-- 5.3 Impact of each comorbidity on mortality
-- For each comorbidity, compare mortality rate in patients who have vs don't have it
SELECT
    'DM' AS comorbidity,
    ROUND(SUM(CASE WHEN dm = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN dm = 1 THEN 1 ELSE 0 END), 0) * 100, 2) AS mortality_with,
    ROUND(SUM(CASE WHEN dm = 0 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN dm = 0 THEN 1 ELSE 0 END), 0) * 100, 2) AS mortality_without
FROM admissions
UNION ALL
SELECT 'HTN',
    ROUND(SUM(CASE WHEN htn = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN htn = 1 THEN 1 ELSE 0 END), 0) * 100, 2),
    ROUND(SUM(CASE WHEN htn = 0 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN htn = 0 THEN 1 ELSE 0 END), 0) * 100, 2)
FROM admissions
UNION ALL
SELECT 'CKD',
    ROUND(SUM(CASE WHEN ckd = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN ckd = 1 THEN 1 ELSE 0 END), 0) * 100, 2),
    ROUND(SUM(CASE WHEN ckd = 0 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN ckd = 0 THEN 1 ELSE 0 END), 0) * 100, 2)
FROM admissions
UNION ALL
SELECT 'Smoking',
    ROUND(SUM(CASE WHEN smoking = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN smoking = 1 THEN 1 ELSE 0 END), 0) * 100, 2),
    ROUND(SUM(CASE WHEN smoking = 0 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN smoking = 0 THEN 1 ELSE 0 END), 0) * 100, 2)
FROM admissions;