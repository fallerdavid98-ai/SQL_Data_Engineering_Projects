CREATE DATABASE IF NOT EXISTS company_jobs;

CREATE SCHEMA IF NOT EXISTS company_jobs.staging;

DROP SCHEMA IF EXISTS company_jobs.staging;

CREATE SCHEMA IF NOT EXISTS company_jobs.dev;

SELECT * FROM information_schema.schemata WHERE catalog_name='company_jobs';

-- TBC

DROP DATABASE IF EXISTS company_jobs;
-- .databases