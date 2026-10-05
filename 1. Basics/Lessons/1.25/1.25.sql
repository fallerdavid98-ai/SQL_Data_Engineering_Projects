-- Final Example: Conditional Calculations (CASE WHEN)
-- Compute a standardized_salary using yealry salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize salaries into tiers of:
--     < 75K 'Low'
--     75K - 150K 'Medium'
--     >= 150K 'High'

WITH cte1 AS (    
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE 
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2_080
            --ELSE NULL
        END AS standardized_salary
    FROM job_postings_fact
    WHERE salary_hour_avg IS NOT NULL 
        OR salary_year_avg IS NOT NULL
)

SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    standardized_salary,
    CASE
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM cte1;