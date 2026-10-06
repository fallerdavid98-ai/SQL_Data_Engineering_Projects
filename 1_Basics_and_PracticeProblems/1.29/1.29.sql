-- Final Example: Conditional Calculations (COALESCE)
-- Compute a standardized_salary using yealry salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize salaries into tiers of:
--     < 75K 'Low'
--     75K - 150K 'Medium'
--     >= 150K 'High'

SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg,salary_hour_avg*2_080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2_080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2_080) < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
    OR salary_year_avg IS NOT NULL;