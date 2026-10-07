-- 5b) Updating priority roles (For test purposes. For production hard-coding one-time 
-- updates into process automation is impracticle) --> For idempotency, run 5) before 5b)

SELECT '=== Updating Roles for Priority Mart ==' AS info;

-- Update data engineer priority to 1
SELECT '=== Update(s) of Priority Mart Snapshot ===' AS info;

UPDATE priority_mart.priority_roles
SET priority_lvl=1
WHERE role_name='Data Engineer';

-- Add data scientist at priority 3
INSERT INTO priority_mart.priority_roles (
    role_id,
    role_name,
    priority_lvl
)
VALUES
(4,'Data Scientist',3);