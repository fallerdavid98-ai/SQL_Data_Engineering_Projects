--Prepare priority jobs tables in schema staging


-- Creating or replacing snapshot table
CREATE OR REPLACE TABLE job_mart.main.priority_jobs_snapshot (
    job_id INTEGER PRIMARY KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posted_date TIMESTAMP,
    salary_year_avg DOUBLE,
    priority_lvl INTEGER,
    updated_at TIMESTAMP
);

-- Populating snapshot table with data from job_postings_fact, company_dim and priority_roles
INSERT INTO job_mart.main.priority_jobs_snapshot (
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
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id=cd.company_id
INNER JOIN job_mart.staging.priority_roles AS pr
    ON jpf.job_title_short=pr.role_name;

-- SELECT * FROM job_mart.main.priority_jobs_snapshot;


-- Overview of created table
SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM job_mart.main.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;
