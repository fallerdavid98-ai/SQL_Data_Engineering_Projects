-- Update priority levels in priority_skills staging table
UPDATE staging.priority_skills SET priority_lvl = 1 WHERE skill_id = 0;
UPDATE staging.priority_skills SET priority_lvl = 2 WHERE skill_id = 1;

-- Display updated priority_skills table
SELECT * FROM company_jobs.staging.priority_skills LIMIT 10;

-- MERGE statement
MERGE INTO company_jobs.main.job_skill_priorities AS tgt
USING company_jobs.staging.priority_skills AS src
ON tgt.skill_id=src.skill_id

-- WHEN MATCHED
WHEN MATCHED AND (tgt.priority_lvl != src.priority_lvl OR tgt.priority_lvl IS NULL) THEN
UPDATE SET
priority_lvl=src.priority_lvl,
status='PRIORITY_CHANCE';

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities LIMIT 10;