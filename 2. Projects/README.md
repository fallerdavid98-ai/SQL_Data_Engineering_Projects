# SQL Data Engineering Projects

This directory contains hands-on projects through which I apply and extend core SQL and Data Engineering concepts. The portfolio is being developed progressively: completed projects are linked and documented in detail, while future projects are clearly marked as planned.

## Project Overview

| No. | Project | Status | Primary Focus |
|---:|---|---|---|
| 2.1 | [EDA with SQL](./2.1_EDA_with_SQL/) | Completed | SQL analytics, job-market insights, dimensional data model |
| 2.2 | Data Warehouse | Planned | Data warehouse design and implementation |
| 2.3 | Flat to DWH | Planned | Transformation of flat source data into a dimensional warehouse model |

---

## 2.1 EDA with SQL

[Open the complete project](./2.1_EDA_with_SQL/)

![EDA project overview](../Images/1_1_Project1_EDA.png)

This project analyzes the German job market for Data Engineers using DuckDB and a relational job-posting dataset. Three SQL analyses examine:

1. the most in-demand skills,
2. the skills associated with the highest median salaries, and
3. the strongest balance between compensation and demand.

The project includes a documented methodology, recruiter-oriented findings, and an optional dataset-refresh workflow for rebuilding the underlying star schema with newer job-posting data.

**Skills demonstrated:**

- multi-table joins across fact, dimension, and bridge tables
- aggregation and top-N analysis with `GROUP BY`, `COUNT()`, `ORDER BY`, and `LIMIT`
- median-based salary analysis
- aggregated-result filtering with `HAVING`
- calculated ranking metrics using `LN()` and `ROUND()`
- methodological interpretation of missing values, sample sizes, and correlation limits
- analytical documentation and reproducible project presentation

---

## 2.2 Data Warehouse

**Status: Planned**

The local project directory has been prepared, but the project has not yet been implemented or published. A link and detailed technical description will be added once the first working version is available.

---

## 2.3 Flat to DWH

**Status: Planned**

The local project directory has been prepared, but the project has not yet been implemented or published. The future project will focus on transforming flat source data into a structured dimensional warehouse model. A link and implementation details will be added after the project contains reviewable code and documentation.

---

## Portfolio Approach

Each completed project is intended to provide:

- a clearly defined analytical or engineering objective,
- inspectable SQL and supporting implementation files,
- documented design decisions and limitations,
- reproducible outputs or validation steps, and
- a concise README for technical reviewers and recruiters.

Only completed and publicly available work is presented as implemented. Planned projects remain explicitly labeled until their code and documentation are ready for review.
