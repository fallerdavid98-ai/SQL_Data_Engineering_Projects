/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to job skills
- Identify the top 10 in-demand skills for data engineers
- Focus on job postings in Germany
- Why? Retrieves the top 10 skills with the highest demand in the German market,
    providing insights into the most valuable skills for data engineers in Germany
*/

-- Support Query to identify value representing 'Germany' in job postings table.
SELECT DISTINCT job_country 
FROM job_postings_fact
WHERE job_country LIKE '%Germ%';


-- Support Query to identify value representing 'Data Engineer' or 'Senior Data Engineer' in job posting table.
SELECT DISTINCT job_title_short 
FROM job_postings_fact
WHERE job_title_short LIKE '%Data_Engineer%';


-- Main query.
SELECT 
    sd.skills AS in_demand_skills,
    count(sjd.*) AS demand_for_skill
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_country='Germany' AND jpf.job_title_short LIKE '%Data_Engineer%'
GROUP BY sd.skills
ORDER BY count(sjd.*) DESC
LIMIT 10;

/*
-- Output main query.
┌──────────────────┬──────────────────┐
│ in_demand_skills │ demand_for_skill │
│     varchar      │      int64       │
├──────────────────┼──────────────────┤
│ python           │             8842 │
│ sql              │             7733 │
│ azure            │             5003 │
│ aws              │             4240 │
│ spark            │             3420 │
│ java             │             3001 │
│ kafka            │             2176 │
│ airflow          │             2156 │
│ databricks       │             2100 │
│ scala            │             1854 │
└──────────────────┴──────────────────┘
  10 rows                   2 columns
*\

/*
-- Takeaways & insights.
- Python is the most in-demand skill, with 8,842 mentions, followed by SQL with 7,733. Together, they form the core technical foundation for data engineering roles.
- Python appears approximately 14% more frequently than SQL. Nevertheless, both should be treated as equally important core competencies.
- Cloud expertise is essential. Azure ranks third with 5,003 mentions, while AWS follows with 4,240. Azure appears approximately 18% more frequently than AWS.
- Spark ranks fifth with 3,420 mentions, highlighting the importance of large-scale and distributed data processing.
- Java and Scala remain relevant, particularly because of their connection to JVM-based technologies such as Spark and Kafka.
- Kafka records 2,176 mentions, demonstrating considerable demand for streaming and event-driven data architectures.
- Airflow, with 2,156 mentions, ranks almost level with Kafka. This confirms that workflow orchestration and automated data pipelines are central parts of modern data engineering.
- Databricks appears 2,100 times, indicating strong demand for integrated platforms that combine cloud infrastructure, Spark-based processing, data engineering, and analytics.
- Overall, the results describe a typical data engineering stack: Python and SQL as the foundation, Azure or AWS for infrastructure, Spark and Databricks for data processing, and Kafka and Airflow for streaming and orchestration.
- A reasonable learning priority would be: Python and SQL first, followed by one major cloud platform, then Spark and Airflow, and finally Kafka, Databricks, and JVM languages depending on the target role.
*\

/*
-- Output from updated DB.
┌──────────────────┬──────────────────┐
│ in_demand_skills │ demand_for_skill │
│     varchar      │      int64       │
├──────────────────┼──────────────────┤
│ python           │             9252 │
│ sql              │             8039 │
│ azure            │             5231 │
│ aws              │             4387 │
│ spark            │             3605 │
│ java             │             3051 │
│ databricks       │             2321 │
│ kafka            │             2313 │
│ airflow          │             2217 │
│ snowflake        │             1907 │
└──────────────────┴──────────────────┘
  10 rows                   2 columns
*\