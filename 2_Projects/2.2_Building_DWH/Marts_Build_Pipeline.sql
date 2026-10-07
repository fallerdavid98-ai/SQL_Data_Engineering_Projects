
-- 1) Create star schema tables in DWH
.read 01_Table_Creation_DWH.sql

-- 2) Load data from CSV files into DWH tables
.read 02_Schema_Load_DWH.sql

-- 3) Create flat mart table in seperate schema
.read 03_Flat_Mart_Creation_DWH.sql

-- Final call of Marts_Build_Piipeline script
-- duckdb dw_marts.duckdb -c ".read Marts_Build_Pipeline.sql"
