-- 1.20.1

SELECT 
    CAST(job_posted_date AS date) AS dt,
    count(job_id) AS job_postings
FROM data_jobs.job_postings_fact
GROUP BY CAST(job_posted_date AS date)
HAVING CAST(job_posted_date AS date) = CAST('2024-12-31' AS date);


-- 1.20.2

SELECT 
    job_title_short,
    CAST(job_no_degree_mention AS int) AS degree_or_not,
    count(job_id) AS job_postings
FROM data_jobs.job_postings_fact
WHERE CAST(job_posted_date AS date) BETWEEN CAST('2024-12-01' AS date) AND CAST('2024-12-31' AS date)
GROUP BY job_title_short,CAST(job_no_degree_mention AS int)
ORDER BY job_title_short,CAST(job_no_degree_mention AS int); 


--1.20.4

SELECT
    job_posted_date,
    company_id,
    job_title_short,
    CAST(job_posted_date AS date) AS dt,
    CAST(company_id || '-' || CAST(job_posted_date AS date) AS varchar) AS compund_key
--  Other SQL dialects might use '+' or the concat() function for concatenating values.  
FROM job_postings_fact
LIMIT 10;


--1.20.5 (Potential CTE use case for improved readability)

SELECT
    job_title_short,
    job_work_from_home,
    CAST(AVG(salary_year_avg) AS int) AS annual_salary_avg,
    CAST(
        AVG(
            CASE
                WHEN job_work_from_home = TRUE THEN 1
                WHEN job_work_from_home = FALSE THEN 0
                ELSE NULL
            END
            * ((salary_year_avg / 2080.0) * 260)
        )
        AS INTEGER
    ) AS annual_commute_cost_savings,
    CAST(
        AVG(salary_year_avg)
        +
        AVG(
            CASE
                WHEN job_work_from_home = TRUE THEN 1
                WHEN job_work_from_home = FALSE THEN 0
                ELSE NULL
            END
            * ((salary_year_avg / 2080.0) * 260)
        )
        AS INTEGER
    ) AS adjusted_annual_salary_avg
FROM job_postings_fact
WHERE job_country = 'United States' AND job_title_short LIKE '%Data%'
GROUP BY job_title_short, job_work_from_home
ORDER BY job_title_short DESC, job_work_from_home ASC;