-- =====================================================
-- HEALTHCARE SQL ANALYTICS — PROJECT 1
-- PHASE 5: EXPLORATORY DATA ANALYSIS
-- File: 04_exploratory_analysis.sql
-- =====================================================

-- OBJECTIVE:
-- Explore hospital characteristics, ratings,
-- geographic distributions, and state-level
-- performance measurements.

-- DATA SOURCES:
-- 1. clean_hospital_ratings
-- 2. clean_unplanned_visits_state

-- =====================================================
-- TASK 2: HOSPITAL TYPE DISTRIBUTION
-- =====================================================

-- BUSINESS QUESTION:
-- What percentage of hospitals belongs to each
-- hospital type in the CMS dataset?
SELECT "Hospital Type",COUNT("Facility ID") AS total_hospitals,ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
) AS hospital_percentage
FROM "clean_hospital_ratings"
GROUP BY "Hospital Type"
ORDER BY hospital_percentage DESC;
-- =====================================================
-- FINDINGS: HOSPITAL TYPE DISTRIBUTION
-- =====================================================

-- Total hospitals analyzed: 5,435.
-- Total hospital types: 9.

-- Acute Care Hospitals:
-- 3,094 hospitals (56.93%).

-- Critical Access Hospitals:
-- 1,386 hospitals (25.50%).

-- Psychiatric Hospitals:
-- 632 hospitals (11.63%).

-- Acute Care and Critical Access Hospitals together
-- account for 82.43% of hospital records.

-- INTERPRETATION:
-- The dataset is dominated by Acute Care and
-- Critical Access Hospitals.

-- LIMITATION:
-- Hospital counts do not represent patient volumes
-- or hospital performance.

SELECT "Hospital Ownership",COUNT("Facility ID") AS total_hospitals,ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
) AS ownership_percentage
FROM "clean_hospital_ratings"
GROUP BY "Hospital Ownership"
ORDER BY ownership_percentage DESC;
-- =====================================================
-- FINDINGS: HOSPITAL OWNERSHIP DISTRIBUTION
-- =====================================================

-- Total hospitals analyzed: 5,435.
-- Total ownership categories: 12.

-- Voluntary non-profit - Private:
-- 2,341 hospitals (43.07%).

-- Proprietary:
-- 1,064 hospitals (19.58%).

-- Together, these two categories represent
-- 62.65% of hospital records.

-- INTERPRETATION:
-- Voluntary non-profit - Private is the largest
-- hospital ownership category in the dataset.

-- LIMITATION:
-- Ownership distribution does not indicate
-- clinical performance or quality of care.
-- =====================================================
-- PHASE 5: EXPLORATORY DATA ANALYSIS
-- TASK 4: HOSPITAL RATING STATISTICS
-- =====================================================

-- BUSINESS QUESTION:
-- What are the average, minimum, and maximum
-- hospital ratings among hospitals with available
-- CMS overall star ratings?

SELECT
    COUNT(cleaned_rating) AS rated_hospitals,
    ROUND(AVG(cleaned_rating), 2) AS average_rating,
    MIN(cleaned_rating) AS minimum_rating,
    MAX(cleaned_rating) AS maximum_rating
FROM clean_hospital_ratings;

SELECT "Measure ID",
  COUNT(cleaned_hospitals_worse) AS states_with_available_data 
 FROM clean_unplanned_visits_state
	   GROUP BY "Measure ID";
-- =====================================================
-- FINDING: STATE-LEVEL MEASURE AVAILABILITY
-- =====================================================

-- Total measures investigated: 14.
-- Measures with available numeric observations: 4.
-- OP_32, OP_35_ADM, OP_35_ED, OP_36:
-- 52 available observations each.

-- Remaining 10 measures:
-- 0 available numerical observations.

-- Total numeric observations: 208.
-- Total NULL observations: 576.

-- ANALYTICAL DECISION:
-- Focus initial numerical analysis on the four
-- measures with available data.
-- Verify measure definitions before interpretation.
-- Identify geographic areas without numeric observations
-- in the Number of Hospitals Worse field.

SELECT
    "State",
    COUNT(cleaned_hospitals_worse) AS measures_with_available_data
FROM clean_unplanned_visits_state
GROUP BY "State"
HAVING COUNT(cleaned_hospitals_worse) = 0;
-- =====================================================
-- FINDING: GEOGRAPHIC DATA AVAILABILITY
-- =====================================================

-- Total geographic codes: 56.
-- Geographic codes with numeric observations: 52.
-- Geographic codes without numeric observations: 4.

-- Codes without numeric observations:
-- AS: American Samoa
-- GU: Guam
-- MP: Northern Mariana Islands
-- VI: U.S. Virgin Islands

-- INTERPRETATION:
-- All four areas without available numerical
-- observations are U.S. territories.

-- LIMITATION:
-- Unavailable values do not indicate zero
-- hospital performance events.	   
SELECT "State","Measure ID","cleaned_hospitals_worse" FROM clean_unplanned_visits_state
WHERE "Measure ID"='OP_35_ADM' AND cleaned_hospitals_worse IS NOT NULL
ORDER BY "cleaned_hospitals_worse" DESC
LIMIT 5;   
-- FINDING: OP_35_ADM
-- California: 9 hospitals classified as worse.
-- New York: 8.
-- Illinois, New Jersey, Pennsylvania: 7 each.
--
-- INTERPRETATION:
-- These represent counts of hospitals classified
-- as worse for this specific CMS measure.
--
-- LIMITATION:
-- Higher counts do not automatically indicate
-- poorer statewide performance.
-- States have different hospital populations.
-- Additional states may be tied at the cutoff.
SELECT "State","Measure ID","cleaned_hospitals_worse" FROM clean_unplanned_visits_state
WHERE "Measure ID"='OP_35_ED' AND cleaned_hospitals_worse IS NOT NULL
ORDER BY "cleaned_hospitals_worse" DESC
LIMIT 5;
-- =====================================================
-- FINDING: OP_35_ED — HOSPITALS CLASSIFIED AS WORSE
-- =====================================================

-- California: 3 hospitals.
-- Oklahoma: 2 hospitals.
-- Washington: 2 hospitals.
-- Wisconsin: 2 hospitals.
-- Colorado: 1 hospital.

-- INTERPRETATION:
-- California had the highest count among the
-- five returned geographic areas.

-- LIMITATION:
-- Counts are not adjusted for eligible hospitals.
-- Ties may extend beyond the five returned rows.
-- Different CMS measures should not be interpreted
-- as directly comparable performance indicators.
SELECT "Measure ID",COUNT("State") AS "Geographic_Areas_With_Data",SUM("cleaned_hospitals_worse") AS "Total_Hospitals_Worse"
 FROM "clean_unplanned_visits_state"
 WHERE "cleaned_hospitals_worse" IS NOT NULL
 GROUP BY "Measure ID"
 ORDER BY "Total_Hospitals_Worse" DESC ;
 
 SELECT "State",COUNT("Facility ID") AS "total_hospitals",ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
) AS "hospital_percentage" FROM "clean_hospital_ratings"
GROUP BY "State"
ORDER BY "hospital_percentage" DESC,"State" ASC
LIMIT 10;

-- =====================================================
-- FINDINGS: HOSPITAL DISTRIBUTION BY STATE
-- =====================================================

-- Total hospitals analyzed: 5,435.

-- Texas: 470 hospitals (8.65%).
-- California: 378 hospitals (6.95%).
-- Florida: 223 hospitals (4.10%).

-- Illinois, New York, and Ohio each have
-- 193 hospitals (3.55%).

-- INTERPRETATION:
-- Texas has the largest number of hospitals
-- in the CMS dataset, followed by California.

-- LIMITATION:
-- Hospital counts do not directly measure
-- healthcare access, hospital capacity,
-- or population-adjusted availability.
SELECT "Emergency Services",COUNT("Facility ID") AS "Total Hospitals",ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
) AS "percentage" FROM "clean_hospital_ratings"
GROUP BY "Emergency Services";
-- =====================================================
-- FINDINGS: EMERGENCY SERVICES AVAILABILITY
-- =====================================================

-- Total hospitals analyzed: 5,435.

-- Hospitals reporting emergency services:
-- 4,501 (82.82%).

-- Hospitals not reporting emergency services:
-- 934 (17.18%).

-- INTERPRETATION:
-- Most hospitals in the dataset report
-- offering emergency services.

-- LIMITATION:
-- Emergency service availability does not indicate
-- emergency department capacity or quality of care.

-- TASK 8: COMPLETED.