
-- 1) Create star schema tables in DWH
.read 01_Table_Creation_DWH.sql

-- 2) Load data from CSV files into DWH tables
.read 02_Schema_Load_DWH.sql

--3) xxx


-- Final call of Marts_Build_Piipeline script
-- duckdb dw_marts.duckdb -c ".read Marts_Build_Pipeline.sql"
