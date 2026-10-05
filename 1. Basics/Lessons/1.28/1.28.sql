--Create temp table for 2023 jobs

CREATE TEMPORARY TABLE jobs_2023 AS
    SELECT 
        * EXCLUDE (job_id,job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

--Create temp table for 2024 jobs

CREATE TEMPORARY TABLE jobs_2024 AS
    SELECT 
        * EXCLUDE (job_id,job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

--Unique job postings across 2023 or 2024

-- SELECT COUNT(*)
-- FROM jobs_2023
-- UNION
-- SELECT COUNT(*)
-- FROM jobs_2024;

SELECT *
FROM jobs_2023
UNION
SELECT *
FROM jobs_2024;

--Total job postings across 2023 and 2024 (including duplicates)

SELECT *
FROM jobs_2023
UNION ALL
SELECT *
FROM jobs_2024;

--Job postings exclusively in 2023

SELECT *
FROM jobs_2023
EXCEPT
SELECT *
FROM jobs_2024;

--Remaining 2023 jobs after subtracting matching 2024 postings (one for one)

SELECT *
FROM jobs_2023
EXCEPT ALL
SELECT *
FROM jobs_2024;

--Job postings both in 2023 and 2024 (excluding duplicates)

SELECT *
FROM jobs_2023
INTERSECT
SELECT *
FROM jobs_2024;

--Job postings both in 2023 and 2024 (including duplicates)

SELECT *
FROM jobs_2023
INTERSECT ALL
SELECT *
FROM jobs_2024;