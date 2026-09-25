ALTER TABLE job_mart.staging.prefered_roles
ADD COLUMN role_preference BOOLEAN;

SELECT * FROM job_mart.staging.prefered_roles;

ALTER TABLE job_mart.staging.prefered_roles
DROP COLUMN role_preference;