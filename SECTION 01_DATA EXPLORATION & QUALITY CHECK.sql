-- ============================================================
-- SECTION 1: DATA EXPLORATION & QUALITY CHECK
-- ============================================================
 
-- 1.1 Preview the first 10 admissions to understand raw data structure
SELECT TOP 10 *
FROM admissions
 
-- 1.2 Dataset dimensions — know exactly what we're working with
SELECT
    (SELECT COUNT(*) FROM admissions) AS total_admissions,
    (SELECT COUNT(*) FROM mortality)  AS total_brought_dead,
    (SELECT COUNT(*) FROM pollution)  AS days_of_pollution_data;
 
-- 1.3 Check for NULL values in critical clinical fields
--     NULLs in EF, BNP, Creatinine would affect clinical analysis quality
SELECT
    COUNT(*) - COUNT(hb)         AS missing_haemoglobin,
    COUNT(*) - COUNT(ef)         AS missing_ejection_fraction,
    COUNT(*) - COUNT(bnp)        AS missing_bnp,
    COUNT(*) - COUNT(creatinine) AS missing_creatinine,
    COUNT(*) - COUNT(glucose)    AS missing_glucose,
    COUNT(*) - COUNT(outcome)    AS missing_outcome
FROM admissions;
 
-- 1.4 Verify distinct values in key categorical columns
--     Ensures data is clean before aggregation
SELECT DISTINCT outcome        FROM admissions
SELECT DISTINCT gender         FROM admissions
SELECT DISTINCT rural          FROM admissions
SELECT DISTINCT admission_type FROM admissions
 
-- 1.5 Statistical summary of key numeric clinical variables
SELECT
    ROUND(MIN(age), 1)              AS min_age,
    ROUND(MAX(age), 1)              AS max_age,
    ROUND(AVG(age), 1)              AS avg_age,
    ROUND(MIN(ef), 1)               AS min_ef,
    ROUND(MAX(ef), 1)               AS max_ef,
    ROUND(AVG(ef), 1)               AS avg_ef,
    ROUND(MIN(duration_of_stay), 1) AS min_los,
    ROUND(MAX(duration_of_stay), 1) AS max_los,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(AVG(icu_duration), 1)     AS avg_icu_days
FROM admissions;
 
-- 1.6 Date range of the admission data
SELECT
    MIN(doa) AS first_admission,
    MAX(doa) AS last_admission
FROM admissions;