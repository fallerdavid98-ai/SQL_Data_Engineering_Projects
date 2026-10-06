-- Update priority levels in priority_skills staging table
INSERT INTO staging.priority_skills (
    skill_id,
    skill_name,
    priority_lvl
)
VALUES
(77,'aws',3);

-- Display updated priority_skills table
SELECT * FROM company_jobs.staging.priority_skills LIMIT 10;

-- MERGE statement with subquery as source table
MERGE INTO company_jobs.main.job_skill_priorities AS tgt
USING (
    SELECT 
        sjd.job_id,
        ps.skill_id,
        ps.skill_name,
        ps.priority_lvl
    FROM data_jobs.main.skills_job_dim AS sjd
    JOIN company_jobs.staging.priority_skills as ps
    ON sjd.skill_id=ps.skill_id
    ) AS src
ON tgt.skill_id=src.skill_id
    AND tgt.job_id=src.job_id

-- WHEN MATCHED (UPDATE)
WHEN MATCHED THEN
UPDATE SET
    priority_lvl = src.priority_lvl,
    skill_name = src.skill_name

-- WHEN NOT MATCHED (INSERT)
WHEN NOT MATCHED THEN
INSERT (
    job_id,
    skill_id,
    skill_name,
    priority_lvl,
    status
)
VALUES
(
    src.job_id,
    src.skill_id,
    src.skill_name,
    src.priority_lvl,
    'NEW_SKILL'
);

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities WHERE status='NEW_SKILL' LIMIT 10;