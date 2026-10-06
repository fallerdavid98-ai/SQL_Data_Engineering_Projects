ALTER TABLE job_mart.staging.prefered_roles -- change table name
RENAME TO priority_roles;

ALTER TABLE job_mart.staging.priority_roles -- change column name
RENAME COLUMN role_preference TO priority_lvl;


ALTER TABLE job_mart.staging.priority_roles -- change column values
ALTER COLUMN priority_lvl TYPE int;

UPDATE job_mart.staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT * FROM job_mart.staging.priority_roles;