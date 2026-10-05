-- Problem Statement: Ranking Top Salaries by Job Category


-- w/o QUALIFY operator (subquery, alternatively CTE)
SELECT *
FROM (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        RANK() OVER(
            PARTITION BY job_title_short 
            ORDER BY salary_year_avg DESC
            ) AS salary_rank
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
) AS ranked_salaries
WHERE salary_rank <= 3


-- with QUALIFY operator (only available in some DBMS, less portable than subquery/CTE)
SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    RANK() OVER (
        PARTITION BY job_title_short
        ORDER BY salary_year_avg DESC
    ) AS salary_rank
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
QUALIFY salary_rank <= 3;


-- 2nd Problem Statement: Salary Deviation by Job Title

-- Subquery

SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    avg_salary,
    salary_year_avg - avg_salary AS salary_delta
FROM (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        AVG(salary_year_avg) OVER(
            PARTITION BY job_title_short
            ) AS avg_salary
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
) AS avg_data;

-- CTE

WITH avg_data AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        AVG(salary_year_avg) OVER(
            PARTITION BY job_title_short
            ) AS avg_salary
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
)

SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    avg_salary,
    salary_year_avg - avg_salary AS salary_delta
FROM avg_data;


-- 3rd Problem Statement: Normalizing Salary Scores by Job Title

WITH min_max_salaries AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        MIN(salary_year_avg) OVER(
            PARTITION BY job_title_short
        ) AS min_s,
        MAX(salary_year_avg) OVER(
            PARTITION BY job_title_short
        ) AS max_s
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)

SELECT
    *,
    NULLIF((salary_year_avg-min_s)/(max_s-min_s),0) AS normalized_salary_score
FROM min_max_salaries;