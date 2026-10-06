-- CREATE temp table
CREATE OR REPLACE TEMPORARY TABLE src_priority_jobs AS
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id=cd.company_id
INNER JOIN job_mart.staging.priority_roles AS pr
    ON jpf.job_title_short=pr.role_name;

-- MERGE statement
MERGE INTO job_mart.main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id=src.job_id

-- UPDATE/WHEN MATCHED statement
WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET 
        priority_lvl=src.priority_lvl,
        updated_at=src.updated_at

-- INSERT/WHEN NOT MATCHED statement
WHEN NOT MATCHED THEN
    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES (
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

-- DELETE/WHEN NOT MATCHED BY SOURCE statement
WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Overview of created table
SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM job_mart.main.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC; 