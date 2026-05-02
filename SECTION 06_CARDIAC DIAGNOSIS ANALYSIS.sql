-- ============================================================
-- SECTION 6: CARDIAC DIAGNOSIS ANALYSIS
-- ============================================================
 
-- 6.1 Prevalence of each cardiac diagnosis
-- Identifies the most common reasons for admission
SELECT
    'Diabetes (DM)' AS comorbidity,
    SUM(dm) AS count,
    ROUND(SUM(dm) * 100.0 / COUNT(*), 1) AS prevalence_pct
FROM admissions

UNION ALL

SELECT
    'Hypertension (HTN)',
    SUM(htn),
    ROUND(SUM(htn) * 100.0 / COUNT(*), 1)
FROM admissions

UNION ALL

SELECT
    'Coronary Artery Disease (CAD)',
    SUM(cad),
    ROUND(SUM(cad) * 100.0 / COUNT(*), 1)
FROM admissions

UNION ALL

SELECT
    'Chronic Kidney Disease (CKD)',
    SUM(ckd),
    ROUND(SUM(ckd) * 100.0 / COUNT(*), 1)
FROM admissions

UNION ALL

SELECT
    'Prior Cardiomyopathy',
    SUM(prior_cmp),
    ROUND(SUM(prior_cmp) * 100.0 / COUNT(*), 1)
FROM admissions

UNION ALL

SELECT
    'Smoking',
    SUM(smoking),
    ROUND(SUM(smoking) * 100.0 / COUNT(*), 1)
FROM admissions

UNION ALL

SELECT
    'Alcohol',
    SUM(alcohol),
    ROUND(SUM(alcohol) * 100.0 / COUNT(*), 1)
FROM admissions

ORDER BY count DESC;
-- 6.2 Mortality rate by major cardiac diagnosis
-- Cardiogenic shock, PE, STEMI expected to have highest mortality
SELECT
    'STEMI'             AS diagnosis,
    SUM(stemi)          AS total_cases,
    SUM(CASE WHEN stemi = 1 AND outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(SUM(CASE WHEN stemi = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(stemi), 0) * 100, 2) AS mortality_pct
FROM admissions
UNION ALL
SELECT 'Cardiogenic Shock',
    SUM(cardiogenic_shock),
    SUM(CASE WHEN cardiogenic_shock = 1 AND outcome = 'EXPIRY' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN cardiogenic_shock = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(cardiogenic_shock), 0) * 100, 2)
FROM admissions
UNION ALL
SELECT 'Pulmonary Embolism',
    SUM(pulmonary_embolism),
    SUM(CASE WHEN pulmonary_embolism = 1 AND outcome = 'EXPIRY' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN pulmonary_embolism = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(pulmonary_embolism), 0) * 100, 2)
FROM admissions
UNION ALL
SELECT 'CVA Bleed',
    SUM(cva_bleed),
    SUM(CASE WHEN cva_bleed = 1 AND outcome = 'EXPIRY' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN cva_bleed = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(cva_bleed), 0) * 100, 2)
FROM admissions
UNION ALL
SELECT 'Heart Failure',
    SUM(heart_failure),
    SUM(CASE WHEN heart_failure = 1 AND outcome = 'EXPIRY' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN heart_failure = 1 AND outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) /
          NULLIF(SUM(heart_failure), 0) * 100, 2)
FROM admissions
ORDER BY mortality_pct DESC;
 
-- 6.3 Average Ejection Fraction (EF) by cardiac diagnosis
-- Low EF is the hallmark of systolic heart failure (HFREF)
WITH diagnosis_grouped AS (
    SELECT
        CASE
            WHEN hfref = 1 THEN 'HF with Reduced EF (HFrEF)'
            WHEN hfnef = 1 THEN 'HF with Normal EF (HFnEF)'
            WHEN stemi = 1 THEN 'STEMI'
            WHEN acs = 1 THEN 'ACS (non-STEMI)'
            WHEN af = 1 THEN 'Atrial Fibrillation'
            ELSE 'Other/Multiple'
        END AS primary_diagnosis,
        ef,
        duration_of_stay
    FROM admissions
    WHERE ef IS NOT NULL
)
SELECT
    primary_diagnosis,
    COUNT(*) AS cases,
    ROUND(AVG(ef),1) AS avg_ef,
    ROUND(AVG(duration_of_stay),1) AS avg_los
FROM diagnosis_grouped
GROUP BY primary_diagnosis
ORDER BY avg_ef;