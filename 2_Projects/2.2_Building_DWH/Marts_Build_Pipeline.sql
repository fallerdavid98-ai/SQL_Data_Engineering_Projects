
-- 1) Create star schema tables in DWH
.read 01_Table_Creation_DWH.sql

-- 2) Load data from CSV files into DWH tables
.read 02_Schema_Load_DWH.sql

-- 3) Create flat mart table in seperate schema
.read 03_Flat_Mart_Creation_DWH.sql

-- 4) Create dimensional skills demand mart in seperate schema
.read 04_Skills_Mart_Creation_DWH.sql

-- 5) Create priority roles mart mart in seperate schema
.read 05_Priority_Mart_Creation_DWH.sql

-- 5b) Updating priority roles (if necessary)
.read 05b_Priority_Roles_Updates_DWH.sql

--6) Batch updating priority roles snapshot table
.read 06_Priority_Mart_Update_DWH.sql

-- Final call of Marts_Build_Piipeline script
-- duckdb dw_marts.duckdb -c ".read Marts_Build_Pipeline.sql"
