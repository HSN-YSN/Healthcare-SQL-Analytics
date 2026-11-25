# Exploratory Data Analysis & Hospital Performance

## Healthcare SQL Analytics — Project 1

**Data Source:** Centers for Medicare & Medicaid Services (CMS)  
**Database:** SQLite  
**Supporting Scripts:** `04_exploratory_analysis.sql` and `05_hospital_performance.sql`

---

## 1. Analysis Objectives

This analysis explored hospital characteristics, geographic distribution, CMS overall star ratings, rating availability, and state-level performance measures.

The objective was to identify meaningful patterns while recognizing the limitations of aggregated healthcare data and incomplete performance reporting.

The analysis covered 5,435 hospital records and 784 state-level performance records.

---

## 2. Hospital Characteristics

### Hospital Type Distribution

The hospital dataset contained nine hospital types.

| Hospital Type | Hospitals | Percentage |
|---|---:|---:|
| Acute Care Hospitals | 3,094 | 56.93% |
| Critical Access Hospitals | 1,386 | 25.50% |
| Psychiatric Hospitals | 632 | 11.63% |

Acute Care and Critical Access Hospitals accounted for approximately 82.43% of the dataset.

**Interpretation:** The dataset is dominated by these two hospital categories. Comparisons involving other hospital types must consider differences in representation.

### Hospital Ownership

The dataset contained 12 ownership categories.

The two largest were:

| Ownership Category | Hospitals | Percentage |
|---|---:|---:|
| Voluntary Nonprofit — Private | 2,341 | 43.07% |
| Proprietary | 1,064 | 19.58% |

Together, these categories represented 62.65% of hospital records.

Ownership distribution describes hospital characteristics but does not independently indicate the quality of clinical care.

---

## 3. Hospital Rating Distribution

Among 5,435 hospital records:

| Rating Availability | Hospitals | Percentage |
|---|---:|---:|
| Available | 3,166 | 58.25% |
| Unavailable | 2,269 | 41.75% |

The average published rating among rated hospitals was **3.21 stars**.

For exploratory purposes, hospitals were grouped into three rating categories:

| Rating Category | Hospitals |
|---|---:|
| High (4–5 stars) | 1,328 |
| Moderate (3 stars) | 981 |
| Low (1–2 stars) | 857 |

These categories were defined for this project and do not represent official CMS performance classifications.

**Interpretation:** A substantial proportion of hospitals lacked published overall ratings. Unavailable ratings should not be interpreted as evidence of poor clinical performance.

---

## 4. Hospital Performance by Type

The analysis compared published average ratings and rating availability across hospital types.

| Hospital Type | Rated Hospitals | Average Rating | Rating Availability |
|---|---:|---:|---:|
| Veterans Administration | 112 | 4.16 | 84.85% |
| Critical Access Hospitals | 400 | 3.23 | 28.86% |
| Acute Care Hospitals | 2,654 | 3.16 | 85.78% |

The average rating difference between Critical Access and Acute Care Hospitals was 0.07 stars.

However, rating availability differed substantially between these categories.

**Interpretation:** Rating coverage and hospital characteristics must be considered before drawing conclusions about comparative performance.

The observed differences do not establish that one hospital type delivers better clinical outcomes than another.

---

## 5. Hospital Performance by Ownership

The analysis identified differences in published ratings across ownership categories.

A focused comparison examined privately owned voluntary nonprofit hospitals and proprietary hospitals.

| Indicator | Private Nonprofit | Proprietary |
|---|---:|---:|
| Total hospitals | 2,341 | 1,064 |
| Rated hospitals | 1,623 | 498 |
| Average rating | 3.31 | 2.79 |
| Rating availability | 69.33% | 46.80% |

Private nonprofit hospitals had higher average published ratings and greater rating availability.

However, the analysis did not account for differences in patient populations, hospital services, geographic characteristics, or other potential confounding factors.

**Interpretation:** These findings demonstrate descriptive associations. They do not establish that ownership causes differences in healthcare quality.

---

## 6. Geographic Performance Analysis

Hospital counts varied across states.

The three states with the largest numbers of hospital records were Texas (470), California (378), and Florida (223).

An exploratory ranking was also performed using average published ratings.

To examine rankings among states with larger rated-hospital counts, a minimum threshold of 30 rated hospitals was applied.

| State | Rated Hospitals | Average Rating |
|---|---:|---:|
| Colorado | 49 | 3.96 |
| Wisconsin | 86 | 3.78 |
| Minnesota | 56 | 3.77 |
| Virginia | 76 | 3.68 |
| Ohio | 127 | 3.59 |

Utah had an average rating of 4.24 stars among 29 rated hospitals but was excluded by the exploratory threshold.

**Interpretation:** The minimum sample-size threshold was selected for this analysis and is not an official CMS methodology requirement.

Geographic differences in average published ratings do not establish differences in overall statewide healthcare quality.

---

## 7. State-Level Performance Measures

The state-level dataset contained 14 healthcare performance measures across 56 geographic codes.

Only four measures contained numerical observations in the investigated `Number of Hospitals Worse` field.

| Measure ID | Total Hospitals Classified as Worse |
|---|---:|
| OP_35_ADM | 70 |
| OP_36 | 49 |
| OP_35_ED | 16 |
| OP_32 | 3 |

These totals represent aggregated, measure-specific hospital classifications rather than patient event counts.

The OP_35_ADM investigation identified California (9), New York (8), and Illinois, New Jersey, and Pennsylvania (7 each) among states with the highest counts.

**Interpretation:** These findings identify geographic patterns that may warrant further investigation.

However, state-level counts cannot identify individual hospitals classified as worse or establish the causes of unplanned hospital visits.

Different measures should not be treated as directly comparable indicators of clinical quality.

---

## 8. Analytical Limitations

The following limitations affect interpretation:

**Rating availability:** Overall ratings were unavailable for 41.75% of hospital records.

**Reporting eligibility:** Hospital categories may face different CMS rating eligibility and reporting requirements.

**Hospital characteristics:** Differences in hospital services, patient populations, and geographic location were not controlled for.

**Data granularity:** State-level classifications cannot be attributed to individual hospitals.

**Causation:** Descriptive differences do not establish causal relationships.

**Measure availability:** Ten of the 14 state-level measures had no numerical observations in the investigated worse-classification field.

---

## 9. Conclusion

The exploratory and hospital performance analyses revealed substantial differences in hospital characteristics, rating availability, and published performance indicators.

A major finding was that rating availability varied considerably across hospital types and ownership categories.

This reinforces the importance of reporting performance indicators alongside the number and percentage of hospitals represented.

The analysis also demonstrated that differences in published ratings require careful interpretation and should not automatically be attributed to hospital ownership, geographic location, or facility type.

The findings provide a foundation for further healthcare investigation while emphasizing transparency, data completeness, and responsible interpretation.

---

## Supporting SQL Scripts

**Exploratory Data Analysis**

`sql/04_exploratory_analysis.sql`

**Hospital Performance Analysis**

`sql/05_hospital_performance.sql`

Verification status: The SQL scripts were successfully executed against a reconstructed SQLite database, and the major analytical findings were reproduced.