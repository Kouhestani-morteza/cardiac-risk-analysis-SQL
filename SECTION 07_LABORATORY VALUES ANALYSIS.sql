-- ============================================================
-- SECTION 7: LABORATORY VALUES ANALYSIS
-- ============================================================
 
-- 7.1 Average lab values by outcome
-- Survivors vs non-survivors — clinical variables that differ significantly
-- tell us about disease severity markers
SELECT
    outcome,
    COUNT(*) AS cases,
    ROUND(AVG(hb), 2)         AS avg_haemoglobin,
    ROUND(AVG(glucose), 2)    AS avg_glucose,
    ROUND(AVG(urea), 2)       AS avg_urea,
    ROUND(AVG(creatinine), 2) AS avg_creatinine,
    ROUND(AVG(bnp), 2)        AS avg_bnp,
    ROUND(AVG(ef), 2)         AS avg_ef_pct,
    ROUND(AVG(tlc), 2)        AS avg_wbc_count
FROM admissions
GROUP BY outcome
ORDER BY avg_bnp DESC;
 
-- 7.2 Anaemia analysis — severe vs moderate anaemia impact on outcomes
WITH anaemia_grouped AS (
    SELECT
        CASE
            WHEN severe_anaemia = 1 THEN 'Severe Anaemia'
            WHEN anaemia = 1 THEN 'Mild/Moderate Anaemia'
            ELSE 'No Anaemia'
        END AS anaemia_status,
        hb,
        ef,
        duration_of_stay,
        outcome
    FROM admissions
)

SELECT
    anaemia_status,
    COUNT(*) AS patients,
    ROUND(AVG(hb), 2) AS avg_hb,
    ROUND(AVG(ef), 2) AS avg_ef,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(
        SUM(CASE WHEN outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS mortality_pct
FROM anaemia_grouped
GROUP BY anaemia_status
ORDER BY mortality_pct DESC;
 
-- 7.3 AKI (Acute Kidney Injury) and its effect on mortality and LOS
-- AKI is a known independent predictor of in-hospital death in cardiac patients
SELECT
    CASE aki WHEN 1 THEN 'AKI Present' ELSE 'No AKI' END AS aki_status,
    COUNT(*) AS patients,
    ROUND(AVG(creatinine), 2) AS avg_creatinine,
    ROUND(AVG(urea), 2) AS avg_urea,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS mortality_pct
FROM admissions
GROUP BY aki
ORDER BY mortality_pct DESC;
 
-- 7.4 Raised cardiac enzymes and outcomes
-- Elevated troponin = myocardial damage; expect higher mortality and longer LOS
SELECT
    CASE raised_cardiac_enzymes WHEN 1 THEN 'Raised Enzymes' ELSE 'Normal Enzymes' END AS enzyme_status,
    COUNT(*) AS patients,
    ROUND(AVG(ef), 2) AS avg_ef,
    ROUND(AVG(bnp), 2) AS avg_bnp,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS mortality_pct
FROM admissions
WHERE raised_cardiac_enzymes IS NOT NULL
GROUP BY raised_cardiac_enzymes
ORDER BY mortality_pct DESC;