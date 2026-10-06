-- Delete record from priority_skills staging table
DELETE FROM company_jobs.staging.priority_skills
WHERE skill_id=183;

-- Display updated priority_skills table
SELECT * FROM company_jobs.staging.priority_skills LIMIT 10;

-- MERGE statement
MERGE INTO company_jobs.main.job_skill_priorities AS tgt
USING company_jobs.staging.priority_skills AS src
ON tgt.skill_id=src.skill_id

-- WHEN NOT MATCHED/"Soft Delete"
WHEN NOT MATCHED BY SOURCE THEN
UPDATE SET
    status='INACTIVE';

-- Display the final table
SELECT * 
FROM company_jobs.main.job_skill_priorities 
WHERE status='INACTIVE'
LIMIT 10;