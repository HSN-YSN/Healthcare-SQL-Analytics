SELECT name
FROM sqlite_master
WHERE type = 'table';

--Examine the structure of the hospital information TABLE
PRAGMA 
table_info('Hospital_General_Information');

-- Examine the structure of the unplanned hospital visits table
PRAGMA table_info('Unplanned_Hospital_Visits-State');

-- Preview the first 10 records
SELECT *
FROM "Unplanned_Hospital_Visits-State"
LIMIT 10;

-- Count total records
SELECT COUNT(*) AS total_records
FROM "Unplanned_Hospital_Visits-State";

-- Count geographic identifiers and healthcare measures
SELECT
    COUNT(DISTINCT "State") AS total_states,
    COUNT(DISTINCT "Measure Name") AS total_measures
FROM "Unplanned_Hospital_Visits-State";