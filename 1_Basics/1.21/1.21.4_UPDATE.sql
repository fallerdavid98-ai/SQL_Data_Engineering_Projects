UPDATE job_mart.staging.prefered_roles
SET role_preference = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE job_mart.staging.prefered_roles
SET role_preference = FALSE
WHERE role_id = 3;

SELECT * FROM job_mart.staging.prefered_roles;