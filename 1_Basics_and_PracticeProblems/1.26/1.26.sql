-- Problem statement: From the data_jobs database, calculate and return a single row that shows the count of unique 
-- companies offering Work From Home (WFH) jobs versus the count of unique companies offering Non-WFH jobs.

SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies,
FROM job_postings_fact;

-- Problem statement: Analyze remote job volume for "Data Engineer" roles in the data_jobs database by returning a list 
-- of companies categorized into tiers based on their total number of Work From Home (WFH) job postings.

SELECT
    cd.name AS company_name,
    COUNT(job_id) AS job_count,
    CASE
        WHEN COUNT(job_id) > 100 THEN '100+ WFH DE Jobs'
        WHEN COUNT(job_id) >= 50 THEN '50-100 WFH DE Jobs'
        WHEN COUNT(job_id) >= 25 THEN '25-49 WFH DE Jobs'
        ELSE 'Less than 25 WFH DE Jobs'
    END AS WFH_DE_Job_Category
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id=cd.company_id
WHERE jpf.job_work_from_home = TRUE
    AND jpf.job_title_short = 'Data Engineer'
GROUP BY cd.name
ORDER BY job_count DESC;

-- Problem statement: For all job postings in the data_jobs database that include salary information, analyze the job_title to categorize
-- the role's experience level and determine if the job offers a remote option, returning both classifications as new, derived columns.

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE
        WHEN job_title LIKE '%Senior%' THEN 'Senior Level'
        WHEN job_title LIKE '%Lead%' OR job_title LIKE '%Manager%' THEN 'Lead/Manager Level'
        WHEN job_title LIKE '%Junior%' OR job_title LIKE '%Entry%' THEN 'Junior/Entry Level'
        ELSE 'Not Specified'
    END AS experience_lvl,
    CASE
        WHEN job_work_from_home = 0 THEN 'No' -- Equivalent of: WHEN job_work_from_home = FALSE THEN 'No'
        ELSE 'Yes'
    END AS remote_option
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_id;