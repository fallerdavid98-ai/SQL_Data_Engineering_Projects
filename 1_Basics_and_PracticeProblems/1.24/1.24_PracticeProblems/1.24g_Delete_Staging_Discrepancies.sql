-- DELETE WHERE NOT EXISTS/"Hard Delete"
DELETE FROM company_jobs.main.job_skill_priorities AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM company_jobs.staging.priority_skills AS src
    WHERE tgt.skill_id=src.skill_id
);

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities WHERE skill_id=183 LIMIT 10;