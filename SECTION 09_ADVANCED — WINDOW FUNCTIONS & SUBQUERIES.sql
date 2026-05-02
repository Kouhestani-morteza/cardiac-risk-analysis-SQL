-- ============================================================
-- SECTION 9: ADVANCED — WINDOW FUNCTIONS & SUBQUERIES
-- ============================================================
 
-- 9.1 Rank months by total admissions using RANK()
-- Identifies peak admission periods for resource planning
SELECT
    month_year,
    COUNT(*) AS admissions,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_by_volume
FROM admissions
GROUP BY month_year
ORDER BY rank_by_volume;
 
-- 9.2 Running cumulative admissions over time
-- Tracks patient volume buildup through the study period
SELECT
    doa,
    COUNT(*) AS daily_admissions,
    SUM(COUNT(*)) OVER (ORDER BY doa ROWS UNBOUNDED PRECEDING) AS cumulative_admissions
FROM admissions
GROUP BY doa
ORDER BY doa;
 
-- 9.3 Moving 7-day average of daily admissions(*important*)
-- Smooths out day-to-day variation to reveal true admission trends
SELECT
    doa,
    COUNT(*) AS daily_admissions,
    ROUND(
        AVG(COUNT(*)) OVER (ORDER BY doa ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),
        1
    ) AS rolling_7day_avg
FROM admissions
GROUP BY doa
ORDER BY doa;
 
-- 9.4 Identify patients with abnormally high BNP (>2× the cohort average)
-- BNP is the key biomarker for heart failure severity; outliers are highest risk
SELECT TOP 25
    mrd_no,
    age,
    gender,
    bnp,
    ef,
    outcome,
    ROUND(bnp - avg_bnp, 2) AS deviation_from_mean
FROM (
    SELECT
        mrd_no,
        age,
        gender,
        bnp,
        ef,
        outcome,
        AVG(bnp) OVER () AS avg_bnp
    FROM admissions
    WHERE bnp IS NOT NULL
) sub
WHERE bnp > 2 * avg_bnp
ORDER BY bnp DESC 
-- 9.5 Ejection Fraction risk stratification with percentile ranking
-- Categorizes patients by heart function severity using EF cutoffs
-- EF < 40% = severely reduced; 40–50% = mildly reduced; > 50% = preserved
WITH ef_grouped AS (
    SELECT
        ef,
        duration_of_stay,
        bnp,
        outcome,
        CASE
            WHEN ef < 30 THEN 'Severely Reduced (< 30%)'
            WHEN ef < 40 THEN 'Reduced (30–39%)'
            WHEN ef < 50 THEN 'Mildly Reduced (40–49%)'
            ELSE              'Preserved (≥ 50%)'
        END AS ef_category
    FROM admissions
    WHERE ef IS NOT NULL
)

SELECT
    ef_category,
    COUNT(*) AS patients,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(AVG(bnp), 1) AS avg_bnp,
    ROUND(SUM(CASE WHEN outcome = 'EXPIRY' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_pct
FROM ef_grouped
GROUP BY ef_category
ORDER BY 
    CASE ef_category
        WHEN 'Severely Reduced (< 30%)' THEN 1
        WHEN 'Reduced (30–39%)' THEN 2
        WHEN 'Mildly Reduced (40–49%)' THEN 3
        ELSE 4
    END;
 
-- 9.6 DAMA (Discharged Against Medical Advice) analysis
-- DAMA patients leave before treatment completion — high risk for readmission
-- Understanding who leaves DAMA helps target retention interventions
SELECT
    CASE gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS gender,
    CASE rural WHEN 'R' THEN 'Rural' WHEN 'U' THEN 'Urban' END AS location,
    CASE admission_type WHEN 'E' THEN 'Emergency' WHEN 'O' THEN 'OPD' END AS type,
    COUNT(*) AS dama_count,
    ROUND(AVG(duration_of_stay), 1) AS avg_los_before_leaving,
    ROUND(AVG(age), 1) AS avg_age
FROM admissions
WHERE outcome = 'DAMA'
GROUP BY gender, rural, admission_type
ORDER BY dama_count DESC;