--1. Create new DB, Schema & Table within Schema

DROP DATABASE IF EXISTS job_mart;

--DROP SCHEMA IF EXISTS job_mart.staging;

--DROP TABLE IF EXISTS job_mart.staging.prefered_roles;

CREATE DATABASE IF NOT EXISTS job_mart;

CREATE SCHEMA IF NOT EXISTS job_mart.staging;

CREATE TABLE IF NOT EXISTS job_mart.staging.prefered_roles (
    role_id int PRIMARY KEY,
    role_name varchar
);

--2. Insert first values into new table

INSERT INTO job_mart.staging.prefered_roles (role_id,role_name)
VALUES
    (1,'Data Engineer'),
    (2,'Senior Data Engineer');

INSERT INTO job_mart.staging.prefered_roles (role_id,role_name)
VALUES
    (3,'Software Engineer');

--3. Adding new column to existing table

ALTER TABLE job_mart.staging.prefered_roles
ADD COLUMN role_preference BOOLEAN;

--4. Updating values in specific column (conditional)

UPDATE job_mart.staging.prefered_roles
SET role_preference = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE job_mart.staging.prefered_roles
SET role_preference = FALSE
WHERE role_id = 3;

--5. Renaming table & column + changing column data type + updating values in specific column (conditional) 

ALTER TABLE job_mart.staging.prefered_roles
RENAME TO priority_roles;

ALTER TABLE job_mart.staging.priority_roles
RENAME COLUMN role_preference TO priority_lvl;

ALTER TABLE job_mart.staging.priority_roles
ALTER COLUMN priority_lvl TYPE int;

UPDATE job_mart.staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;


--6. Select all columns and values from final table to confirm result.
SELECT * FROM job_mart.staging.priority_roles;