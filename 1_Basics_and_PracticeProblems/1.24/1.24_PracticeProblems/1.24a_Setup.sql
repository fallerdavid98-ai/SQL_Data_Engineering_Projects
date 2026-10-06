-- Create DB
CREATE DATABASE IF NOT EXISTS company_jobs;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS company_jobs.staging;

-- Create Table
CREATE TABLE IF NOT EXISTS company_jobs.staging.priority_skills (
    skill_id INTEGER PRIMARY KEY,
    skill_name VARCHAR,
    priority_lvl INTEGER
);

-- Insert values into table
INSERT INTO company_jobs.staging.priority_skills (
    skill_id,
    skill_name,
    priority_lvl
)
VALUES
(1,'python',1),
(0,'sql',1),
(183,'tableau',2);

-- Display final table
SELECT * FROM company_jobs.staging.priority_skills;

-- Commented out reset
-- DROP TABLE IF EXISTS company_jobs.staging.priority_skills;