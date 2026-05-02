-- ============================================================
-- SECTION 8: POLLUTION–ADMISSION CORRELATION
-- ============================================================
-- This section uses the unique air quality table — a feature most cardiac datasets don't have.
-- Higher AQI on a given day → more cardiac admissions expected the same day or next day.
 
-- 8.1 Join admissions with daily pollution data by admission date
-- Creates a combined view of clinical and environmental data
SELECT
    a.doa,
    COUNT(a.sno) AS admissions,
    p.aqi,
    p.pm25_avg,
    p.pm10_avg,
    p.prominent_pollutant,
    p.max_temp,
    p.humidity
FROM admissions a
JOIN pollution p ON a.doa = p.p_date
GROUP BY a.doa, p.aqi, p.pm25_avg, p.pm10_avg, p.prominent_pollutant, p.max_temp, p.humidity
ORDER BY a.doa;
 
-- 8.2 High-pollution days (AQI > 200) and cardiac admission count
-- Tests whether "very unhealthy" air quality days drive hospital surges
WITH pollution_grouped AS (
    SELECT
        CASE
            WHEN aqi <= 50 THEN 'Good (0–50)'
            WHEN aqi <= 100 THEN 'Moderate (51–100)'
            WHEN aqi <= 150 THEN 'Unhealthy for Sensitive Groups (101–150)'
            WHEN aqi <= 200 THEN 'Unhealthy (151–200)'
            WHEN aqi <= 300 THEN 'Very Unhealthy (201–300)'
            ELSE 'Hazardous (300+)'
        END AS aqi_category,
        p_date,
        aqi
    FROM pollution
)

SELECT
    pg.aqi_category,
    COUNT(DISTINCT pg.p_date) AS days,
    COUNT(a.sno) AS total_admissions,
    ROUND(
        COUNT(a.sno) * 1.0 / COUNT(DISTINCT pg.p_date),
        1
    ) AS avg_admissions_per_day
FROM pollution_grouped pg
LEFT JOIN admissions a
    ON a.doa = pg.p_date
GROUP BY pg.aqi_category
ORDER BY MIN(pg.aqi);
 
-- 8.3 Top 10 worst pollution days and their cardiac admission burden
SELECT top 10
	p.p_date,
    p.aqi,
    p.pm25_avg,
    p.prominent_pollutant,
    COUNT(a.sno) AS admissions,
    SUM(CASE WHEN a.outcome = 'EXPIRY' THEN 1 ELSE 0 END) AS deaths
FROM pollution p
LEFT JOIN admissions a ON a.doa = p.p_date
GROUP BY p.p_date, p.aqi, p.pm25_avg, p.prominent_pollutant
ORDER BY p.aqi DESC 
-- 8.4 Correlation between temperature and admissions
-- Extreme cold/heat stress is a known cardiac trigger
WITH temperature_grouped AS (
    SELECT
        CASE
            WHEN p.max_temp < 20 THEN 'Cold (< 20°C)'
            WHEN p.max_temp < 30 THEN 'Mild (20–29°C)'
            WHEN p.max_temp < 38 THEN 'Warm (30–37°C)'
            ELSE                      'Hot (38°C+)'
        END AS temp_category,
        p.p_date,
        a.sno,
        p.max_temp
    FROM pollution p
    LEFT JOIN admissions a
        ON a.doa = p.p_date
)

SELECT
    temp_category,
    COUNT(DISTINCT p_date) AS days,
    COUNT(sno) AS total_admissions,
    ROUND(COUNT(sno) * 1.0 / COUNT(DISTINCT p_date), 1) AS avg_admissions_per_day
FROM temperature_grouped
GROUP BY temp_category
ORDER BY MIN(max_temp);