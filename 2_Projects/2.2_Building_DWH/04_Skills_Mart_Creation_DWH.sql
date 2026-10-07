-- 4) Create dimensional skills demand (by month) mart in seperate schema

-- Drop SCHEMA if it already exists (Cascading)
DROP SCHEMA IF EXISTS skills_mart CASCADE;

-- Create flat_mart schema
CREATE SCHEMA IF NOT EXISTS skills_mart;

-- Create skill dimension table dim_skill
CREATE TABLE IF NOT EXISTS skills_mart.dim_skills (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

-- Insert skills_dim values into dim_skills dimensional table
INSERT INTO skills_mart.dim_skills (
    skill_id,
    skills,
    type
)
SELECT
    skill_id,
    skills,
    type
FROM skills_dim;

-- Create time dimension table dim_date_month
CREATE TABLE IF NOT EXISTS skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

-- Insert transformed job_posted_month values into dim_date_month dimensional table
INSERT INTO skills_mart.dim_date_month (
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    CAST(DATE_TRUNC('month',job_posted_date)AS DATE) AS month_start_date,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(QUARTER FROM job_posted_date) AS quarter,
    'Q-' || CAST(EXTRACT(QUARTER FROM job_posted_date) AS VARCHAR) AS quarter_name,
    CAST(EXTRACT(YEAR FROM job_posted_date) AS VARCHAR) || '-Q' || CAST(EXTRACT(QUARTER FROM job_posted_date) AS VARCHAR) AS year_quarter
FROM job_postings_fact
ORDER BY month_start_date;

-- Create fact table for monthly skill demand
CREATE TABLE IF NOT EXISTS skills_mart.fact_skill_demand_monthly (
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_mention_count INTEGER,

    PRIMARY KEY (skill_id,month_start_date,job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

-- Insert (aggregated) values into fact table for monthly skill demand
INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_mention_count
)
WITH job_postings_base AS (
    SELECT
        sjd.skill_id,
        CAST(DATE_TRUNC('month',job_posted_date)AS DATE) AS month_start_date,
        jpf.job_title_short,
        CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
        CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
        CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mentioned
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id=sjd.job_id
)
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,
    SUM(is_remote) AS remote_postings_count,
    SUM(has_health_insurance) AS health_insurance_postings_count,
    SUM(no_degree_mentioned) AS no_degree_mention_count
FROM job_postings_base
GROUP BY 
    skill_id,
    month_start_date,
    job_title_short
ORDER BY
    skill_id,
    month_start_date,
    job_title_short;

-- Data/Table Validation

-- Record Count of each Table
SELECT 
    'dim_skills' AS table_name, 
    COUNT(*) AS record_count 
FROM skills_mart.dim_skills
UNION ALL
SELECT 
    'dim_date_month', 
    COUNT(*)
FROM skills_mart.dim_date_month 
UNION ALL
SELECT 
    'fact_skill_demand_monthly', 
    COUNT(*)
FROM skills_mart.fact_skill_demand_monthly;

--First 5 Rows of each Table
SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_skills LIMIT 5;

SELECT '=== Month/Date Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month  LIMIT 5;

SELECT '=== Monthly Skill Demand Fact Sample ===' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 5;

-- CLI statement:
-- duckdb dw_marts.duckdb -c ".read 04_Skills_Mart_Creation_DWH.sql"
