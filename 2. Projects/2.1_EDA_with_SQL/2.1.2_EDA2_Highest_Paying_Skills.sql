/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on job postings in Germany
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

-- Main query building in query 2.1.1 EDA1.
SELECT 
    sd.skills AS in_demand_skills,
    CAST(median(jpf.salary_year_avg) AS BIGINT) AS median_salary_for_skill,
    count(sjd.*) AS demand_for_skill
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id=sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id=sd.skill_id
WHERE jpf.job_country='Germany' AND jpf.job_title_short LIKE '%Data_Engineer%'
GROUP BY sd.skills
HAVING count(sjd.*)>=50
ORDER BY median(jpf.salary_year_avg) DESC
LIMIT 20;


/*
-- Output main query.
┌──────────────────┬─────────────────────────┬──────────────────┐
│ in_demand_skills │ median_salary_for_skill │ demand_for_skill │
│     varchar      │          int64          │      int64       │
├──────────────────┼─────────────────────────┼──────────────────┤
│ github           │                  200000 │              532 │
│ powershell       │                  170545 │              189 │
│ windows          │                  170545 │              202 │
│ redis            │                  170545 │               82 │
│ ansible          │                  170545 │              243 │
│ mysql            │                  159022 │              613 │
│ mongodb          │                  159022 │              926 │
│ fastapi          │                  153500 │              141 │
│ tableau          │                  153500 │             1009 │
│ graphql          │                  153500 │               92 │
│ go               │                  147500 │              622 │
│ gdpr             │                  147500 │              195 │
│ git              │                  147500 │             1602 │
│ terraform        │                  147500 │             1383 │
│ julia            │                  147500 │              100 │
│ cassandra        │                  147500 │              274 │
│ aws              │                  147500 │             4240 │
│ airflow          │                  147500 │             2156 │
│ spark            │                  147500 │             3420 │
│ python           │                  147500 │             8842 │
└──────────────────┴─────────────────────────┴──────────────────┘
  20 rows                                             3 columns
*/

/*
-- Takeaways & insights.
- GitHub ranks first, with a median salary of 200,000 and 532 associated job postings. It represents the strongest salary result among skills meeting the minimum demand threshold.
- Windows, Redis, Ansible, and PowerShell share the second-highest median salary of 170,545. Their demand varies considerably, ranging from 82 postings for Redis to 243 for Ansible.
- MongoDB combines a comparatively high median salary of 159,022 with substantial demand across 926 postings. This gives it a stronger salary–demand balance than many of the more specialized technologies near the top.
- MySQL records the same median salary of 159,022 but appears in 613 postings. Both relational and NoSQL database expertise are therefore represented among the higher-paying results.
- FastAPI and GraphQL reach a median salary of 153,500 but have relatively limited demand, at 141 and 92 postings respectively. They appear to be specialized premium skills rather than broad market requirements.
- Tableau stands out with a median salary of 153,500 and 1,009 postings. It offers a notable combination of above-average compensation and relatively strong demand.
- SQL has the highest demand in the ranking, appearing in 7,733 postings, while maintaining a median salary of 147,500. It remains the most broadly valuable foundational skill in the results.
- AWS, Spark, and Airflow also combine strong demand with a median salary of 147,500. Together, they represent three central layers of modern data engineering: cloud infrastructure, distributed processing, and workflow orchestration.
- Terraform records 1,383 postings at the same 147,500 median salary, demonstrating the importance of infrastructure-as-code skills in data engineering environments.
- Git appears in 1,602 postings, while GitHub appears in 532. Git is therefore the broader market requirement, although GitHub is associated with the highest median salary in this analysis.
- Redis, GraphQL, scikit-learn, FastAPI, DynamoDB, and Cassandra show comparatively low demand. These technologies may provide specialization value but are less suitable as first-priority learning targets.
- From a skill-development perspective, SQL, AWS, Spark, Airflow, Git, and Terraform provide the strongest balance between compensation and market demand. GitHub, MongoDB, Tableau, and Ansible may serve as valuable complementary skills.
*/

/*
-- Output from updated DB.
┌──────────────────┬─────────────────────────┬──────────────────┐
│ in_demand_skills │ median_salary_for_skill │ demand_for_skill │
│     varchar      │          int64          │      int64       │
├──────────────────┼─────────────────────────┼──────────────────┤
│ elasticsearch    │                  248000 │              204 │
│ github           │                  200000 │              525 │
│ gitlab           │                  197750 │              601 │
│ powershell       │                  170545 │              193 │
│ windows          │                  170545 │              214 │
│ ansible          │                  170545 │              231 │
│ redis            │                  170545 │               89 │
│ mongodb          │                  159022 │              970 │
│ mysql            │                  159022 │              617 │
│ postgresql       │                  155000 │             1054 │
│ tableau          │                  153500 │             1095 │
│ fastapi          │                  153500 │              154 │
│ graphql          │                  153500 │               92 │
│ gdpr             │                  147500 │              189 │
│ spark            │                  147500 │             3605 │
│ terraform        │                  147500 │             1472 │
│ looker           │                  147500 │              330 │
│ sap              │                  147500 │              931 │
│ hadoop           │                  147500 │             1430 │
│ sql              │                  147500 │             8039 │
└──────────────────┴─────────────────────────┴──────────────────┘
  20 rows                                             3 columns
*/