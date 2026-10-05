--Problem statement: Create a custom quarter label by analyzing the text representation of a date. 
--You will combine date truncation with a conditional CASE expression and data type conversion to manually 
--assign a quarter number (1, 2, 3, or 4) based on the month found in the timestamp string.

-- 1st step

SELECT
  DATE_TRUNC('quarter', job_posted_date) AS job_quarter,
  COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE
  DATE_TRUNC('year', job_posted_date) BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY
  job_quarter
ORDER BY
  job_quarter;

-- final step

SELECT
  DATE_TRUNC('quarter', job_posted_date) AS job_quarter,
--   (EXTRACT(YEAR FROM job_posted_date) ||'-'|| EXTRACT(QUARTER FROM job_posted_date)) AS formatted_quarter,
  CASE
    WHEN CAST(DATE_TRUNC('quarter', job_posted_date) AS VARCHAR) LIKE '%-01-%' THEN '1'
    WHEN CAST(DATE_TRUNC('quarter', job_posted_date) AS VARCHAR) LIKE '%-04-%' THEN '2'
    WHEN CAST(DATE_TRUNC('quarter', job_posted_date) AS VARCHAR) LIKE '%-07-%' THEN '3'
    ELSE '4'
   END AS formatted_quarter,
  COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE
  DATE_TRUNC('year', job_posted_date) BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY
  job_quarter,formatted_quarter
ORDER BY
  job_quarter;