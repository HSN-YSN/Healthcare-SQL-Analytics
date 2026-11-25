-- =====================================================
-- HEALTHCARE SQL ANALYTICS — PROJECT 1
-- PHASE 4: DATA CLEANING
-- File: 03_data_cleaning.sql
-- =====================================================

-- DATA SOURCE:
-- CMS Hospital General Information
-- CMS Unplanned Hospital Visits by State

-- OBJECTIVE:
-- Prepare reliable datasets for healthcare analysis
-- by addressing identified data quality issues.

-- CLEANING PRINCIPLES:
-- 1. Preserve the original CMS datasets.
-- 2. Standardize inconsistent categorical values.
-- 3. Handle missing and unavailable values appropriately.
-- 4. Investigate duplicates before removing records.
-- 5. Correct errors only when justified.
-- 6. Document every cleaning decision.
-- 7. Validate the cleaned datasets before analysis.

-- =====================================================
-- TASK 1: STANDARDIZE INCONSISTENT CATEGORIES
-- =====================================================
SELECT COUNT(*) FROM "Hospital_General_Information"
WHERE TRIM("Hospital Type") != "Hospital Type";

SELECT COUNT(*) FROM "Hospital_General_Information"
WHERE TRIM("Hospital ownership") != "Hospital ownership";
-- FINDING:
-- Hospital Type: 0 values with leading/trailing spaces.
-- Hospital Ownership: 0 values with leading/trailing spaces.

-- CLEANING DECISION:
-- No category standardization required for the
-- identified formatting checks.
-- Original values preserved.
-- TASK 2: INVESTIGATE AND ADDRESS DUPLICATE RECORDS

-- FINDING:
-- Hospital General Information:
-- 0 duplicate Facility IDs.

-- Unplanned Hospital Visits by State:
-- 0 duplicate State + Measure ID combinations.

-- CLEANING DECISION:
-- No duplicate-key records identified.
-- No records removed.
SELECT
    "State",
    "Measure ID",
    CASE
        WHEN "Number of Hospitals Worse"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Worse" AS INTEGER)
    END AS cleaned_hospitals_worse,
	  CASE
        WHEN "Number of Hospitals Better"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Better" AS INTEGER)
    END AS cleaned_hospitals_better,
	  CASE
        WHEN "Number of Hospitals Same"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Same" AS INTEGER)
    END AS cleaned_hospitals_Same,
	  CASE
        WHEN "Number of Hospitals TOO Few"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals TOO Few" AS INTEGER)
    END AS cleaned_hospitals_too_few
FROM "Unplanned_Hospital_Visits-State";

-- PHASE 4: DATA CLEANING
-- TASK 3: VALIDATE MISSING-VALUE HANDLING

SELECT
    COUNT(*) AS total_records,
    COUNT(cleaned_hospitals_worse) AS valid_values,
    COUNT(*) - COUNT(cleaned_hospitals_worse) AS null_values

FROM (
    SELECT
        "State",
        "Measure ID",

        CASE
            WHEN "Number of Hospitals Worse"
                 IN ('Not Available', 'Not Applicable')
            THEN NULL
            ELSE CAST("Number of Hospitals Worse" AS INTEGER)
        END AS cleaned_hospitals_worse,

        CASE
            WHEN "Number of Hospitals Better"
                 IN ('Not Available', 'Not Applicable')
            THEN NULL
            ELSE CAST("Number of Hospitals Better" AS INTEGER)
        END AS cleaned_hospitals_better,

        CASE
            WHEN "Number of Hospitals Same"
                 IN ('Not Available', 'Not Applicable')
            THEN NULL
            ELSE CAST("Number of Hospitals Same" AS INTEGER)
        END AS cleaned_hospitals_same,

        CASE
            WHEN "Number of Hospitals TOO Few"
                 IN ('Not Available', 'Not Applicable')
            THEN NULL
            ELSE CAST("Number of Hospitals TOO Few" AS INTEGER)
        END AS cleaned_hospitals_too_few

    FROM "Unplanned_Hospital_Visits-State"

) AS cleaned_data;

-- VALIDATION RESULTS:
-- Total records: 784
-- Valid numerical values: 208
-- NULL values: 576
-- The cleaned_hospitals_worse counts match
-- the expected results from Phase 3.
-- Original dataset remains unchanged.
-- =====================================================
-- PHASE 4: DATA CLEANING
-- TASK 3: HANDLE MISSING AND UNAVAILABLE VALUES
-- =====================================================

-- OBJECTIVE:
-- Create a reusable SQL view for state-level hospital
-- performance measures without modifying the original
-- CMS dataset.

-- CLEANING LOGIC:
-- 1. Preserve all original records.
-- 2. Convert 'Not Available' and 'Not Applicable'
--    into SQL NULL for numerical analysis.
-- 3. Convert valid numeric-looking values to integers.
-- 4. Apply cleaning independently to four columns.
-- 5. Preserve original source tables unchanged.


-- =====================================================
-- CREATE CLEANED VIEW
-- =====================================================

CREATE VIEW clean_unplanned_visits_state AS

SELECT
    "State",
    "Measure ID",

    CASE
        WHEN "Number of Hospitals Worse"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Worse" AS INTEGER)
    END AS cleaned_hospitals_worse,

    CASE
        WHEN "Number of Hospitals Better"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Better" AS INTEGER)
    END AS cleaned_hospitals_better,

    CASE
        WHEN "Number of Hospitals Same"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals Same" AS INTEGER)
    END AS cleaned_hospitals_same,

    CASE
        WHEN "Number of Hospitals TOO Few"
             IN ('Not Available', 'Not Applicable')
        THEN NULL
        ELSE CAST("Number of Hospitals TOO Few" AS INTEGER)
    END AS cleaned_hospitals_too_few

FROM "Unplanned_Hospital_Visits-State";


-- =====================================================
-- CLEANING DECISION
-- =====================================================

-- A SQL VIEW was created instead of modifying the
-- original CMS table.

-- Reporting placeholders are represented as SQL NULL
-- in the cleaned numerical columns.

-- The original dataset preserves the distinction
-- between 'Not Available' and 'Not Applicable'.

-- No source records were deleted or updated.

-- STATUS:
-- View creation complete, pending validation.


-- =====================================================
-- VALIDATION 1: VERIFY TOTAL RECORDS
-- =====================================================

SELECT
    COUNT(*) AS total_records
FROM clean_unplanned_visits_state;

-- VALIDATION 1: RECORD COUNT
-- Original dataset: 784 records.
-- Cleaned view: 784 records.
-- RESULT: PASSED.
-- No records were excluded by the view.
-- Individual column transformations still require validation.
SELECT
    COUNT(*) AS total_records,
    COUNT(cleaned_hospitals_worse) AS valid_values,
	COUNT(cleaned_hospitals_same) AS valid_same,
	COUNT(cleaned_hospitals_better) AS valid_better,
	COUNT(cleaned_hospitals_too_few) AS valid_too_few
  FROM "clean_unplanned_visits_state";
  
  SELECT
    "State",
    "Facility ID",
    "Facility Name",
    CASE
        WHEN "Hospital overall rating" = 'Not Available'
        THEN NULL
        ELSE CAST("Hospital overall rating" AS INTEGER)
    END AS cleaned_rating
FROM "Hospital_General_Information";
-- Verify that unavailable hospital ratings are
-- converted to SQL NULL while preserving all hospitals.

-- EXPECTED RESULTS:
-- Total hospitals: 5,435
-- Valid ratings: 3,166
-- NULL ratings: 2,269


-- =====================================================
-- VALIDATION QUERY
-- =====================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(cleaned_rating) AS valid_values,
    COUNT(*) - COUNT(cleaned_rating) AS null_values

FROM (
    SELECT
        "State",
        "Facility ID",
        "Facility Name",

        CASE
            WHEN "Hospital overall rating" = 'Not Available'
            THEN NULL
            ELSE CAST("Hospital overall rating" AS INTEGER)
        END AS cleaned_rating

    FROM "Hospital_General_Information"
) AS cleaned_hospitals;


-- =====================================================
-- VALIDATION NOTES
-- =====================================================

-- COUNT(*) counts all hospital records.
-- COUNT(cleaned_rating) counts non-NULL ratings.
-- The difference represents unavailable ratings.
-- VALIDATION RESULT: PASSED
-- Total hospital records: 5,435
-- Valid numerical ratings: 3,166
-- NULL ratings: 2,269
-- Results match Phase 3 findings.
-- No source records were modified.
CREATE VIEW clean_hospital_ratings AS
SELECT
    *,
    CASE
        WHEN "Hospital overall rating" = 'Not Available'
        THEN NULL
        ELSE CAST("Hospital overall rating" AS INTEGER)
    END AS cleaned_rating
FROM "Hospital_General_Information";

SELECT
    COUNT(*) AS total_records,
    COUNT(cleaned_rating) AS valid_values,
    COUNT(*) - COUNT(cleaned_rating) AS null_values
	FROM "clean_hospital_ratings";
	-- =====================================================
-- VALIDATION: CLEANED HOSPITAL RATINGS
-- =====================================================

-- FINDING:
-- Total hospital records: 5,435
-- Valid numerical ratings: 3,166
-- NULL ratings: 2,269

-- VALIDATION RESULT: PASSED
-- Record counts match the Phase 3 investigation.
-- All hospital records were preserved.
-- Final numerical value validation remains pending.
SELECT COUNT("cleaned_rating") FROM "clean_hospital_ratings"
WHERE cleaned_rating NOT BETWEEN 1 AND 5 ;

-- =====================================================
-- PHASE 4: VERIFY ORIGINAL VS CLEANED RATINGS
-- =====================================================

SELECT
    "Facility ID",
    "Facility Name",
    "Hospital overall rating" AS original_rating,
    cleaned_rating
FROM clean_hospital_ratings
WHERE "Hospital overall rating" = 'Not Available'
LIMIT 10;
-- =====================================================
-- VALIDATION: ORIGINAL VS CLEANED HOSPITAL RATINGS
-- =====================================================

-- FINDING:
-- Original 'Not Available' ratings remain unchanged.
-- Corresponding cleaned_rating values are SQL NULL.
-- Sample validation returned the expected results.
-- Total hospitals preserved: 5,435.
-- Invalid numerical ratings outside 1-5: 0.

-- CLEANING DECISION:
-- Preserve original CMS values.
-- Use cleaned_rating for numerical analysis.
-- No UPDATE or DELETE operations required.
SELECT
    "Facility ID",
    CAST("Hospital overall rating" AS INTEGER) AS original_rating,
    cleaned_rating
FROM "clean_hospital_ratings"
WHERE "Hospital overall rating" != 'Not Available'
AND (CAST("Hospital overall rating" AS INTEGER) != cleaned_rating
    OR cleaned_rating IS NULL);
	-- =====================================================
-- FINAL VALIDATION: HOSPITAL RATINGS
-- =====================================================

-- FINDING:
-- 0 mismatches between original available ratings
-- and their cleaned numerical equivalents.

-- VALIDATION RESULT: PASSED.
-- All 5,435 hospital records were preserved.
-- No incorrect rating conversions were identified.
SELECT
UN."State",UN."Measure ID",UN."Number of Hospitals Worse", CH."cleaned_hospitals_worse" 
FROM "Unplanned_Hospital_Visits-State" AS UN
JOIN "clean_unplanned_visits_state" AS CH
ON UN."State"=CH."State"
AND UN."Measure ID" =CH."Measure ID"
WHERE UN."Number of Hospitals Worse" NOT IN  ('Not Available','Not Applicable')
AND (
    CAST(UN."Number of Hospitals Worse" AS INTEGER) != CH."cleaned_hospitals_worse"
    OR CH."cleaned_hospitals_worse" IS NULL
);
-- VALIDATION: NUMBER OF HOSPITALS WORSE
-- Original numeric values compared with cleaned values.
-- Numeric conversion mismatches: 0
-- RESULT: PASSED.
SELECT
UN."State",UN."Measure ID",UN."Number of Hospitals Better", CH."cleaned_hospitals_better" 
FROM "Unplanned_Hospital_Visits-State" AS UN
JOIN "clean_unplanned_visits_state" AS CH
ON UN."State"=CH."State"
AND UN."Measure ID" =CH."Measure ID"
WHERE UN."Number of Hospitals better" NOT IN  ('Not Available','Not Applicable')
AND (
    CAST(UN."Number of Hospitals better" AS INTEGER) != "cleaned_hospitals_better"
    OR "cleaned_hospitals_better" IS NULL
);
-- =====================================================
-- VALIDATION: NUMBER OF HOSPITALS SAME
-- =====================================================

SELECT
    U."State",
    U."Measure ID",
    U."Number of Hospitals Same",
    C.cleaned_hospitals_same
FROM "Unplanned_Hospital_Visits-State" AS U
JOIN clean_unplanned_visits_state AS C
    ON U."State" = C."State"
    AND U."Measure ID" = C."Measure ID"
WHERE U."Number of Hospitals Same"
    NOT IN ('Not Available', 'Not Applicable')
AND (
    CAST(U."Number of Hospitals Same" AS INTEGER)
        != C.cleaned_hospitals_same
    OR C.cleaned_hospitals_same IS NULL
);


-- =====================================================
-- VALIDATION: NUMBER OF HOSPITALS TOO FEW
-- =====================================================

SELECT
    U."State",
    U."Measure ID",
    U."Number of Hospitals TOO Few",
    C.cleaned_hospitals_too_few
FROM "Unplanned_Hospital_Visits-State" AS U
JOIN clean_unplanned_visits_state AS C
    ON U."State" = C."State"
    AND U."Measure ID" = C."Measure ID"
WHERE U."Number of Hospitals TOO Few"
    NOT IN ('Not Available', 'Not Applicable')
AND (
    CAST(U."Number of Hospitals TOO Few" AS INTEGER)
        != C.cleaned_hospitals_too_few
    OR C.cleaned_hospitals_too_few IS NULL
);