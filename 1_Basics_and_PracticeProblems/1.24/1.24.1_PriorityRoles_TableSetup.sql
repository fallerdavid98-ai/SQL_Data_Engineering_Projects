
--Prepare priority_roles tables in schema staging (Initial Load & Update Priority Roles)

CREATE OR REPLACE TABLE job_mart.staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

-- Insert values
INSERT INTO job_mart.staging.priority_roles (role_id,role_name,priority_lvl)
VALUES
(1,'Data Engineer',1),
(2,'Senior Data Engineer',1),
(3,'Software Engineer',3);
--(4,'Data Scientist',3);

SELECT * FROM job_mart.staging.priority_roles;