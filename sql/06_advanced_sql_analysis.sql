-- =====================================================
-- HEALTHCARE SQL ANALYTICS — PROJECT 1
-- PHASE 7: ADVANCED SQL ANALYSIS
-- File: 06_advanced_sql_analysis.sql
-- =====================================================

-- OBJECTIVE:
-- Apply advanced SQL techniques to analyze
-- hospital information and state-level
-- healthcare performance measures.

-- DATA SOURCES:
-- clean_hospital_ratings
-- clean_unplanned_visits_state

-- IMPORTANT:
-- Hospital data and state-level measure data
-- have different levels of granularity.

-- Joining them incorrectly can inflate results.

-- =====================================================
-- TASK 1: PRACTICE INNER JOIN
-- =====================================================
SELECT CR."Facility ID",CR."Facility Name",CR."State",CS."Measure ID",CS."cleaned_hospitals_worse" 
FROM "clean_hospital_ratings" AS CR
JOIN "clean_unplanned_visits_state" AS CS
ON CR."State"=CS."State" AND CS."Measure ID" = 'OP_35_ADM'
ORDER BY CS."cleaned_hospitals_worse" DESC
LIMIT 10;
-- =====================================================
-- PHASE 7 - TASK 1: INNER JOIN
-- =====================================================

-- BUSINESS QUESTION:
-- How can individual hospital records be joined
-- with state-level OP_35_ADM information?

-- IMPORTANT:
-- This query displays 10 example hospital records.
-- State-level values may be NULL.
-- The results do not identify individual hospitals
-- classified as performing worse.

-- SQL LOGIC:
-- Joined hospital records with state-level measures
-- using the State column.
-- Filtered to OP_35_ADM.
-- Sorted by cleaned_hospitals_worse DESC.
-- Limited output to 10 rows.

-- KEY FINDINGS:
-- California reports 9 hospitals classified as worse
-- for OP_35_ADM.
-- The value 9 appears beside multiple California
-- hospitals because it is a state-level value.

-- IMPORTANT:
-- The JOIN does not identify which individual
-- California hospitals were classified as worse.

-- LIMITATION:
-- Hospital-level and state-level data have
-- different levels of granularity.
-- Repeated state-level values must not be summed
-- across hospital rows.

-- TASK 1: COMPLETED.
SELECT COUNT(*) AS "total_hospitals",
 CASE
       WHEN "cleaned_rating" BETWEEN 1 AND 2 THEN 'Low Rating'
	   WHEN "cleaned_rating"  =   3       THEN     'Moderate Rating'
	   WHEN "cleaned_rating"BETWEEN 4 AND 5 THEN 'High Rating'
	   ELSE 'Rating Unavailable'
	   END AS "rating_category" FROM "clean_hospital_ratings"
	   GROUP BY "rating_category";
-- =====================================================
-- PHASE 7 - TASK 2: CASE WHEN
-- =====================================================

-- BUSINESS QUESTION:
-- How many hospitals belong to each rating category?

-- SQL LOGIC:
-- Used CASE WHEN to classify hospitals based
-- on their cleaned CMS overall star ratings.
-- GROUP BY calculated the number of hospitals
-- within each category.

-- KEY FINDINGS:
-- High Rating (4-5 stars): 1,328 hospitals.
-- Moderate Rating (3 stars): 981 hospitals.
-- Low Rating (1-2 stars): 857 hospitals.
-- Rating Unavailable: 2,269 hospitals.

-- Total hospitals: 5,435.
-- All categories were validated against
-- the original rating distribution.

-- HEALTHCARE INTERPRETATION:
-- High-rated hospitals outnumber low-rated hospitals
-- among facilities with available ratings.

-- LIMITATIONS:
-- Rating categories are defined for this project,
-- not official CMS performance classifications.
-- Unavailable ratings must not be interpreted
-- as indicators of poor healthcare performance.

-- TASK 2: COMPLETED.
SELECT "State","Measure ID","cleaned_hospitals_worse",
       COALESCE("cleaned_hospitals_worse", 'Unavailable')
    AS "display_hospitals_worse"
	   FROM "clean_unplanned_visits_state"
	   LIMIT 15;
-- =====================================================
-- PHASE 7 - TASK 3: COALESCE
-- =====================================================

-- BUSINESS QUESTION:
-- How can missing state-level performance counts
-- be displayed without changing the underlying data?

-- SQL LOGIC:
-- Used COALESCE(cleaned_hospitals_worse, 'Unavailable')
-- to display text when the original value is NULL.

-- KEY FINDINGS:
-- NULL values were displayed as 'Unavailable'.
-- Valid numerical values, including 0 and 2,
-- remained unchanged.

-- INTERPRETATION:
-- COALESCE improves readability when presenting
-- missing healthcare performance data.

-- LIMITATIONS:
-- COALESCE does not distinguish between the original
-- 'Not Available' and 'Not Applicable' placeholders
-- because both were converted to NULL during cleaning.

-- The display column may contain text and numbers,
-- so calculations should use the cleaned numeric column.

-- TASK 3: COMPLETED.
SELECT CR."Facility ID",CR."Facility Name",CR."State",CS."Measure ID",CS."cleaned_hospitals_worse" 
FROM "clean_hospital_ratings" AS CR
LEFT JOIN "clean_unplanned_visits_state" AS CS
ON CR."State"=CS."State" 
AND "Measure ID"= 'OP_35_ADM' 
AND "cleaned_hospitals_worse" IS NOT NULL
LIMIT 15;
-- =====================================================
-- PHASE 7 - TASK 4: LEFT JOIN
-- =====================================================

-- BUSINESS QUESTION:
-- Which hospitals are located in states with
-- available or unavailable OP_35_ADM measure data?

-- SQL LOGIC:
-- Used LEFT JOIN to preserve all hospital records.
-- Matched hospitals to state-level data using State.
-- Applied Measure ID = 'OP_35_ADM' inside ON.
-- Required cleaned_hospitals_worse IS NOT NULL
-- for a successful match.

-- KEY FINDINGS:
-- Hospitals with available state-level data
-- display the corresponding measure information.

-- Hospitals without available matching data
-- are preserved with NULL right-table columns.

-- A reported value of 0 is valid and must
-- not be confused with missing data.

-- IMPORTANT:
-- State-level counts are repeated for hospitals
-- located in the same state.

-- These repeated values do not represent
-- individual hospital performance.

-- LIMITATION:
-- Joining hospital-level records with state-level
-- measures requires careful interpretation.

-- TASK 4: COMPLETED.
SELECT
    CR."State",
    COUNT(*) AS total_hospitals,
    COUNT(CR."cleaned_rating") AS rated_hospitals,
    MAX(CS."cleaned_hospitals_worse")
        AS hospitals_worse_OP35_ADM
FROM "clean_hospital_ratings" AS CR
INNER JOIN "clean_unplanned_visits_state" AS CS
    ON CR."State" = CS."State"
    AND CS."Measure ID" = 'OP_35_ADM'
GROUP BY CR."State"
ORDER BY total_hospitals DESC, CR."State" ASC
LIMIT 10;
-- =====================================================
-- PHASE 7 - TASK 5: COMBINING MULTIPLE TABLES
-- =====================================================

-- BUSINESS QUESTION:
-- Which states have the highest hospital counts,
-- and what are their corresponding OP_35_ADM
-- state-level worse-classification counts?

-- SQL LOGIC:
-- 1. Joined both cleaned views using State.
-- 2. Filtered the JOIN to OP_35_ADM.
-- 3. Grouped hospital records by state.
-- 4. Used COUNT(*) for total hospital records.
-- 5. Used COUNT(cleaned_rating) for rated hospitals.
-- 6. Used MAX(cleaned_hospitals_worse) to preserve
--    the state-level value without repeated summation.
-- 7. Returned the 10 states with the most hospitals.

-- KEY FINDINGS:
-- Texas:
-- 470 hospitals, 217 rated, OP_35_ADM worse count: 1.

-- California:
-- 378 hospitals, 279 rated, OP_35_ADM worse count: 9.

-- Florida:
-- 223 hospitals, 168 rated, OP_35_ADM worse count: 3.

-- New York:
-- 193 hospitals, 136 rated, OP_35_ADM worse count: 8.

-- Illinois:
-- 193 hospitals, 135 rated, OP_35_ADM worse count: 7.

-- HEALTHCARE INTERPRETATION:
-- Hospital counts and measure-specific worse
-- classifications vary across states.

-- A higher count does not automatically indicate
-- worse statewide healthcare performance.

-- IMPORTANT LIMITATIONS:
-- Hospital records and state-level measures
-- have different levels of granularity.

-- State-level counts do not identify individual
-- hospitals classified as worse.

-- MAX() is valid here because each state has
-- one record for the selected measure.

-- The total hospital count is not necessarily
-- the eligible denominator for OP_35_ADM.

-- TASK 5: COMPLETED. 
SELECT
    COUNT(*) AS total_joined_rows,
    COUNT(DISTINCT(CR."Facility ID")) AS unique_hospitals,
    COUNT(*) - COUNT(DISTINCT CR."Facility ID")
    AS duplicate_rows
FROM "clean_hospital_ratings" AS CR
INNER JOIN "clean_unplanned_visits_state" AS CS
    ON CR."State" = CS."State"
	AND CS."Measure ID" = 'OP_35_ADM';
-- =====================================================
-- PHASE 7 - TASK 6: JOIN VALIDATION
-- =====================================================

-- BUSINESS QUESTION:
-- Does joining hospital records with OP_35_ADM
-- state-level data create duplicate hospital records?

-- SQL LOGIC:
-- 1. Joined hospital and state-level datasets by State.
-- 2. Restricted the JOIN to OP_35_ADM.
-- 3. Used COUNT(*) to count joined rows.
-- 4. Used COUNT(DISTINCT Facility ID) to count
--    unique hospitals.
-- 5. Subtracted unique hospitals from joined rows
--    to identify excess records.

-- KEY FINDINGS:
-- Total joined rows: 5,435.
-- Unique hospitals: 5,435.
-- Duplicate rows: 0.

-- VALIDATION:
-- The JOIN preserved all 5,435 hospitals
-- without introducing duplicate hospital records.

-- ANALYTICAL INTERPRETATION:
-- Filtering the JOIN to a single measure prevented
-- hospitals from matching multiple measure records.

-- LIMITATIONS:
-- This validation applies to the OP_35_ADM JOIN.
-- Other JOINs must be validated independently.

-- A JOIN may still produce misleading interpretations
-- when combining hospital-level and state-level data,
-- even when no duplicate hospital IDs are present.

-- TASK 6: COMPLETED.
WITH MY_CTE AS (
    SELECT
        State,
        COUNT(*) AS total_hospitals,
        COUNT("cleaned_rating") AS rated_hospitals
    FROM "clean_hospital_ratings"
    GROUP BY "State"
                   )
	SELECT "State","total_hospitals","rated_hospitals",
            ROUND((100.0 *"rated_hospitals"/"total_hospitals"),2) AS "rating_availability_percentage"	
			FROM MY_CTE
			WHERE "rated_hospitals" >=30
		ORDER BY "rating_availability_percentage" DESC
		LIMIT 10;
-- =====================================================
-- PHASE 7 - TASK 7: COMMON TABLE EXPRESSIONS
-- =====================================================

-- BUSINESS QUESTION:
-- Which 10 states have the highest hospital rating
-- availability among states with at least
-- 30 rated hospitals?

-- SQL LOGIC:
-- 1. Created a CTE using WITH.
-- 2. Grouped hospitals by State inside the CTE.
-- 3. Calculated total and rated hospitals.
-- 4. Used the CTE results to calculate rating
--    availability percentages.
-- 5. Filtered states with >= 30 rated hospitals.
-- 6. Sorted by rating availability DESC.
-- 7. Returned the top 10 states.

-- KEY FINDINGS:
-- Virginia: 76/98 hospitals rated (77.55%).
-- New Jersey: 61/79 rated (77.22%).
-- Florida: 168/223 rated (75.34%).
-- Maryland: 42/56 rated (75.00%).
-- North Carolina: 90/121 rated (74.38%).

-- Overall dataset rating availability: 58.25%.

-- HEALTHCARE INTERPRETATION:
-- Virginia had the highest observed rating
-- availability among states meeting the threshold.

-- Rating availability describes data coverage,
-- not hospital quality.

-- LIMITATIONS:
-- States differ in hospital counts and types.
-- Missing ratings may reflect CMS eligibility
-- and reporting requirements.
-- The 30-hospital threshold is exploratory.

-- SQL LEARNING:
-- A CTE allows calculations to be organized
-- into separate, readable stages.

-- TASK 7: COMPLETED.
SELECT "Facility ID", "Facility Name","State","cleaned_rating"
	FROM "clean_hospital_ratings" AS CR
WHERE "cleaned_rating">(
SELECT AVG("cleaned_rating") FROM "clean_hospital_ratings" AS CR2
WHERE CR2."State" = CR."State") 
AND "cleaned_rating" IS NOT NULL
ORDER BY "cleaned_rating" DESC
LIMIT 10;
-- =====================================================
-- PHASE 7 - TASK 8: CORRELATED SUBQUERIES
-- =====================================================

-- BUSINESS QUESTION:
-- Which hospitals have CMS overall star ratings
-- higher than the average rating in their own state?

-- SQL LOGIC:
-- 1. Used a correlated subquery with AVG().
-- 2. Connected the inner query to the outer query
--    using the State column.
-- 3. Compared each hospital's rating against
--    the average rating of its own state.
-- 4. Excluded hospitals with unavailable ratings.
-- 5. Sorted results by hospital rating.

-- KEY FINDINGS:
-- The first 10 results were hospitals rated 5 stars.
-- These hospitals exceeded their respective
-- state average ratings.

-- IMPORTANT SQL LESSON:
-- A non-correlated subquery may compare hospitals
-- against an unrelated state average.
-- A correlated subquery calculates the appropriate
-- state average for each hospital.

-- Both approaches initially returned the same
-- top 10 hospitals, but their logic was different.

-- LIMITATIONS:
-- Hospital ratings do not directly measure
-- individual clinical outcomes.
-- State averages exclude hospitals without ratings.
-- Higher-than-average ratings do not establish
-- superior clinical performance in every dimension.

-- TASK 8: COMPLETED.