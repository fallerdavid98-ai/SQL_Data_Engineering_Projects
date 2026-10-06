-- Problem statement: Identify jobs that offer remote work options by constructing a query that pulls data from a filtered subquery.

SELECT *
FROM (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
);

-- Problem statement: Identify high-paying job postings (>$100K) from Google by using a subquery to retrieve the company's identifier based on its name.

SELECT
    job_id,
    job_title_short,
    job_location
FROM job_postings_fact
WHERE company_id = (
    SELECT 
        company_id
    FROM company_dim
    WHERE name = 'Google'
)
AND salary_year_avg > 100_000;

-- Problem statement: You will use a Common Table Expression (CTE) to identify job postings that pay more than their specific company's average salary. 
-- Calculating company-level aggregations in a CTE first allows you to cleanly join and compare those baselines against individual records in your main query.

WITH company_avg AS (
    SELECT
        company_id,
        AVG(salary_year_avg) AS avg_comp_salary
    FROM data_jobs.job_postings_fact
    GROUP BY company_id
)

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.company_id,
    jpf.salary_year_avg,
    ca.avg_comp_salary
FROM data_jobs.job_postings_fact AS jpf
INNER JOIN company_avg AS ca
ON jpf.company_id=ca.company_id
WHERE salary_year_avg>avg_comp_salary;

-- Problem statement: Identify job postings located in countries that have high market activity. Specifically, you need to find jobs 
-- in countries where the total number of job postings exceeds the average number of postings per country.

SELECT
    job_id,
    job_title_short,
    job_location
FROM job_postings_fact
WHERE job_country IN (
    SELECT 
        job_country
    FROM job_postings_fact
    GROUP BY job_country
    HAVING
        COUNT(job_id) > (         
        SELECT 
            AVG(job_count_by_country)
        FROM (
            SELECT
                job_country,
                COUNT(job_id) AS job_count_by_country
            FROM job_postings_fact
            GROUP BY job_country
        )
    )
);

-- Problem statement: Identify active hiring companies by retrieving the names of all companies that currently have at least one job 
-- posting recorded in the database. This helps differentiate between all registered companies and those with active market presence.

SELECT 
    cd.name
FROM 
    company_dim AS cd
WHERE EXISTS (
    SELECT 1 
    FROM job_postings_fact AS jpf 
    WHERE jpf.company_id = cd.company_id
);

-- Problem statement: Identify and extract a list of specific skills that have zero association with 'Senior Data Engineer' job postings. 
-- This analysis helps determine which technical skills in the database are currently not being utilized or required for this specific high-level role.

SELECT
    skills
FROM skills_dim
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf
    ON sjd.job_id = jpf.job_id
    WHERE sjd.skill_id=skills_dim.skill_id 
        AND jpf.job_title_short = 'Senior Data Engineer'
);