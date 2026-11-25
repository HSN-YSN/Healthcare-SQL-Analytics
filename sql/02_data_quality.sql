-- PROJECT 1: CMS Hospital Quality Analysis
-- mission 2: Data Quality Assessment
-- Objective: Investigate missing values, duplicates,
-- and inconsistent data before analysis.
--CHECK for missing state VALUES (sql NULL)
SELECT COUNT (*) AS Missing_state FROM "Unplanned_Hospital_Visits-State" 
WHERE "State" IS NULL;
--check for empty VALUES
SELECT COUNT(*) AS empty_spaces FROM "Unplanned_Hospital_Visits-State"
WHERE "State" = ('');
--check for blank State
SELECT COUNT(*) AS blank_state FROM "Unplanned_Hospital_Visits-State"
WHERE TRIM("State") ='';
-- Identify unique geographic codes in the dataset
SELECT DISTINCT "State" FROM "Unplanned_Hospital_Visits-State";
-- Check for duplicate State and Measure ID combinations
SELECT "State","Measure ID" ,COUNT(*) AS duplicate_count FROM "Unplanned_Hospital_Visits-State" 
GROUP BY "State","Measure ID"
HAVING COUNT(*) > 1;
-- FINDING: 0 duplicate State + Measure ID combinations found.
-- Each observed State + Measure ID combination is unique.
SELECT
    "State",
    COUNT(DISTINCT "Measure ID") AS total_measures
FROM "Unplanned_Hospital_Visits-State"
GROUP BY "State"
HAVING COUNT(DISTINCT "Measure ID") < 14;
-- FINDING: No geographic areas have fewer than 14 distinct measures.
-- Measure records appear complete across all 56 geographic codes.
-- Investigate distinct values in Number of Hospitals Worse
SELECT DISTINCT "Number of Hospitals Worse" FROM "Unplanned_Hospital_Visits-State";
-- FINDING: Column contains numeric-looking values (0-9),
-- plus Not Available and Not Applicable.
-- Further investigation is required before cleaning.
SELECT "Number of Hospitals Worse",COUNT(*)FROM "Unplanned_Hospital_Visits-State"
GROUP BY "Number of Hospitals Worse"
ORDER BY COUNT(*) DESC;
-- FINDING: Number of Hospitals Worse
-- Not Available: 408 records (52.04%)
-- Not Applicable: 168 records (21.43%)
-- Numeric-looking values: 208 records (26.53%)
-- Total records: 784
-- Further investigation required before cleaning.
-- Investigate Not Available values by healthcare measure
SELECT "Measure Name" , COUNT(*) FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Available'
GROUP BY "Measure Name"
ORDER BY COUNT(*) DESC;
-- FINDING: 408 records contain Not Available.
-- Seven measures have 56 unavailable records each.
-- Four additional measures have 4 unavailable records each.
-- CMS documentation must be checked before cleaning.
-- Investigate whether unavailable values occur in both columns
SELECT "Measure Name","Number of Hospitals Worse","Number of Hospitals Better" FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Available'
LIMIT 10;
-- FINDING: All 10 sampled records have Not Available
-- in both Number of Hospitals Worse and Better.
-- Full dataset verification is still required.
SELECT "Number of Hospitals Worse","Number of Hospitals Better",COUNT(*) FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Available' AND "Number of Hospitals Better"= 'Not Available';
-- FINDING: All 408 records with Not Available
-- in Number of Hospitals Worse also have Not Available
-- in Number of Hospitals Better.
-- No data was modified.
SELECT COUNT(*),"Number of Hospitals Worse","Number of Hospitals Same" 
FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Available'
 AND "Number of Hospitals Same"= 'Not Available';
 -- FINDING: All 408 records with Not Available
-- in Number of Hospitals Worse also have Not Available
-- in Number of Hospitals Same.
-- Previous check confirmed the same for Hospitals Better.
-- No original data was modified.
SELECT "Measure ID",COUNT(*) FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Available'
GROUP BY "Measure ID"
ORDER BY COUNT(*);
-- FINDING: 408 Not Available records across 11 measures.
-- Seven measures have 56 unavailable records each.
-- Four measures have 4 unavailable records each.
-- The reason for these values requires CMS documentation.
SELECT "Measure ID",COUNT(*) FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" = 'Not Applicable'
GROUP BY "Measure ID"
ORDER BY COUNT(*)DESC;
-- FINDING: 168 Not Applicable records.
-- EDAC_30_PN: 56 records
-- EDAC_30_HF: 56 records
-- EDAC_30_AMI: 56 records
-- All 56 geographic areas are affected for these measures.
-- CMS documentation must be reviewed before cleaning.
SELECT "Number of Hospitals Same",COUNT(*) 
FROM "Unplanned_Hospital_Visits-State"
GROUP BY "Number of Hospitals Same"
ORDER BY COUNT(*) DESC ;
-- FINDING: Number of Hospitals Same
-- Not Available: 408 records
-- Not Applicable: 168 records
-- Numeric-looking values: 208 records
-- Numeric counts differ from Number of Hospitals Worse.
SELECT "Number of Hospitals Worse","Number of Hospitals Same","Number of Hospitals Better",COUNT(*) 
FROM "Unplanned_Hospital_Visits-State"
GROUP BY "Number of Hospitals Worse","Number of Hospitals Same","Number of Hospitals Better"
ORDER BY COUNT(*) DESC;
-- FINDING: Reporting categories are consistent across
-- Number of Hospitals Worse, Same, and Better.
-- 408 records contain Not Available in all three columns.
-- 168 records contain Not Applicable in all three columns.
-- Remaining 208 records require further investigation
SELECT COUNT(*) AS numeric_records
FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse"
NOT IN ('Not Available', 'Not Applicable');
-- FINDING: 208 records contain values other than
-- Not Available and Not Applicable
-- in Number of Hospitals Worse.
-- Numeric validity still requires verification.
-- Check for missing Facility IDs
SELECT
    COUNT(*) AS missing_facility_ids
FROM "Hospital_General_Information"
WHERE "Facility ID" IS NULL;
--NO NULL FOR Facility ID 
--Check for IDS dupliacte
SELECT COUNT("Facility ID") AS duplicate_IDs,"Facility ID" FROM "Hospital_General_Information"
GROUP BY "Facility ID"
HAVING COUNT("Facility ID") >= 2
ORDER BY COUNT("Facility ID") DESC;
--FINDING: No IDs duplicate
SELECT COUNT("Hospital overall rating"),"Hospital overall rating" 
FROM "Hospital_General_Information"
GROUP by "Hospital overall rating"
ORDER BY COUNT("Hospital overall rating") DESC;

SELECT "Hospital overall rating" FROM "Hospital_General_Information"
WHERE TRIM("Hospital overall rating") = ''
 OR "Hospital overall rating" IS NULL;
 -- FINDING: 2,269 hospitals (41.75%) have ratings marked
-- 'Not Available'. No NULL, empty, or spaces-only ratings found.
SELECT "Hospital Type",COUNT("Hospital Type") FROM "Hospital_General_Information"
GROUP BY "Hospital Type"
ORDER BY COUNT("Hospital Type") DESC;

SELECT "Hospital Type" FROM "Hospital_General_Information"
WHERE TRIM("Hospital Type") = ''
 OR "Hospital Type" IS NULL;
 -- FINDING: 9 hospital types identified across 5,435 hospitals.
-- No NULL, empty, or spaces-only Hospital Type values found.
SELECT "State" FROM "Hospital_General_Information"
WHERE TRIM("State") = ''
 OR "State" IS NULL;
 -- FINDING: No NULL, empty, or spaces-only State values found.
 SELECT COUNT("State"),"State" FROM "Hospital_General_Information"
 GROUP BY "State"
 ORDER BY COUNT("State") DESC; 
 -- FINDING: 56 distinct geographic codes identified.
-- All correspond to recognized US states, DC, or territories.
-- No missing or blank State values detected.
SELECT "State" FROM "Hospital_General_Information"
WHERE "State" NOT LIKE '__';
-- FINDING: 56 distinct geographic codes identified.
-- All correspond to recognized US states, DC, or territories.
-- No missing or blank State values detected.
SELECT "Facility Name" FROM "Hospital_General_Information"
WHERE TRIM("Facility Name") = ''
 OR "Facility Name" IS NULL;
 -- FINDING: No NULL, empty, or spaces-only Facility Name values found.
  SELECT COUNT("Facility Name"),"Facility Name" FROM "Hospital_General_Information"
 GROUP BY "Facility Name"
 HAVING COUNT("Facility Name")>=2
 ORDER BY COUNT("Facility Name") DESC; 
 
 SELECT "Facility ID","State" FROM "Hospital_General_Information"
 WHERE "Facility Name"='MEMORIAL HOSPITAL';
 -- FINDING: 13 records share the name MEMORIAL HOSPITAL.
-- They have distinct Facility IDs across 7 states.
-- Hospital names are not reliable unique identifiers.
-- No duplicate Facility IDs were detected.
SELECT "Hospital Ownership",COUNT("Hospital Ownership")
FROM "Hospital_General_Information"
GROUP BY "Hospital Ownership"
ORDER BY COUNT("Hospital Ownership") DESC;

SELECT "Hospital Ownership" FROM "Hospital_General_Information"
WHERE TRIM("Hospital Ownership") = ''
 OR "Hospital Ownership" IS NULL;
-- FINDING: 12 hospital ownership categories identified.
-- No NULL, empty, or spaces-only ownership values found.
SELECT
    "Hospital Type",

    COUNT(*) AS total_hospitals,

    SUM(
        CASE
            WHEN "Hospital overall rating" = 'Not Available'
            THEN 1
            ELSE 0
        END
    ) AS unavailable_ratings,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Hospital overall rating" = 'Not Available'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS unavailable_percentage

FROM "Hospital_General_Information"

GROUP BY "Hospital Type"

ORDER BY unavailable_percentage DESC;
-- FINDING: 2,269 of 5,435 hospitals (41.75%) have
-- an overall rating marked 'Not Available'.
-- Six hospital types have 100% unavailable ratings.
-- Critical Access Hospitals: 71.14% unavailable.
-- Acute Care Hospitals: 14.22% unavailable.
-- These values require interpretation using CMS
-- rating eligibility and reporting methodology.
SELECT "State" FROM "Hospital_General_Information" AS HI
WHERE NOT EXISTS ( 
SELECT 1 FROM "Unplanned_Hospital_Visits-State" AS UH
 WHERE HI."State"=UH."State");
 -- FINDING: No unmatched state codes were found
-- in Hospital_General_Information when compared
-- against Unplanned_Hospital_Visits-State.
SELECT "State" FROM "Unplanned_Hospital_Visits-State" AS UH
WHERE NOT EXISTS ( 
SELECT 1 FROM "Hospital_General_Information" AS HI
 WHERE UH."State"=HI."State");
-- FINDING: All state codes match between
-- both datasets in both directions.
-- No unmatched states were identified.

-- PHASE 3: DATA QUALITY INVESTIGATION
-- TASK: Check minimum and maximum numerical values
SELECT MIN(CAST("Number of Hospitals Worse" AS INTEGER)) AS minimum_hospitals_worse,
MAX(CAST("Number of Hospitals Worse"AS INTEGER)) AS maximum_hospitals_worse
 FROM "Unplanned_Hospital_Visits-State"
 WHERE "Number of Hospitals Worse" NOT IN ('Not Available','Not Applicable') ;
 --INVASTIAGTING IF ZERO IS REAL VALUE
 SELECT "Number of Hospitals Worse",
 CAST("Number of Hospitals Worse" AS INTEGER) FROM "Unplanned_Hospital_Visits-State"
 WHERE "Number of Hospitals Worse" NOT IN ('Not Available','Not Applicable') 
 AND CAST("Number of Hospitals Worse" AS INTEGER) = 0;
 --comparing it no 0s not matching
 SELECT COUNT(*) FROM "Hospital_General_Information"
WHERE TRIM("Facility Name") != "Facility Name";
--No leading or trailing whitespace was detected in the Facility Name column.
--CHeck whether the Number of Hospitals worse exceed number of total Hospital in each State
SELECT
    V."State",
    V."Measure ID",
    V."Measure Name",
    H.total_Hospitals,
    CAST(V."Number of Hospitals Worse" AS INTEGER) AS hospitals_worse

FROM (
    SELECT
        "State",
        COUNT(*) AS total_Hospitals
    FROM "Hospital_General_Information"
    GROUP BY "State"
) AS H

JOIN "Unplanned_Hospital_Visits-State" AS V
    ON H."State" = V."State"

WHERE V."Number of Hospitals Worse"
    NOT IN ('Not Available', 'Not Applicable')

AND CAST(V."Number of Hospitals Worse" AS INTEGER) > H.total_Hospitals;
-- FINDING: No records were found where the number
-- of hospitals performing worse exceeded the
-- total hospitals recorded for the same state.
-- Result: 0 flagged records.
-- LIMITATION: CMS datasets may have different
-- reporting populations and eligibility criteria.
-- =====================================================
-- VALIDATION: CHECK UNEXPECTED NUMERICAL VALUES
-- =====================================================

-- Identify values that are neither known placeholders
-- nor valid nonnegative integer strings.

SELECT
    "State",
    "Measure ID",
    "Number of Hospitals Worse"
FROM "Unplanned_Hospital_Visits-State"
WHERE "Number of Hospitals Worse" IS NULL
   OR TRIM("Number of Hospitals Worse") = ''
   OR (
       "Number of Hospitals Worse"
           NOT IN ('Not Available', 'Not Applicable')
       AND TRIM("Number of Hospitals Worse") GLOB '*[^0-9]*'
   );