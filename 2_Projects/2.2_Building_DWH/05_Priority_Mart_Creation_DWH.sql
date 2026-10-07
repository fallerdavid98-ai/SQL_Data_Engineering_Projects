-- 5) Create priority roles mart mart in seperate schema

-- Drop SCHEMA if it already exists (Cascading)
DROP SCHEMA IF EXISTS priority_mart CASCADE;

-- Create flat_mart schema
CREATE SCHEMA IF NOT EXISTS priority_mart;

-- Create skill dimension table dim_skill
CREATE TABLE IF NOT EXISTS priority_mart.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

-- Insert values into priority_roles table
SELECT '=== Inserting Priority Roles into Priority Mart ===' AS info;

INSERT INTO priority_mart.priority_roles (
    role_id,
    role_name,
    priority_lvl
)
VALUES
(1,'Data Engineer',2),
(2,'Senior Data Engineer',1),
(3,'Software Engineer',3);

-- Data Validation
SELECT * FROM priority_mart.priority_roles;


-- 5b) Set up initial load for priority_jobs_snapshot (batch updated table)

-- Create or replace snapshot table (if it already exists)
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (
    job_id INTEGER PRIMARY KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posted_date TIMESTAMP,
    salary_year_avg DOUBLE,
    priority_lvl INTEGER,
    updated_at TIMESTAMP
);

-- Populate snapshot table with data from job_postings_fact, company_dim and priority_roles
SELECT '=== Inserting Initial Load Values into Priority Mart Snapshot ===' AS info;

INSERT INTO priority_mart.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id=cd.company_id
INNER JOIN priority_mart.priority_roles AS pr
    ON jpf.job_title_short=pr.role_name;


-- Data validation

-- Overview of created table
SELECT '=== Initial Load Result For Priority Mart Snapshot ===' AS info;

SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;
