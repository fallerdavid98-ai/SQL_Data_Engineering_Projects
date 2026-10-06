-- Create Table
CREATE TABLE IF NOT EXISTS company_jobs.main.job_skill_priorities (
    job_id INTEGER,
    skill_id INTEGER,
    skill_name VARCHAR,
    priority_lvl INTEGER,
    status VARCHAR
);

-- Insert values from joined tables skills_job_dim and priority_skills
INSERT INTO company_jobs.main.job_skill_priorities (
    job_id,
    skill_id,
    -- skill_name,
    -- priority_lvl,
    status
)
SELECT
    sjd.job_id,
    sjd.skill_id,
    -- ps.skill_name,
    -- ps.priority_lvl,
    'ACTIVE' AS status
FROM company_jobs.staging.priority_skills AS ps
INNER JOIN data_jobs.main.skills_job_dim AS sjd
ON ps.skill_id=sjd.skill_id;

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities LIMIT 10;