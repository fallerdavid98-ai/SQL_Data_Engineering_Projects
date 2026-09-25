-- DROP DATABASE IF EXISTS job_mart;

-- DROP SCHEMA IF EXISTS job_mart.staging;

DROP TABLE IF EXISTS job_mart.staging.prefered_roles;

CREATE DATABASE IF NOT EXISTS job_mart;

CREATE SCHEMA IF NOT EXISTS job_mart.staging;

CREATE TABLE IF NOT EXISTS job_mart.staging.prefered_roles (
    role_id int PRIMARY KEY,
    role_name varchar
);

SELECT * FROM information_schema.tables
WHERE table_catalog='job_mart';