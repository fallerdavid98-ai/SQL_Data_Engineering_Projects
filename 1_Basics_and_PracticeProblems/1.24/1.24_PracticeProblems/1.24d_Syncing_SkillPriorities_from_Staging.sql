-- MERGE statement
MERGE INTO company_jobs.main.job_skill_priorities AS tgt
USING company_jobs.staging.priority_skills AS src
ON tgt.skill_id=src.skill_id

-- WHEN MATCHED
WHEN MATCHED THEN
UPDATE SET
    skill_name = src.skill_name,
    priority_lvl = src.priority_lvl;

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities LIMIT 10;