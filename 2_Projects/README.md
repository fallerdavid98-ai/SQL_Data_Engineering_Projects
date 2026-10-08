# SQL Data Engineering Projects

This directory contains the completed portfolio projects in this repository. Each project links its business or engineering objective to inspectable SQL, architecture diagrams, execution guidance, and documented limitations.

## Project Overview

| No. | Project | Status | Primary Focus |
|---:|---|---|---|
| 2.1 | [EDA with SQL](./2.1_EDA_with_SQL/) | Completed | SQL analytics, job-market insights, and transparent skill prioritization |
| 2.2 | [Building a Data Warehouse](./2.2_Building_DWH/) | Completed | Warehouse creation, cloud CSV loading, analytical marts, validation, and snapshot synchronization |

No Project 2.3 or Project 3 directory currently exists in this repository. Possible future additions are listed only as roadmap ideas below.

---

## 2.1 EDA with SQL

[Open the complete project](./2.1_EDA_with_SQL/)

![EDA project overview](../Images/1_1_Project1_EDA.png)

This project analyzes the German job market for Data Engineers using DuckDB and a relational job-posting dataset. Three SQL analyses examine:

1. the most in-demand skills;
2. the skills associated with the highest median salaries; and
3. the strongest observed balance between compensation and demand.

**Skills demonstrated:**

- multi-table joins across fact, dimension, and bridge tables
- aggregation, top-N analysis, and median-based salary analysis
- calculated ranking metrics using `LN()` and `ROUND()`
- filtering aggregated results with `HAVING`
- interpretation of missing values, sample sizes, and correlation limits
- reproducible analytical documentation

---

## 2.2 Building a Data Warehouse and Data Marts

[Open the complete project](./2.2_Building_DWH/)

![Project 2.2 pipeline architecture](../Images/1_2_Project2_Data_Pipeline.png)

This project implements an ordered SQL pipeline from cloud-hosted CSV files to a normalized DuckDB warehouse and three analytical marts:

1. **Flat Mart** — one denormalized row per job posting with company information and nested skill structures;
2. **Skills Mart** — monthly skill-demand measures by skill and standardized job title; and
3. **Priority Mart** — a priority-role snapshot synchronized with the warehouse using `MERGE`.

The pipeline includes schema creation, explicit source loading, dimensional transformations, row-count and sample validation, a controlled priority-role update scenario, and a master orchestration script.

**Skills demonstrated:**

- fact, dimension, and bridge-table modeling
- remote CSV ingestion with DuckDB `read_csv`
- CTAS and schema-specific mart creation
- arrays and structs with `ARRAY_AGG` and `STRUCT_PACK`
- monthly dimensions using `DATE_TRUNC` and `EXTRACT`
- additive count measures and explicit fact-table grain
- `MERGE`-based update, insert, and deletion logic
- dependency-aware execution through DuckDB CLI `.read` commands

---

## Portfolio Approach

Each completed project aims to provide:

- a clearly defined analytical or engineering objective;
- inspectable SQL and supporting implementation files;
- links between implementation code and architecture diagrams;
- documented design decisions, validation steps, and limitations; and
- a concise technical narrative suitable for review by recruiters and engineering teams.

Only completed and publicly available work is presented as implemented.

## Optional Future Extensions

The following items are ideas only and have no corresponding project directory or implementation yet:

- **Project 3:** potential flat-source-to-warehouse build inspired by the course roadmap; and
- additional marts or production controls such as scheduling, logging, automated tests, and monitoring.

They will be added to the project table only after their implementation is available in the repository.
