-- Update status from 'active' to 'urgent'
UPDATE company_jobs.main.job_skill_priorities
SET
    status='URGENT'
WHERE status='ACTIVE';

-- Display the final table
SELECT * FROM company_jobs.main.job_skill_priorities LIMIT 10;