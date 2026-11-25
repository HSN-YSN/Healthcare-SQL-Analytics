-- =====================================================
-- HEALTHCARE SQL ANALYTICS — PROJECT 1
-- PHASE 6: HOSPITAL PERFORMANCE ANALYSIS
-- File: 05_hospital_performance.sql
-- =====================================================

-- OBJECTIVE:
-- Investigate differences in CMS overall star ratings
-- across hospital types, ownership groups, and states.

-- DATA SOURCE:
-- clean_hospital_ratings

-- IMPORTANT LIMITATIONS:
-- 1. Only hospitals with available ratings can be
--    included in rating-based calculations.
-- 2. Hospital ratings are not patient-level outcomes.
-- 3. Differences in rating availability must be considered.

-- =====================================================
-- TASK 1: LOW-RATED HOSPITALS BY HOSPITAL TYPE
-- =====================================================

-- BUSINESS QUESTION:
-- Which hospital types have the highest percentage
-- of hospitals receiving 1 or 2 overall stars
SELECT "Hospital Type",
COUNT("cleaned_rating") AS "rated_hospitals",
SUM(
    CASE
        WHEN cleaned_rating IN (1, 2)
        THEN 1
        ELSE 0
    END
) AS low_rated_hospitals,
ROUND(
    100.0 * SUM(
        CASE
            WHEN cleaned_rating IN (1, 2)
            THEN 1
            ELSE 0
        END
    ) / NULLIF(COUNT(cleaned_rating), 0),
    2
) AS low_rating_percentage
FROM "clean_hospital_ratings"
WHERE "cleaned_rating" IS NOT NULL
GROUP BY "Hospital Type"
ORDER BY low_rating_percentage DESC;
-- =====================================================
-- PHASE 6: HOSPITAL PERFORMANCE ANALYSIS
-- TASK 1: LOW-RATED HOSPITALS BY TYPE
-- =====================================================

-- BUSINESS QUESTION:
-- Which hospital types have the highest percentage
-- of hospitals receiving 1 or 2 CMS overall stars?

-- SQL LOGIC:
-- 1. Excluded unavailable ratings using IS NOT NULL.
-- 2. Counted rated hospitals within each hospital type.
-- 3. Used SUM(CASE WHEN) to count 1- and 2-star hospitals.
-- 4. Calculated low-rated percentage using the number
--    of rated hospitals as the denominator.

-- =====================================================
-- KEY FINDINGS
-- =====================================================

-- Total rated hospitals: 3,166.
-- Total low-rated hospitals (1 or 2 stars): 857.

-- Acute Care Hospitals:
-- 2,654 rated hospitals.
-- 745 low-rated hospitals (28.07%).

-- Critical Access Hospitals:
-- 400 rated hospitals.
-- 105 low-rated hospitals (26.25%).

-- Acute Care - Veterans Administration:
-- 112 rated hospitals.
-- 7 low-rated hospitals (6.25%).

-- Six other hospital types had no available ratings
-- and were excluded from the comparison.

-- =====================================================
-- HEALTHCARE INTERPRETATION
-- =====================================================

-- Acute Care Hospitals had the highest observed
-- percentage of low-rated hospitals among the
-- three hospital types with available ratings.

-- This does not prove that Acute Care Hospitals
-- provide worse healthcare than other hospital types.

-- Rating availability, CMS eligibility requirements,
-- and differences in hospital populations must
-- be considered before interpreting performance.

-- IMPORTANT LIMITATION:
-- An unavailable rating does not indicate
-- good or poor clinical performance.

-- TASK 1: COMPLETED.

SELECT "State",
COUNT("cleaned_rating") AS "rated_hospitals",
ROUND(AVG("cleaned_rating"),2) AS "average_rating"
FROM "clean_hospital_ratings"
GROUP BY "State"
ORDER BY "average_rating" DESC 
LIMIT 10;
-- =====================================================
-- PHASE 6: HOSPITAL PERFORMANCE ANALYSIS
-- TASK 2: AVERAGE HOSPITAL RATINGS BY STATE
-- =====================================================

-- BUSINESS QUESTION:
-- Which geographic areas have the highest average
-- CMS overall hospital star ratings?

-- SQL LOGIC:
-- Used GROUP BY State to calculate separate averages.
-- COUNT(cleaned_rating) counted rated hospitals.
-- AVG(cleaned_rating) excluded unavailable ratings.
-- Results were sorted from highest to lowest average.

-- =====================================================
-- KEY FINDINGS
-- =====================================================

-- Overall average among rated hospitals: 3.21 stars.

-- Utah:
-- 29 rated hospitals, average rating 4.24.

-- Colorado:
-- 49 rated hospitals, average rating 3.96.

-- South Dakota:
-- 18 rated hospitals, average rating 3.89.

-- Wisconsin:
-- 86 rated hospitals, average rating 3.78.

-- Minnesota:
-- 56 rated hospitals, average rating 3.77.

-- =====================================================
-- HEALTHCARE INTERPRETATION
-- =====================================================

-- Utah had the highest observed average among
-- geographic areas in this analysis.

-- However, the numbers of rated hospitals vary
-- considerably across geographic areas.

-- Small sample sizes and unavailable ratings
-- may affect the representativeness of comparisons.

-- LIMITATION:
-- These are unweighted averages of available CMS
-- star ratings, not direct measures of patient
-- outcomes or population-level healthcare quality.

-- Further analysis of rating coverage and sample
-- sizes is needed before drawing strong conclusions.
SELECT "State",
COUNT("cleaned_rating") AS "rated_hospitals",
ROUND(AVG("cleaned_rating"),2) AS "average_rating"
FROM "clean_hospital_ratings"
GROUP BY "State"
HAVING COUNT("cleaned_rating") >=30 
ORDER BY "average_rating" DESC
LIMIT 10;
-- =====================================================
-- PHASE 6 - TASK 2: STATE-LEVEL HOSPITAL RATINGS
-- =====================================================

-- BUSINESS QUESTION:
-- Which states have the highest average CMS hospital
-- ratings among states with at least 30 rated hospitals?

-- SQL LOGIC:
-- 1. Grouped hospitals by state.
-- 2. Counted hospitals with available ratings.
-- 3. Calculated average ratings using AVG().
-- 4. Used HAVING to require >= 30 rated hospitals.
-- 5. Sorted states by average rating DESC.

-- KEY FINDINGS:
-- Colorado: 49 rated hospitals, average 3.96.
-- Wisconsin: 86 rated hospitals, average 3.78.
-- Minnesota: 56 rated hospitals, average 3.77.
-- Virginia: 76 rated hospitals, average 3.68.
-- Ohio: 127 rated hospitals, average 3.59.

-- Utah initially ranked first with an average
-- of 4.24, but had only 29 rated hospitals.
-- It was excluded by the 30-hospital threshold.

-- INTERPRETATION:
-- Colorado had the highest observed average
-- among states meeting our minimum threshold.

-- LIMITATIONS:
-- The 30-hospital threshold was selected for
-- exploratory analysis, not required by CMS.
-- Missing ratings may influence comparisons.
-- Higher average ratings do not necessarily
-- establish better overall healthcare quality.

-- TASK 2: COMPLETED.
SELECT 
      "Hospital Ownership",
      COUNT("cleaned_rating") AS "rated_hospitals",
      ROUND(AVG("cleaned_rating"),2) AS "average_rating"
  FROM "clean_hospital_ratings"
  GROUP BY "Hospital Ownership"
  ORDER BY "average_rating" DESC;
-- =====================================================
-- PHASE 6 - TASK 3: HOSPITAL RATINGS BY OWNERSHIP
-- =====================================================

-- BUSINESS QUESTION:
-- How do average CMS overall hospital ratings
-- differ across hospital ownership categories?

-- SQL LOGIC:
-- 1. Grouped hospitals by ownership category.
-- 2. Counted hospitals with available ratings.
-- 3. Calculated average ratings using AVG().
-- 4. Sorted categories by average rating DESC.

-- KEY FINDINGS:
-- Total rated hospitals: 3,166.

-- Tribal:
-- 3 rated hospitals, average 4.33 stars.

-- Veterans Health Administration:
-- 112 rated hospitals, average 4.16 stars.

-- Voluntary non-profit - Church:
-- 216 rated hospitals, average 3.37 stars.

-- Voluntary non-profit - Private:
-- 1,623 rated hospitals, average 3.31 stars.

-- Proprietary:
-- 498 rated hospitals, average 2.79 stars.

-- Department of Defense:
-- No available ratings.

-- HEALTHCARE INTERPRETATION:
-- Tribal hospitals had the highest observed average,
-- but this was based on only 3 rated hospitals.

-- Veterans Health Administration hospitals had
-- a high average rating with 112 rated hospitals.

-- Proprietary hospitals had the lowest average
-- among categories with at least 30 rated hospitals.

-- LIMITATIONS:
-- Ownership categories have unequal sample sizes.
-- Unavailable ratings are excluded from averages.
-- Differences may reflect hospital characteristics,
-- patient populations, and rating eligibility.
-- Ownership alone cannot explain rating differences.

-- TASK 3: COMPLETED.

SELECT "Hospital Type",
       COUNT(*)AS "total_hospitals",
       COUNT("cleaned_rating") AS "rated_hospitals",
       ROUND(AVG("cleaned_rating"),2) AS "average_rating"
FROM "clean_hospital_ratings"
	GROUP BY "Hospital Type"
	ORDER BY "average_rating" DESC;
-- =====================================================
-- PHASE 6 - TASK 4: AVERAGE HOSPITAL RATINGS BY TYPE
-- =====================================================

-- BUSINESS QUESTION:
-- How do average CMS hospital ratings differ
-- across hospital types?

-- SQL LOGIC:
-- 1. Grouped hospitals by hospital type.
-- 2. Counted total hospitals using COUNT(*).
-- 3. Counted rated hospitals using COUNT(cleaned_rating).
-- 4. Calculated average ratings using AVG().
-- 5. Sorted hospital types by average rating DESC.

-- KEY FINDINGS:
-- Total hospitals: 5,435.
-- Rated hospitals: 3,166.

-- Veterans Administration:
-- 112 rated out of 132 hospitals.
-- Average rating: 4.16 stars.

-- Critical Access Hospitals:
-- 400 rated out of 1,386 hospitals.
-- Average rating: 3.23 stars.
-- Rating availability: 28.86%.

-- Acute Care Hospitals:
-- 2,654 rated out of 3,094 hospitals.
-- Average rating: 3.16 stars.
-- Rating availability: 85.78%.

-- Six additional hospital types had no available ratings.

-- HEALTHCARE INTERPRETATION:
-- Veterans Administration hospitals had the
-- highest observed average rating.

-- Critical Access Hospitals had substantially
-- lower rating availability than Acute Care Hospitals.

-- LIMITATIONS:
-- Hospital types have different rating coverage.
-- Missing ratings may reflect CMS eligibility rules.
-- Differences in averages do not establish causation.
-- Comparisons do not account for differences
-- in hospital characteristics or patient populations.

-- TASK 4: COMPLETED.	
SELECT "Hospital Type",
       COUNT(*)AS "total_hospitals",
       COUNT("cleaned_rating") AS "rated_hospitals",
       ROUND(AVG("cleaned_rating"),2) AS "average_rating",
	   ROUND(100.0 * COUNT("cleaned_rating")/COUNT(*),2) AS rating_availability_percentage
FROM "clean_hospital_ratings"
	GROUP BY "Hospital Type"
	ORDER BY rating_availability_percentage DESC;
	
-- =====================================================
-- PHASE 6 - TASK 5: HOSPITAL RATING AVAILABILITY
-- =====================================================

-- BUSINESS QUESTION:
-- What percentage of hospitals within each hospital
-- type have available CMS overall star ratings?

-- SQL LOGIC:
-- COUNT(*) calculates the total hospitals by type.
-- COUNT(cleaned_rating) counts hospitals with ratings.
-- AVG(cleaned_rating) calculates average available ratings.
-- Rating availability is calculated as:
-- 100 * rated hospitals / total hospitals.

-- KEY FINDINGS:
-- Total hospitals in the dataset: 5,435.
-- Hospitals with available ratings: 3,166.
-- Overall rating availability: 58.25%.

-- Acute Care Hospitals:
-- Total hospitals: 3,094.
-- Rated hospitals: 2,654.
-- Average rating: 3.16 stars.
-- Rating availability: 85.78%.

-- Acute Care - Veterans Administration:
-- Total hospitals: 132.
-- Rated hospitals: 112.
-- Average rating: 4.16 stars.
-- Rating availability: 84.85%.

-- Critical Access Hospitals:
-- Total hospitals: 1,386.
-- Rated hospitals: 400.
-- Average rating: 3.23 stars.
-- Rating availability: 28.86%.

-- The remaining six hospital types:
-- Total hospitals: 823.
-- Rated hospitals: 0.
-- Rating availability: 0%.
-- Average rating: NULL.

-- HEALTHCARE INTERPRETATION:
-- Acute Care Hospitals have the highest rating
-- availability among the nine hospital types.

-- Veterans Administration hospitals have the
-- highest observed average rating among rated types.

-- Critical Access Hospitals have substantially
-- lower rating coverage than Acute Care Hospitals.

-- ANALYTICAL LIMITATIONS:
-- Rating availability measures data coverage,
-- not clinical performance.

-- Unavailable ratings may reflect CMS eligibility
-- or reporting requirements.

-- Differences in rating coverage can affect
-- comparisons between hospital types.

-- TASK 5: COMPLETED.	
-- =====================================================
-- ADDITIONAL ANALYSIS: RATING AVAILABILITY BY OWNERSHIP
-- =====================================================

-- BUSINESS QUESTION:
-- How do average ratings and rating availability
-- differ between private nonprofit and proprietary hospitals?

SELECT
    "Hospital Ownership",
    COUNT(*) AS total_hospitals,
    COUNT(cleaned_rating) AS rated_hospitals,
    ROUND(AVG(cleaned_rating), 2) AS average_rating,
    ROUND(
        100.0 * COUNT(cleaned_rating) / COUNT(*),
        2
    ) AS rating_availability_percentage
FROM clean_hospital_ratings
WHERE "Hospital Ownership" IN (
    'Voluntary non-profit - Private',
    'Proprietary'
)
GROUP BY "Hospital Ownership"
ORDER BY rating_availability_percentage DESC;