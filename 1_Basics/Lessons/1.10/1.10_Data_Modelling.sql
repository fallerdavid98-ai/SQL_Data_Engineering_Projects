SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM job_postings_fact
LIMIT 10;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'data_jobs';

SELECT *
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';

SELECT *
FROM information_schema.table_constraints
WHERE table_catalog = 'data_jobs';

SELECT *
FROM information_schema.key_column_usage
WHERE table_catalog = 'data_jobs';

PRAGMA show_tables;

PRAGMA show_tables_expanded;

SELECT *
FROM information_schema.tables
WHERE table_name LIKE '%dim%';

SELECT 
    table_name,
    constraint_name,
    count(constraint_name) AS constraint_name_count
FROM information_schema.key_column_usage
WHERE table_catalog='data_jobs'
GROUP BY table_name,constraint_name
HAVING count(constraint_name)>1;

SELECT *
FROM information_schema.tables
WHERE table_name='job_postings_fact';