CREATE DATABASE IF NOT EXISTS job_mart; -- Create DB if DB does not already exist

SHOW DATABASES;

DROP DATABASE IF EXISTS job_mart; -- Drops (removes) DB if DB already exists

SHOW DATABASES;

CREATE SCHEMA IF NOT EXISTS job_mart.staging; -- create new schema w/o direct connection to schema DB job_mart

SELECT * FROM information_schema.schemata;

CREATE SCHEMA IF NOT EXISTS staging; -- create new schema with direct connection to schema DB job_mart

DROP SCHEMA IF  EXISTS staging; -- drop existing schema with direct connection to schema DB job_mart

CREATE TABLE IF NOT EXISTS prefered_roles (
    role_id int,
    role_name varchar
); -- create new table (automatically assigns table to schema 'main' in DuckDB)

CREATE TABLE IF NOT EXISTS job_mart.staging.prefered_roles (
    role_id int PRIMARY KEY,
    role_name varchar
); -- create new table while specifying DB & schema

DROP TABLE IF EXISTS prefered_roles; -- drop table (automatically drops from schema 'main' in DuckDB)

DROP TABLE IF EXISTS job_mart.staging.prefered_roles; -- drop table while specifying DB & schema

SELECT * FROM information_schema.tables
WHERE table_catalog='job_mart';