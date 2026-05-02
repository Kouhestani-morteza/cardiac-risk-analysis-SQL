-- ============================================================
-- SECTION 3: ADMISSION PATTERNS & LENGTH OF STAY
-- ============================================================
 
-- 3.1 Admission type breakdown (Emergency vs OPD)
SELECT
    CASE admission_type 
	WHEN 'E' THEN 'Emergency' 
	WHEN 'O' THEN 'OPD' 
	END AS 'type',
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(duration_of_stay), 1) AS avg_los_days
FROM admissions
GROUP BY admission_type
ORDER BY total DESC;
 
-- 3.2 Monthly admission volume — detect seasonal or epidemic patterns
SELECT
    month_year,
    COUNT(*) AS admissions,
    SUM(CASE WHEN outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths,
    ROUND(AVG(duration_of_stay), 1) AS avg_los
FROM admissions
GROUP BY month_year
ORDER BY MIN(doa);
 
-- 3.3 Length of Stay (LOS) distribution by outcome
-- Expired patients may have shorter (rapid deterioration) or longer stays
SELECT
    outcome,
    COUNT(*) AS cases,
    ROUND(AVG(duration_of_stay), 1) AS avg_los,
    ROUND(AVG(icu_duration), 1)     AS avg_icu_days,
    ROUND(MIN(duration_of_stay), 0) AS min_los,
    ROUND(MAX(duration_of_stay), 0) AS max_los
FROM admissions
GROUP BY outcome
ORDER BY avg_los DESC;
 
-- 3.4 LOS distribution by admission type and gender
SELECT
    CASE admission_type 
	WHEN 'E' THEN 'Emergency' 
	WHEN 'O' THEN 'OPD' 
	END AS 'type',
    
	CASE gender 
	WHEN 'M' THEN 'Male' 
	WHEN 'F' THEN 'Female' 
	END AS gender,
    
	COUNT(*) AS cases,
    ROUND(AVG(duration_of_stay), 1) AS avg_los
FROM admissions
GROUP BY admission_type, gender
ORDER BY type, avg_los DESC;