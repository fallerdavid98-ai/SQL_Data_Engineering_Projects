-- 3) Create flat mart table in seperate schema

-- Drop SCHEMA if it already exists (Cascading)
DROP SCHEMA IF EXISTS flat_mart CASCADE;

-- Create flat_mart schema
CREATE SCHEMA IF NOT EXISTS flat_mart;

-- Create CTAS and inserting unique attributes/columns from DWH tables
CREATE OR REPLACE TABLE flat_mart.job_postings AS
SELECT
    -- Unique job_postings_fact attributes
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_work_from_home,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    -- Unique company_dim attributes
    cd.company_id,
    cd.name AS company_name,
    -- skills and types organized in array of structs
    ARRAY_AGG(
        STRUCT_PACK(
            type:=sd.type,
            name:=sd.skills
        )
    ) AS skills_and_type
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id=cd.company_id
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id=sd.skill_id
GROUP BY
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_work_from_home,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id,
    cd.name;


-- Data/Table Validation

-- Record Count of CTAS
SELECT 
    'flat_mart_job_postings' AS table_name,
    COUNT(*) AS record_count
FROM flat_mart.job_postings;

--First 5 Rows of CTAS
SELECT '=== Flat Mart Job Postings Sample ===' AS info;
SELECT * FROM flat_mart.job_postings LIMIT 5;

-- CLI statement:
-- duckdb dw_marts.duckdb -c ".read 03_Flat_Mart_Creation_DWH.sql"