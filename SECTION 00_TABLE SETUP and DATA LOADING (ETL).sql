-- ============================================================
-- SECTION 0: TABLE SETUP & DATA LOADING (ETL)
-- ============================================================

-- 0.1) Create the main admissions table
-- Each row = one cardiac patient hospitalization
CREATE TABLE admissions (
    sno INT,
    mrd_no VARCHAR(20),
    doa DATE,
    dod DATE,
    age INT,
    gender CHAR(1),
    rural CHAR(1),
    admission_type CHAR(1),
    month_year VARCHAR(10),
    duration_of_stay INT,
    icu_duration INT,
    outcome VARCHAR(20),
    smoking INT,
    alcohol INT,
    dm INT,
    htn INT,
    cad INT,
    prior_cmp INT,
    ckd INT,
    hb FLOAT,
    tlc FLOAT,
    platelets INT,
    glucose FLOAT,
    urea FLOAT,
    creatinine FLOAT,
    bnp FLOAT,
    raised_cardiac_enzymes INT,
    ef FLOAT,
    severe_anaemia INT,
    anaemia INT,
    stable_angina INT,
    acs INT,
    stemi INT,
    atypical_chest_pain INT,
    heart_failure INT,
    hfref INT,
    hfnef INT,
    valvular INT,
    chb INT,
    sss INT,
    aki INT,
    cva_infarct INT,
    cva_bleed INT,
    af INT,
    vt INT,
    psvt INT,
    congenital INT,
    uti INT,
    neuro_syncope INT,
    orthostatic INT,
    infective_endocarditis INT,
    dvt INT,
    cardiogenic_shock INT,
    shock INT,
    pulmonary_embolism INT,
    chest_infection INT
);
-- 0.1) STAGING (Raw Data Layer), Load raw CSV data into staging tables without transformation
CREATE TABLE admissions_staging (
    sno                     VARCHAR(50),
    mrd_no                  VARCHAR(50),       -- Medical Record Number (patient ID)
    doa                     VARCHAR(50),       -- Date of Admission
    dod                     VARCHAR(50),       -- Date of Discharge
    age                     VARCHAR(50),
    gender                  VARCHAR(50),       -- M / F
    rural                   VARCHAR(50),       -- R = Rural, U = Urban
    admission_type          VARCHAR(50),       -- E = Emergency, O = OPD
    month_year              VARCHAR(50),
    duration_of_stay        VARCHAR(50),       -- Total hospital stay in days
    icu_duration            VARCHAR(50),       -- Days spent in ICU
    outcome                 VARCHAR(50),       -- DISCHARGE / EXPIRY / DAMA
    smoking                 VARCHAR(50),       -- 1 = Yes, 0 = No
    alcohol                 VARCHAR(50),
    dm                      VARCHAR(50),       -- Diabetes Mellitus
    htn                     VARCHAR(50),       -- Hypertension
    cad                     VARCHAR(50),       -- Coronary Artery Disease
    prior_cmp               VARCHAR(50),       -- Prior Cardiomyopathy
    ckd                     VARCHAR(50),       -- Chronic Kidney Disease
    hb                      VARCHAR(50),       -- Haemoglobin (g/dL)
    tlc                     VARCHAR(50),       -- Total Leukocyte Count
    platelets               VARCHAR(50),
    glucose                 VARCHAR(50),
    urea                    VARCHAR(50),
    creatinine              VARCHAR(50),
    bnp                     VARCHAR(50),       -- B-type Natriuretic Peptide
    raised_cardiac_enzymes  VARCHAR(50),
    ef                      VARCHAR(50),       -- Ejection Fraction (%)
    severe_anaemia          VARCHAR(50),
    anaemia                 VARCHAR(50),
    stable_angina           VARCHAR(50),
    acs                     VARCHAR(50),       -- Acute Coronary Syndrome
    stemi                   VARCHAR(50),       -- ST-Elevation Myocardial Infarction
    atypical_chest_pain     VARCHAR(50),
    heart_failure           VARCHAR(50),
    hfref                   VARCHAR(50),       -- HF with Reduced Ejection Fraction
    hfnef                   VARCHAR(50),       -- HF with Normal Ejection Fraction
    valvular                VARCHAR(50),       -- Valvular Heart Disease
    chb                     VARCHAR(50),       -- Complete Heart Block
    sss                     VARCHAR(50),       -- Sick Sinus Syndrome
    aki                     VARCHAR(50),       -- Acute Kidney Injury
    cva_infarct             VARCHAR(50),       -- CVA Infarct (stroke)
    cva_bleed               VARCHAR(50),       -- CVA Bleed
    af                      VARCHAR(50),       -- Atrial Fibrillation
    vt                      VARCHAR(50),       -- Ventricular Tachycardia
    psvt                    VARCHAR(50),       -- Paroxysmal SVT
    congenital              VARCHAR(50),
    uti                     VARCHAR(50),       -- Urinary Tract Infection
    neuro_syncope           VARCHAR(50),
    orthostatic             VARCHAR(50),
    infective_endocarditis  VARCHAR(50),
    dvt                     VARCHAR(50),       -- Deep Vein Thrombosis
    cardiogenic_shock       VARCHAR(50),
    shock                   VARCHAR(50),
    pulmonary_embolism      VARCHAR(50),
    chest_infection         VARCHAR(50)
);
-- 0.1) DATA INGESTION (Bulk Load), Import CSV data into staging using BULK INSERT
 BULK INSERT admissions_staging
FROM 'C:\Temp\HDHI Admission data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
-- 0.1) DATA CLEANING & TRANSFORMATION, Convert data types, handle nulls, and prepare clean dataset
INSERT INTO admissions
SELECT
    TRY_CAST(sno AS INT),
    mrd_no,
    TRY_CAST(doa AS DATE),
    TRY_CAST(dod AS DATE),
    TRY_CAST(age AS INT),
    gender,
    rural,
    admission_type,
    month_year,
    TRY_CAST(duration_of_stay AS INT),
    TRY_CAST(icu_duration AS INT),
    outcome,
    TRY_CAST(smoking AS INT),
    TRY_CAST(alcohol AS INT),
    TRY_CAST(dm AS INT),
    TRY_CAST(htn AS INT),
    TRY_CAST(cad AS INT),
    TRY_CAST(prior_cmp AS INT),
    TRY_CAST(ckd AS INT),
    TRY_CAST(hb AS FLOAT),
    TRY_CAST(tlc AS FLOAT),
    TRY_CAST(platelets AS INT),
    TRY_CAST(glucose AS FLOAT),
    TRY_CAST(urea AS FLOAT),
    TRY_CAST(creatinine AS FLOAT),
    TRY_CAST(bnp AS FLOAT),
    TRY_CAST(raised_cardiac_enzymes AS INT),
    TRY_CAST(ef AS FLOAT),
    TRY_CAST(severe_anaemia AS INT),
    TRY_CAST(anaemia AS INT),
    TRY_CAST(stable_angina AS INT),
    TRY_CAST(acs AS INT),
    TRY_CAST(stemi AS INT),
    TRY_CAST(atypical_chest_pain AS INT),
    TRY_CAST(heart_failure AS INT),
    TRY_CAST(hfref AS INT),
    TRY_CAST(hfnef AS INT),
    TRY_CAST(valvular AS INT),
    TRY_CAST(chb AS INT),
    TRY_CAST(sss AS INT),
    TRY_CAST(aki AS INT),
    TRY_CAST(cva_infarct AS INT),
    TRY_CAST(cva_bleed AS INT),
    TRY_CAST(af AS INT),
    TRY_CAST(vt AS INT),
    TRY_CAST(psvt AS INT),
    TRY_CAST(congenital AS INT),
    TRY_CAST(uti AS INT),
    TRY_CAST(neuro_syncope AS INT),
    TRY_CAST(orthostatic AS INT),
    TRY_CAST(infective_endocarditis AS INT),
    TRY_CAST(dvt AS INT),
    TRY_CAST(cardiogenic_shock AS INT),
    TRY_CAST(shock AS INT),
    TRY_CAST(pulmonary_embolism AS INT),
    TRY_CAST(chest_infection AS INT)
FROM admissions_staging;

-- 0.2) Create the main mortality table
-- Records patients who were "Brought Dead" to the hospital
CREATE TABLE mortality (
    sno          INT,
    mrd_no       VARCHAR(20),
    age          INT,
    gender       CHAR(1),
    rural_urban  CHAR(1),
    date_brought DATE
);
-- 0.2) STAGING (mortality)
CREATE TABLE mortality_staging (
    sno          VARCHAR(50),
    mrd_no       VARCHAR(50),
    age          VARCHAR(50),
    gender       VARCHAR(50),
    rural_urban  VARCHAR(50),
    date_brought VARCHAR(50)
); 
-- 0.2) DATA INGESTION (mortality)
 BULK INSERT mortality_staging
FROM 'C:\Temp\HDHI Mortality data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
-- 0.2) DATA CLEANING & TRANSFORMATION (mortality)
INSERT INTO mortality
SELECT
    TRY_CAST(sno AS INT),

    -- Clean MRD (remove spaces)
    LTRIM(RTRIM(mrd_no)) AS mrd_no,

    -- Age validation (ignore unrealistic values)
    CASE 
        WHEN TRY_CAST(age AS INT) BETWEEN 0 AND 120 
        THEN TRY_CAST(age AS INT)
        ELSE NULL
    END AS age,

    -- Standardize gender
    CASE 
        WHEN LOWER(gender) IN ('m', 'male') THEN 'M'
        WHEN LOWER(gender) IN ('f', 'female') THEN 'F'
        ELSE NULL
    END AS gender,

    -- Standardize rural/urban
    CASE 
        WHEN UPPER(rural_urban) IN ('R', 'RURAL') THEN 'R'
        WHEN UPPER(rural_urban) IN ('U', 'URBAN') THEN 'U'
        ELSE NULL
    END AS rural_urban,

    -- Clean and convert date
    TRY_CAST(date_brought AS DATE) AS date_brought

FROM mortality_staging;

-- 0.3) Create the main air pollution table
-- Daily AQI and pollutant data matched to hospital admission dates
CREATE TABLE pollution (
    p_date              DATE,
    aqi                 INT,               -- Air Quality Index
    pm25_avg            NUMERIC(6,2),
    pm25_min            NUMERIC(6,2),
    pm25_max            NUMERIC(6,2),
    pm10_avg            NUMERIC(6,2),
    pm10_min            NUMERIC(6,2),
    pm10_max            NUMERIC(6,2),
    no2_avg             NUMERIC(6,2),
    no2_min             NUMERIC(6,2),
    no2_max             NUMERIC(6,2),
    nh3_avg             NUMERIC(6,2),
    nh3_min             NUMERIC(6,2),
    nh3_max             NUMERIC(6,2),
    so2_avg             NUMERIC(6,2),
    so2_min             NUMERIC(6,2),
    so2_max             NUMERIC(6,2),
    co_avg              NUMERIC(6,2),
    co_min              NUMERIC(6,2),
    co_max              NUMERIC(6,2),
    ozone_avg           NUMERIC(6,2),
    ozone_min           NUMERIC(6,2),
    ozone_max           NUMERIC(6,2),
    prominent_pollutant VARCHAR(20),
    max_temp            NUMERIC(5,1),
    min_temp            NUMERIC(5,1),
    humidity            NUMERIC(5,1)
);
-- 0.3) staging (air pollution)
CREATE TABLE pollution_staging (
    p_date              VARCHAR(50),
    aqi                 VARCHAR(50),               -- Air Quality Index
    pm25_avg            VARCHAR(50),
    pm25_min            VARCHAR(50),
    pm25_max            VARCHAR(50),
    pm10_avg            VARCHAR(50),
    pm10_min            VARCHAR(50),
    pm10_max            VARCHAR(50),
    no2_avg             VARCHAR(50),
    no2_min             VARCHAR(50),
    no2_max             VARCHAR(50),
    nh3_avg             VARCHAR(50),
    nh3_min             VARCHAR(50),
    nh3_max             VARCHAR(50),
    so2_avg             VARCHAR(50),
    so2_min             VARCHAR(50),
    so2_max             VARCHAR(50),
    co_avg              VARCHAR(50),
    co_min              VARCHAR(50),
    co_max              VARCHAR(50),
    ozone_avg           VARCHAR(50),
    ozone_min           VARCHAR(50),
    ozone_max           VARCHAR(50),
    prominent_pollutant VARCHAR(50),
    max_temp            VARCHAR(50),
    min_temp            VARCHAR(50),
    humidity            VARCHAR(50)
);
-- 0.3) DATA INGESTION (air pollution)
BULK INSERT pollution_staging
FROM 'C:\Temp\HDHI Pollution Data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
-- 0.3) DATA CLEANING & TRANSFORMATION (air pollution)
INSERT INTO pollution
SELECT

    -- Date conversion
    TRY_CAST(p_date AS DATE) AS p_date,

    -- AQI validation (0–500 range typical)
    CASE 
        WHEN TRY_CAST(aqi AS INT) BETWEEN 0 AND 500 
        THEN TRY_CAST(aqi AS INT)
        ELSE NULL
    END AS aqi,

    -- PM2.5
    TRY_CAST(pm25_avg AS FLOAT),
    TRY_CAST(pm25_min AS FLOAT),
    TRY_CAST(pm25_max AS FLOAT),

    -- PM10
    TRY_CAST(pm10_avg AS FLOAT),
    TRY_CAST(pm10_min AS FLOAT),
    TRY_CAST(pm10_max AS FLOAT),

    -- NO2
    TRY_CAST(no2_avg AS FLOAT),
    TRY_CAST(no2_min AS FLOAT),
    TRY_CAST(no2_max AS FLOAT),

    -- NH3
    TRY_CAST(nh3_avg AS FLOAT),
    TRY_CAST(nh3_min AS FLOAT),
    TRY_CAST(nh3_max AS FLOAT),

    -- SO2
    TRY_CAST(so2_avg AS FLOAT),
    TRY_CAST(so2_min AS FLOAT),
    TRY_CAST(so2_max AS FLOAT),

    -- CO
    TRY_CAST(co_avg AS FLOAT),
    TRY_CAST(co_min AS FLOAT),
    TRY_CAST(co_max AS FLOAT),

    -- Ozone
    TRY_CAST(ozone_avg AS FLOAT),
    TRY_CAST(ozone_min AS FLOAT),
    TRY_CAST(ozone_max AS FLOAT),

    -- Categorical column cleanup
    LTRIM(RTRIM(prominent_pollutant)) AS prominent_pollutant,

    -- Temperature validation
    CASE 
        WHEN TRY_CAST(max_temp AS FLOAT) BETWEEN -50 AND 60
        THEN TRY_CAST(max_temp AS FLOAT)
        ELSE NULL
    END AS max_temp,

    CASE 
        WHEN TRY_CAST(min_temp AS FLOAT) BETWEEN -50 AND 60
        THEN TRY_CAST(min_temp AS FLOAT)
        ELSE NULL
    END AS min_temp,

    -- humidity validation (0–100%)
    CASE 
        WHEN TRY_CAST(humidity AS FLOAT) BETWEEN 0 AND 100
        THEN TRY_CAST(humidity AS FLOAT)
        ELSE NULL
    END AS humidity

FROM pollution_staging;