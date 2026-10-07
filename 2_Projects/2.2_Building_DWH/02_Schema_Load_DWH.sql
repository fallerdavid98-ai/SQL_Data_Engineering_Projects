-- 2) Load data from CSV files into DWH tables

-- Load company dim table csv from Google object storage and insert into company_dim table

SELECT '== Inserting Data Into company_dim Table ===' AS info;

INSERT INTO company_dim (company_id,name)
SELECT company_id,name
FROM read_csv(
    'https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=TRUE
    );

-- Load skills dim table csv from Google object storage and insert into skills_dim table

SELECT '== Inserting Data Into skills_dim Table ===' AS info;

INSERT INTO skills_dim (skill_id,skills,type)
SELECT skill_id,skills,type
FROM read_csv(
    'https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=TRUE
    );

-- Load job postings fact table csv from Google object storage and insert into job_postings_fact table

SELECT '== Inserting Data Into job_postings_fact Table ===' AS info;

INSERT INTO job_postings_fact (
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_work_from_home,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
)
SELECT 
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_work_from_home,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
FROM read_csv(
    'https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=TRUE
    );

-- Load skills job dim table csv from Google object storage and insert into skills_job_dim table

SELECT '== Inserting Data Into skills_job_dim Table ===' AS info;

INSERT INTO skills_job_dim (skill_id,job_id)
SELECT skill_id,job_id
FROM read_csv(
    'https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=TRUE
    );


-- Data/Table Validation

-- Record Count of each Table
SELECT 
    'company_dim' AS table_name, 
    COUNT(*) AS record_count 
FROM company_dim
UNION ALL
SELECT 
    'skills_dim', 
    COUNT(*)
FROM skills_dim 
UNION ALL
SELECT 
    'job_postings_fact', 
    COUNT(*)
FROM job_postings_fact 
UNION ALL
SELECT 
    'skills_job_dim', 
    COUNT(*)
FROM skills_job_dim;

--First Rows of each Table
SELECT '=== Company Dimension Sample ===' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills Job Dimension Sample ===' AS info;
SELECT * FROM skills_job_dim LIMIT 5;

-- CLI statement:
-- duckdb dw_marts.duckdb -c ".read 02_Schema_Load_DWH.sql"