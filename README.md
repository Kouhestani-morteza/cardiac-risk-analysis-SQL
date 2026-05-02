Cardiac Health & Mortality Analysis (SQL Project)
Overview
This project analyzes cardiac hospital data to identify key drivers of mortality, hospital admissions, and clinical risk factors.
It integrates three datasets:
•	Hospital admissions (clinical + outcomes) 
•	Brought-dead mortality records 
•	Environmental pollution data (AQI, temperature) 
________________________________________
Objectives
•	Identify mortality risk factors in cardiac patients 
•	Analyze admission patterns and hospital utilization 
•	Evaluate impact of comorbidities and lab markers 
•	Explore relationship between air pollution and cardiac events 
________________________________________
Tools & Technologies
•	SQL Server (T-SQL) 
•	Window Functions (RANK, AVG OVER, SUM OVER) 
•	Common Table Expressions (CTEs) 
•	Subqueries & Aggregations 
•	Data Cleaning with TRY_CAST, CASE, NULL handling 
________________________________________
Key Techniques Used
•	ETL pipeline (Staging → Clean → Production tables) 
•	Advanced analytics using window functions 
•	Clinical risk stratification (EF, BNP, comorbidities) 
•	Time-series analysis (rolling averages, cumulative trends) 
•	Data integration (clinical + environmental data) 
________________________________________
Key Insights (High-Level)
•	Mortality strongly linked to age, EF, and kidney function 
•	Emergency admissions carry significantly higher risk 
•	AKI and CKD are major mortality drivers 
•	Air pollution and heat correlate with increased admissions 
•	A portion of deaths occur before hospital arrival (DOA) 
________________________________________
Project Structure
•	SQL scripts (ETL + Analysis) 
•	Dataset integration (Admissions, Mortality, Pollution) 
•	Analytical queries across 10 sections 
________________________________________
Notes
Detailed results and interpretations are available in the Results & Discussion document.

author:
Morteza Kouhestani
pharmacist || data scientist in healthcare
