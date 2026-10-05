/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on German Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

-- Main query building in query 2.1.1 EDA1.
SELECT 
    sd.skills AS in_demand_skills,
    CAST(median(jpf.salary_year_avg) AS BIGINT) AS median_salary_for_skill,
    count(jpf.salary_year_avg) AS demand_for_skill,
    round((median(jpf.salary_year_avg)*ln(count(jpf.salary_year_avg))/1_000_000),2) AS optimal_skill_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_country='Germany' AND jpf.job_title_short LIKE '%Data_Engineer%' AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING count(jpf.salary_year_avg)>=5
ORDER BY median(jpf.salary_year_avg)*ln(count(jpf.salary_year_avg)) DESC
LIMIT 20;

/*
-- Output main query.
│ in_demand_skills │ median_salary_for_skill │ demand_for_skill │ optimal_skill_score │
│     varchar      │          int64          │      int64       │       double        │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ sql              │                  147500 │               41 │                0.55 │
│ python           │                  147500 │               37 │                0.53 │
│ spark            │                  147500 │               29 │                 0.5 │
│ aws              │                  147500 │               27 │                0.49 │
│ azure            │                  147500 │               22 │                0.46 │
│ databricks       │                  147500 │               14 │                0.39 │
│ airflow          │                  147500 │               14 │                0.39 │
│ gcp              │                  147500 │               10 │                0.34 │
│ git              │                  147500 │               10 │                0.34 │
│ snowflake        │                  147500 │                9 │                0.32 │
│ sap              │                  147500 │                8 │                0.31 │
│ go               │                  147500 │                8 │                0.31 │
│ kafka            │                  147500 │                8 │                0.31 │
│ redshift         │                  147500 │                7 │                0.29 │
│ terraform        │                  147500 │                7 │                0.29 │
│ pyspark          │                  147500 │                6 │                0.26 │
│ scala            │                  147500 │                6 │                0.26 │
│ bigquery         │                  147500 │                5 │                0.24 │
│ java             │                   98283 │               11 │                0.24 │
│ docker           │                   89100 │                7 │                0.17 │
└──────────────────┴─────────────────────────┴──────────────────┴─────────────────────┘
  20 rows                                                                   4 columns
*/

/*
-- Takeaways & insights.
- SQL achieves the highest optimal skill score at 0.55. With 41 salary-disclosed job postings and a median salary of 147,500, it offers the strongest combination of demand and compensation.
- Python ranks closely behind SQL with a score of 0.53. This confirms that SQL and Python form the most valuable foundational skill combination for data engineering careers.
- Spark ranks third at 0.50, demonstrating the importance of distributed data processing. Its strong position makes it the most valuable specialized data-processing technology in the ranking.
- AWS and Azure rank fourth and fifth. Both combine a median salary of 147,500 with substantial demand, confirming that cloud-platform expertise is a central component of the German data engineering market.
- Databricks and Airflow share a score of 0.39. This highlights the value of both modern data platforms and workflow orchestration alongside core programming and cloud skills.
- All three major cloud ecosystems are represented: AWS, Azure, and GCP. However, AWS and Azure appear considerably more frequently in the salary-disclosed sample than GCP.
- Snowflake, Redshift, and BigQuery demonstrate demand for cloud-native data warehouse technologies. Snowflake achieves the strongest score among these specialized warehouse platforms.
- Kafka and Terraform both reach a score of 0.31. They provide additional value in streaming architectures and infrastructure automation, although they are less frequently requested than the core data-processing technologies.
- PySpark and Scala appear together at 0.26, reflecting their close relationship with the Spark ecosystem. Their lower frequency suggests that Spark knowledge may be more broadly required than knowledge of a particular Spark programming interface.
- Java appears in 11 postings but reaches only a score of 0.24 because its median salary of 98,283 is substantially lower than the 147,500 median associated with most higher-ranked skills.
- BigQuery also scores 0.24 despite appearing in only five postings. Its higher median salary compensates for its lower frequency, illustrating how the score balances demand and compensation.
- Docker ranks last among the top 20, with a median salary of 89,100 and an optimal skill score of 0.17. It may remain a useful supporting technology, but the available results do not identify it as a primary salary differentiator.
- A practical learning sequence based on the ranking would be: SQL and Python first; Spark and one major cloud platform second; followed by Airflow and Databricks; and finally Kafka, Terraform, cloud warehouses, and JVM-based technologies according to the target role.
*/

/*
-- Output from updated DB.
┌──────────────────┬─────────────────────────┬──────────────────┬─────────────────────┐
│ in_demand_skills │ median_salary_for_skill │ demand_for_skill │ optimal_skill_score │
│     varchar      │          int64          │      int64       │       double        │
├──────────────────┼─────────────────────────┼──────────────────┼─────────────────────┤
│ sql              │                  147500 │               42 │                0.55 │
│ python           │                  146750 │               38 │                0.53 │
│ spark            │                  147500 │               29 │                 0.5 │
│ aws              │                  143750 │               28 │                0.48 │
│ azure            │                  147500 │               23 │                0.46 │
│ databricks       │                  147500 │               15 │                 0.4 │
│ airflow          │                  147500 │               14 │                0.39 │
│ gcp              │                  147500 │               11 │                0.35 │
│ git              │                  147500 │               11 │                0.35 │
│ snowflake        │                  147500 │                9 │                0.32 │
│ sap              │                  147500 │                8 │                0.31 │
│ go               │                  147500 │                8 │                0.31 │
│ kafka            │                  147500 │                8 │                0.31 │
│ pyspark          │                  147500 │                7 │                0.29 │
│ terraform        │                  147500 │                7 │                0.29 │
│ redshift         │                  147500 │                7 │                0.29 │
│ scala            │                  147500 │                6 │                0.26 │
│ postgresql       │                  155000 │                5 │                0.25 │
│ bigquery         │                  147500 │                5 │                0.24 │
│ java             │                   98283 │               11 │                0.24 │
└──────────────────┴─────────────────────────┴──────────────────┴─────────────────────┘
  20 rows                                                                   4 columns
*/