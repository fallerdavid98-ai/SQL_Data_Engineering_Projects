-- 1) Create star schema tables in DWH

CREATE TABLE IF NOT EXISTS company_dim (
company_id INTEGER PRIMARY KEY,
name VARCHAR
);

CREATE TABLE IF NOT EXISTS skills_dim (
    skill_id INTEGER PRIMARY KEY,
    skill VARCHAR,
    type VARCHAR
);

CREATE TABLE IF NOT EXISTS job_postings_fact (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    job_title_short VARCHAR,
    job_title VARCHAR,
    job_location VARCHAR,
    job_via VARCHAR,
    job_work_from_home BOOLEAN,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR,
    salary_rate VARCHAR,
    salary_year_avg DOUBLE,
    salary_hour_avg DOUBLE,

    FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);

CREATE TABLE IF NOT EXISTS skills_job_dim (
    skill_id INTEGER,
    job_id INTEGER,

    PRIMARY KEY (skill_id,job_id),
    FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id)
);

-- CLI statement:
-- duckdb dw_marts.duckdb -c ".read 01_Table_Creation_DWH.sql"
