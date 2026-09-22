SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id=cd.company_id
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name
FROM job_postings_fact AS jpf
JOIN company_dim AS cd
ON jpf.company_id=cd.company_id
LIMIT 10;

SELECT
    count(*)
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id=cd.company_id;

SELECT
    count(*)
FROM job_postings_fact AS jpf
JOIN company_dim AS cd
ON jpf.company_id=cd.company_id;

SELECT
    count(*)
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
ON jpf.company_id=cd.company_id;


--INNER JOIN
SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills,
FROM job_postings_fact AS jpf
JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id;
--LIMIT 10;

--LEFT JOIN
SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills,
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id;
--LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_posted_date
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
ON jpf.company_id=cd.company_id
WHERE job_title_short='Data Engineer'
ORDER BY job_posted_date DESC;


-- Problem Statement: Determine the frequency of each skill mentioned across all job postings where the job title contains the word "Data" in the data_jobs database.

SELECT
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_title_short LIKE '%Data%'
GROUP BY
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
ORDER BY count(*) DESC;

/*
-- My own Variation
SELECT
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
GROUP BY
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
HAVING jpf.job_title_short='Data Engineer'
ORDER BY count(*) DESC;
*/


-- Problem Statement: Identify the most frequently required skills for each job title in the data_jobs database, for job postings that offer a yearly salary greater than $100,000.

SELECT
    jpf.job_title_short,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.salary_year_avg>100_000
GROUP BY
    jpf.job_title_short,
    sd.skills
ORDER BY count(*) DESC;


-- Problem Statement: Measure how frequently each skill appears in “Data” roles in the data_jobs database, starting from the skills lookup table

SELECT
    sjd.skill_id,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_title_short LIKE '%Data%'
GROUP BY
    sjd.skill_id,
    sd.skills
ORDER BY count(*) DESC;

-- Execution plan with EXPLAIN keyword (DuckDB) --> No acutal execution
-- Execution plan with EXPLAIN ANALYZE (DuckDB) --> Plan + acutal execution (incl. execution time total and per step)

EXPLAIN 
SELECT
    sjd.skill_id,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_title_short LIKE '%Data%'
GROUP BY
    sjd.skill_id,
    sd.skills
ORDER BY count(*) DESC;


EXPLAIN ANALYZE
SELECT
    sjd.skill_id,
    sd.skills,
    count(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_title_short LIKE '%Data%'
GROUP BY
    sjd.skill_id,
    sd.skills
ORDER BY count(*) DESC;