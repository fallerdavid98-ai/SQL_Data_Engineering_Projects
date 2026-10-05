-- Arrays: Build a flat skill table for co-workers to access job titles, salary info and skills in one table

CREATE OR REPLACE TEMPORARY TABLE job_skills_array AS(
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id=sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sjd.skill_id=sd.skill_id
    GROUP BY 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg
);

-- SELECT * 
-- FROM job_skills_array
-- LIMIT 20;

-- Analyze the median salary per skill from the perspective of a data analyst

WITH flat_skills AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)

SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
HAVING MEDIAN(salary_year_avg) IS NOT NULL
ORDER BY median_salary DESC;

-- Build a flat skill & type table for co-workers to access job titles, salary info, skills and type in one table

CREATE OR REPLACE TEMPORARY TABLE skills_types AS(
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(
            STRUCT_PACK(
                skill_type := sd.type,
                skill_name := sd.skills
            )
        ) AS skills_aos
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id=sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sjd.skill_id=sd.skill_id
    GROUP BY 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg
);

-- Analyze the median salary per type of skill from the perspective of a data analyst

WITH flat_type_of_skills AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_aos).skill_type AS skill_type,
        --UNNEST(skills_aos).skill_name AS skill_name
    FROM skills_types
)

SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_type_of_skills
GROUP BY skill_type
HAVING skill_type IS NOT NULL
ORDER BY median_salary DESC;

-- Problem Statement: As a data engineer, you need to provide a high-level summary of where different companies are actively hiring. 
-- This information helps the recruitment team understand the geographic distribution of job opportunities across the platform.

SELECT
    cd.name AS company_name,
    ARRAY_AGG(DISTINCT TRIM(jps.job_location)) AS hiring_locations
FROM job_postings_fact AS jps
LEFT JOIN company_dim AS cd
    ON jps.company_id=cd.company_id
GROUP BY cd.name;


-- Problem Statement: Analyze job postings to determine the technical breadth required for specific roles by calculating 
-- the average number of skills listed per posting for Data Engineer and Data Analyst positions.

WITH job_skill_counts AS (
    SELECT
        jps.job_id,
        jps.job_title_short,
       -- ARRAY_AGG(sjd.skill_id) AS skill_arr,
        ARRAY_LENGTH(ARRAY_AGG(sjd.skill_id)) AS len_skill_arr
    FROM job_postings_fact AS jps
    LEFT JOIN skills_job_dim AS sjd
    ON jps.job_id=sjd.job_id
    WHERE job_title_short IN ('Data Engineer','Data Analyst')
    GROUP BY jps.job_id,jps.job_title_short
)

-- SELECT * FROM job_skill_counts LIMIT 5;

SELECT 
    job_title_short,
    AVG(len_skill_arr) AS avg_skills_req
 FROM job_skill_counts
 GROUP BY job_title_short;

-- Problem Statement: In this exercise, you will evaluate the geographic reach of various companies by analyzing how many unique locations they are hiring in. 
-- This helps identify organizations with a broad physical presence or decentralized hiring strategy, which is a key metric for understanding 
-- company growth and operational diversity.

SELECT
    cd.name AS company_name,
    ARRAY_LENGTH(ARRAY_AGG(DISTINCT TRIM(jps.job_location))) AS location_diversity_count
FROM job_postings_fact AS jps
LEFT JOIN company_dim AS cd
    ON jps.company_id=cd.company_id
GROUP BY cd.name
HAVING ARRAY_LENGTH(ARRAY_AGG(DISTINCT TRIM(jps.job_location))) > 5
ORDER BY location_diversity_count DESC;

-- Problem Statement: In data engineering workflows, you often encounter nested data structures or need to transform data between aggregated and relational formats. 
-- For this exercise, you will practice converting a list of skill IDs into an array for each job, then "flattening" that array back into 
-- individual rows to join with metadata and retrieve the human-readable skill names.

WITH 
skill_id_cte AS (
    SELECT 
        job_id,
        ARRAY_AGG(DISTINCT skill_id) AS skill_id_array
    FROM skills_job_dim
    GROUP BY job_id
),
unnest_skill_cte AS (
    SELECT
        job_id,
        UNNEST(skill_id_array) AS unnested_skill_id
    FROM skill_id_cte
)

SELECT
    usc.job_id,
    sd.skills AS skill_name
FROM skills_dim AS sd
JOIN unnest_skill_cte AS usc
ON sd.skill_id=usc.unnested_skill_id;

-- Problem Statement: In this analysis, we aim to identify the organizations that demonstrate the highest variety in technical requirements 
-- by counting the unique skills associated with their job postings. This helps in understanding which companies have the most diverse 
-- technology stacks or varied role requirements.

WITH 
unique_skill_ids AS (
    SELECT
        jpf.company_id,
        ARRAY_LENGTH(ARRAY_AGG(DISTINCT sjd.skill_id)) AS unique_skill_count
    FROM job_postings_fact AS jpf
    JOIN skills_job_dim AS sjd
        ON jpf.job_id=sjd.job_id
    GROUP BY jpf.company_id
),
comp_name_unique_skills AS (
    SELECT
        cd.name AS company_name,
        usi.unique_skill_count,
        DENSE_RANK() OVER(
            ORDER BY usi.unique_skill_count DESC
        ) AS diversity_rank
    FROM unique_skill_ids AS usi
    JOIN company_dim AS cd
        ON usi.company_id=cd.company_id
)

SELECT 
    * 
FROM comp_name_unique_skills 
WHERe diversity_rank <= 10;

