# SQL Job Market Analytics: Data Engineering Skills in Germany

![Project overview: SQL analysis of Data Engineering skills](../../Images/1_1_Project1_EDA.png)

This exploratory data analysis project examines which technical skills are most relevant for **Data Engineer roles in Germany**. Using DuckDB and a relational job-posting dataset, I translated three career-focused questions into reproducible SQL analyses covering **market demand, salary association, and learning priority**.

The project demonstrates my ability to work with a dimensional data model, design multi-table analytical queries, define transparent ranking logic, and communicate results with the limitations of the underlying data in mind.

---

## Executive Summary

- **SQL and Python are the strongest foundational skills.** They lead the demand analysis with 7,733 and 8,842 skill associations respectively and rank first and second in the combined salary-demand score.
- **Cloud and distributed-processing skills form the next layer.** Azure, AWS, Spark, Databricks, and Airflow all appear prominently across the analyses.
- **SQL provides the strongest balance of salary and observed demand** in salary-disclosed postings, achieving the highest optimal skill score of `0.55`; Python follows at `0.53`.
- **Specialized skills can be associated with high salaries without being broad learning priorities.** GitHub leads the salary ranking, while Redis, FastAPI, and GraphQL show high median salaries but materially lower demand.
- **The analysis distinguishes association from causation.** Seniority, employer, location, and combinations of technologies may influence salary alongside the listed skill.

For a quick technical review:

1. [`2.1.1_EDA1_In_Demand_Skills.sql`](./2.1.1_EDA1_In_Demand_Skills.sql) — ranks skills by overall frequency
2. [`2.1.2_EDA2_Highest_Paying_Skills.sql`](./2.1.2_EDA2_Highest_Paying_Skills.sql) — compares median salary and broader demand
3. [`2.1.3_EDA3_Most_Optimal-Skills.sql`](./2.1.3_EDA3_Most_Optimal-Skills.sql) — combines salary and demand in a logarithmically weighted score

---

## Business Questions

The analysis answers three questions relevant to job-market research and skill-development decisions:

1. Which skills are most frequently associated with Data Engineer job postings in Germany?
2. Which sufficiently common skills are associated with the highest median annual salaries?
3. Which skills offer the strongest balance between compensation and demand among postings with disclosed salaries?

These questions are intentionally separated because **overall market demand** and **demand within salary-disclosed postings** are different analytical populations.

---

## Data Model

The analysis uses a dimensional model with one fact table, two dimensions, and a many-to-many bridge table.

![Data warehouse schema](../../Images/1_2_Data_Warehouse.png)

- `job_postings_fact` contains job attributes such as standardized title, country, and annual salary.
- `skills_job_dim` connects job postings with their required skills.
- `skills_dim` provides readable skill names and skill categories.
- `company_dim` contains employer information, although it is not required by the three queries in this analysis.

---

## Tech Stack

- **DuckDB** — local OLAP query engine
- **SQL** — joins, aggregation, median calculation, logarithmic transformation, and top-N analysis
- **VS Code** — query development and project organization
- **Git and GitHub** — version control and portfolio presentation

---

## Repository Structure

```text
SQL_Data_Engineering_Projects/
├── 1. Basics/
├── 2. Projects/
│   └── 2.1_EDA_with_SQL/
│       ├── 0_update_dataset.sql
│       ├── 2.1.1_EDA1_In_Demand_Skills.sql
│       ├── 2.1.2_EDA2_Highest_Paying_Skills.sql
│       ├── 2.1.3_EDA3_Most_Optimal-Skills.sql
│       └── README.md
└── Images/
    ├── 1_1_Project1_EDA.png
    └── 1_2_Data_Warehouse.png
```

### Optional Dataset Refresh

[`0_update_dataset.sql`](./0_update_dataset.sql) rebuilds the star schema in a separate DuckDB/MotherDuck database and loads the latest available job-posting files from cloud storage. It also validates the refresh with table row counts and the minimum and maximum posting dates.

The tables and findings below summarize the baseline output documented in the analytical SQL files. Those files also retain output from the refreshed database, making changes between dataset snapshots visible and reproducible.

---

## Analysis 1: Most In-Demand Skills

[`2.1.1_EDA1_In_Demand_Skills.sql`](./2.1.1_EDA1_In_Demand_Skills.sql) ranks the ten most frequent skill associations for Data Engineer postings in Germany.

```sql
SELECT
    sd.skills AS in_demand_skills,
    COUNT(sjd.*) AS demand_for_skill
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_country = 'Germany'
  AND jpf.job_title_short LIKE '%Data_Engineer%'
GROUP BY sd.skills
ORDER BY COUNT(sjd.*) DESC
LIMIT 10;
```

| Rank | Skill | Skill associations |
|---:|---|---:|
| 1 | Python | 8,842 |
| 2 | SQL | 7,733 |
| 3 | Azure | 5,003 |
| 4 | AWS | 4,240 |
| 5 | Spark | 3,420 |
| 6 | Java | 3,001 |
| 7 | Kafka | 2,176 |
| 8 | Airflow | 2,156 |
| 9 | Databricks | 2,100 |
| 10 | Scala | 1,854 |

### Key Findings

- Python and SQL clearly form the core programming and querying foundation for Data Engineering roles.
- Azure and AWS confirm that cloud-platform knowledge is a central market requirement; Azure appears around 18% more frequently than AWS in this dataset.
- Spark is the highest-ranked specialized processing technology.
- Kafka and Airflow appear at almost identical levels, highlighting the importance of both event streaming and workflow orchestration.
- Databricks, Java, and Scala reinforce the relevance of cloud-based and JVM-connected data-processing ecosystems.

---

## Analysis 2: Highest-Paying Skills

[`2.1.2_EDA2_Highest_Paying_Skills.sql`](./2.1.2_EDA2_Highest_Paying_Skills.sql) calculates the median annual salary for each skill, retains skills with at least 50 total associations, and includes frequency as context.

### Key Findings

- GitHub has the highest observed median salary at `200,000`, based on 532 total skill associations.
- Windows, Redis, Ansible, and PowerShell share the second-highest median at `170,545`, although their frequencies differ considerably.
- MongoDB combines a high median salary of `159,022` with 926 associations, giving it a stronger salary-demand profile than several niche technologies.
- Tableau stands out at `153,500` across 1,009 associations.
- Python, AWS, Spark, Airflow, Git, and Terraform each show a median of `147,500` alongside comparatively strong demand in the baseline output, making them more broadly relevant learning targets.
- FastAPI, GraphQL, Redis, and similar niche skills may add specialization value, but their lower frequency makes them less suitable as first-priority skills.

The salary ranking shows which skills **occur in higher-paid postings**. It does not establish that a skill independently causes a higher salary.

---

## Analysis 3: Optimal Skills by Salary and Demand

[`2.1.3_EDA3_Most_Optimal-Skills.sql`](./2.1.3_EDA3_Most_Optimal-Skills.sql) focuses only on German Data Engineer postings with a specified annual salary. It applies a logarithmic demand transformation so that common core skills receive appropriate weight without allowing frequency alone to dominate the ranking.

```sql
ROUND(
    MEDIAN(jpf.salary_year_avg)
    * LN(COUNT(jpf.salary_year_avg))
    / 1_000_000,
    2
) AS optimal_skill_score
```

The score is defined as:

$$
\text{Optimal Skill Score}
=\frac{\text{Median Annual Salary}\times\ln(\text{Salary-Bearing Skill Associations})}{1{,}000{,}000}
$$

| Rank | Skill | Median annual salary | Salary-bearing skill associations | Score |
|---:|---|---:|---:|---:|
| 1 | SQL | 147,500 | 41 | 0.55 |
| 2 | Python | 147,500 | 37 | 0.53 |
| 3 | Spark | 147,500 | 29 | 0.50 |
| 4 | AWS | 147,500 | 27 | 0.49 |
| 5 | Azure | 147,500 | 22 | 0.46 |
| 6 | Databricks | 147,500 | 14 | 0.39 |
| 6 | Airflow | 147,500 | 14 | 0.39 |
| 8 | GCP | 147,500 | 10 | 0.34 |
| 8 | Git | 147,500 | 10 | 0.34 |
| 10 | Snowflake | 147,500 | 9 | 0.32 |

### Key Findings

- SQL achieves the highest optimal skill score (`0.55`), followed closely by Python (`0.53`).
- Spark ranks third (`0.50`), making it the strongest specialized data-processing technology in the combined analysis.
- AWS and Azure rank fourth and fifth, while GCP also enters the top ten; cloud expertise is therefore valuable across multiple ecosystems.
- Databricks and Airflow share a score of `0.39`, highlighting the complementary value of managed data platforms and pipeline orchestration.
- Because most leading skills share the same median salary of `147,500`, their relative order is driven mainly by the number of salary-disclosed postings.
- Java and Docker rank lower because their observed median salaries (`98,283` and `89,100`) reduce their combined scores despite practical relevance.

Based on this dataset, a pragmatic learning sequence is:

1. SQL and Python
2. Spark and one major cloud platform
3. Airflow and Databricks
4. Kafka, Terraform, and a relevant cloud data warehouse

---

## SQL and Analytical Skills Demonstrated

- Joined a fact table to a many-to-many bridge and skill dimension using `INNER JOIN`.
- Applied multi-condition filters for country, role category, and salary availability.
- Used `GROUP BY`, `COUNT()`, `MEDIAN()`, `ROUND()`, and `LN()` to create decision-oriented metrics.
- Applied `HAVING` to exclude extremely rare skills from salary-based rankings.
- Used `ORDER BY` and `LIMIT` for clear top-N outputs.
- Distinguished total skill frequency from the smaller salary-disclosed analytical sample.
- Interpreted outputs cautiously by separating correlation from causation and documenting sample limitations.

---

## Methodology and Limitations

- `COUNT(sjd.*)` measures rows in the job-skill bridge. The results represent unique job counts only if each `job_id`–`skill_id` combination occurs no more than once.
- In the salary analysis, `MEDIAN(salary_year_avg)` ignores missing salaries, while the displayed demand count includes all skill associations. A skill may therefore have a smaller salary sample than its demand value suggests.
- In the optimal-skills analysis, `salary_year_avg IS NOT NULL` aligns both the median and count with salary-disclosed postings. The `HAVING` threshold of five reduces extreme outliers but does not eliminate small-sample uncertainty.
- `_` is a single-character wildcard in SQL `LIKE`. The filter `LIKE '%Data_Engineer%'` matches the dataset's role label pattern but is less strict than an equality filter. If `job_title_short` is standardized as `Data Engineer`, `= 'Data Engineer'` is preferable.
- The annual salary currency and normalization method should be verified against the source documentation before external publication.
- The optimal skill score is a prioritization index specific to this dataset. It should not be compared directly with scores calculated from other datasets, time periods, or currencies.

---

## Conclusion

The project moves beyond a simple frequency ranking by comparing three complementary views of the German Data Engineering market. The results point to a consistent core stack—**SQL, Python, cloud platforms, Spark, Airflow, and Databricks**—while also showing why niche, high-salary skills should be interpreted in the context of demand and sample size.

From a portfolio perspective, the analysis demonstrates both technical SQL capability and the judgment required to turn imperfect real-world data into transparent, decision-relevant insights.
