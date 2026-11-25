# HEALTHCARE QUALITY ANALYTICS
## Hospital Performance, Rating Availability, and Unplanned Hospital Visits

**A SQL-Based Analysis of Public CMS Hospital Data**

**Project Type:** Healthcare Data Analytics | Portfolio Project  
**Data Source:** Centers for Medicare & Medicaid Services (CMS)  
**Tools:** SQL, SQLite, DB Browser for SQLite  
**Data Coverage:** 5,435 hospital records and 784 state-level performance records  
**Analysis Approach:** Data Quality Assessment, Data Cleaning, Exploratory Analysis, Performance Benchmarking, and Healthcare Interpretation

---

# 1. Executive Summary

Healthcare quality data can provide valuable insights into hospital performance, but meaningful conclusions depend on understanding how the information is collected, reported, and interpreted.

This project analyzes publicly available data from the Centers for Medicare & Medicaid Services (CMS) to investigate hospital characteristics, overall quality ratings, reporting completeness, and state-level performance measures.

Using SQL, I examined **5,435 hospital records** and **784 state-level performance records**, investigating data quality, cleaning unavailable measurements, calculating performance indicators, and validating relationships between datasets.

The analysis identified three significant findings.

**First, hospital rating availability represents an important limitation.** Of the 5,435 hospitals investigated, 2,269 (41.75%) had no available overall CMS star rating. Rating availability also differed considerably across hospital types, raising questions about the representativeness of comparisons based only on published ratings.

**Second, observed hospital ratings varied across hospital types, ownership categories, and geographic areas.** For example, proprietary hospitals had an average published rating of 2.79 stars, compared with 3.31 stars for privately owned voluntary nonprofit hospitals. However, differences in hospital characteristics, reporting eligibility, and rating availability prevent these results from establishing a causal relationship between ownership and quality.

**Third, state-level performance measures identified opportunities for further investigation into unplanned hospital visits following outpatient chemotherapy.** The CMS OP-35 measures are particularly relevant to oncology care, but the available aggregated information cannot establish the causes of individual patient admissions or identify specific hospitals classified as performing worse.

A central achievement of this project was identifying and addressing the analytical risks created by combining datasets with different levels of granularity. Through SQL JOIN validation and appropriate aggregation techniques, the analysis avoided duplicate counting and misleading attribution of state-level results to individual hospitals.

**Overall conclusion:** Reliable healthcare analytics requires more than accurate SQL calculations. It requires attention to data completeness, reporting methodology, clinical context, and the limitations of the available evidence.

---

# 2. Project Objectives

The project was designed to answer five questions:

1. How complete and reliable are the available CMS hospital datasets?
2. How are hospitals distributed across geographic areas, hospital types, and ownership categories?
3. How do published CMS overall ratings vary across different hospital groups?
4. What can state-level performance measures reveal about unplanned hospital visits?
5. Which conclusions are supported by the available data, and what additional evidence would be required before making healthcare management decisions?

The analysis focused on producing reproducible findings while avoiding unsupported conclusions about individual hospitals or clinical outcomes.

---

# 3. Data Sources and Methodology

## 3.1 Data Sources

Two publicly available CMS datasets were analyzed.

| Dataset | Records | Level of Detail |
|---|---:|---|
| Hospital General Information | 5,435 | Individual hospital |
| Unplanned Hospital Visits by State | 784 | State and performance measure |

The hospital dataset contained information including facility identifiers, hospital type, ownership, geographic location, overall CMS star ratings, and emergency-service availability.

The state-level dataset contained 14 performance measures across 56 geographic codes, including measures related to unplanned hospital visits and readmissions.

**Important distinction:** The hospital dataset identifies individual facilities, while the state-level dataset summarizes performance measures across geographic areas.

These datasets cannot be combined indiscriminately without creating risks of repeated observations and misleading results.

## 3.2 Data Quality Investigation

The initial assessment investigated:

- Duplicate hospital identifiers and state-measure combinations.
- Missing and unavailable values.
- Hospital rating distributions.
- Categorical consistency and formatting.
- Numeric ranges and conversion validity.
- Geographic code consistency.
- Potential duplication caused by JOIN operations.

The investigation confirmed:

| Data Quality Check | Finding |
|---|---|
| Unique hospital identifiers | 5,435 |
| Duplicate Facility IDs | 0 |
| State-measure records | 784 |
| Duplicate State + Measure ID combinations | 0 |
| Geographic codes in both datasets | 56 |
| Unmatched geographic codes | 0 |

These checks established a foundation for subsequent analysis.

However, successful identifier and consistency checks do not establish that all reported measurements are complete or clinically comparable.

## 3.3 Data Cleaning

Two reusable SQL views were created:

**`clean_hospital_ratings`**

Converted the textual reporting placeholder `Not Available` into SQL `NULL` in a new numerical rating column while preserving the original hospital records.

**`clean_unplanned_visits_state`**

Converted `Not Available` and `Not Applicable` into SQL `NULL` within four cleaned hospital-count fields and converted valid numerical values into integers.

The cleaning process preserved numerical zeros because zero represents an observed value, whereas `NULL` represents unavailable or inapplicable information.

Validation identified:

- Zero rating values outside the permitted 1–5 range.
- Zero numerical-conversion mismatches in the investigated fields.
- No records removed during cleaning.
- Original CMS source tables preserved.

This approach maintained data integrity while allowing subsequent numerical calculations to exclude unavailable values appropriately.

---

# 4. Key Analytical Findings

## Finding 1 — Hospital Rating Availability Is a Major Analytical Limitation

Of the **5,435 hospitals** analyzed:

| Rating Status | Hospitals | Percentage |
|---|---:|---:|
| Available rating | 3,166 | 58.25% |
| Unavailable rating | 2,269 | 41.75% |
| **Total** | **5,435** | **100%** |

Approximately two out of every five hospital records lacked an available overall rating.

Importantly, this missingness was not distributed evenly across hospital types.

### Rating Availability by Hospital Type

| Hospital Type | Total Hospitals | Rated Hospitals | Rating Availability |
|---|---:|---:|---:|
| Acute Care Hospitals | 3,094 | 2,654 | 85.78% |
| Veterans Administration | 132 | 112 | 84.85% |
| Critical Access Hospitals | 1,386 | 400 | 28.86% |

Six additional hospital types, including Psychiatric, Children's, and Rural Emergency Hospitals, had no available overall ratings in the analyzed dataset.

### Healthcare Interpretation

The substantial variation in rating availability has important implications for performance comparisons.

For example, the average rating among Critical Access Hospitals is calculated from only 28.86% of hospitals in that category, whereas the corresponding Acute Care average includes 85.78%.

As a result, comparisons between these averages may be affected by differences in the hospitals represented.

CMS rating eligibility and public reporting requirements must also be considered before interpreting unavailable ratings.

**Key insight:** The absence of an overall rating is not evidence of poor clinical performance. Rating availability should be evaluated alongside published performance indicators.

---

## Finding 2 — Hospital Ratings Differ Across Facility Types

Among the 3,166 hospitals with available ratings, the overall average was **3.21 stars**.

The distribution of available ratings was:

| Rating Category | Hospitals |
|---|---:|
| High: 4–5 stars | 1,328 |
| Moderate: 3 stars | 981 |
| Low: 1–2 stars | 857 |

The high, moderate, and low categories were defined for this project's analysis and are not official CMS classifications.

### Low-Rated Hospitals by Type

| Hospital Type | Low-Rated Hospitals | Percentage of Rated Hospitals |
|---|---:|---:|
| Acute Care Hospitals | 745 | 28.07% |
| Critical Access Hospitals | 105 | 26.25% |
| Veterans Administration | 7 | 6.25% |

Acute Care Hospitals had the highest observed proportion of 1–2-star ratings among the three hospital types with available ratings.

However, these results should not be interpreted as proof that Acute Care Hospitals provide lower-quality care than other categories.

### Average Ratings by Hospital Type

| Hospital Type | Average Rating |
|---|---:|
| Veterans Administration | 4.16 |
| Critical Access Hospitals | 3.23 |
| Acute Care Hospitals | 3.16 |

Critical Access Hospitals had an average rating slightly higher than Acute Care Hospitals, with a difference of 0.07 stars.

This small observed difference must be interpreted alongside the substantial difference in rating availability.

### Healthcare Interpretation

Hospital categories differ in their clinical roles, services, geographic locations, and populations served.

Critical Access Hospitals primarily support rural healthcare access and operate under structural and reporting arrangements that differ from many larger acute care facilities.

Consequently, differences in published average ratings cannot independently establish differences in overall clinical quality.

**Key insight:** Hospital performance comparisons should account for rating coverage and hospital characteristics rather than relying on average star ratings alone.

---

## Finding 3 — Hospital Ownership Is Associated With Differences in Published Ratings

The analysis compared hospital ratings across 12 ownership categories.

Selected results included:

| Ownership Category | Rated Hospitals | Average Rating |
|---|---:|---:|
| Veterans Health Administration | 112 | 4.16 |
| Voluntary Nonprofit — Church | 216 | 3.37 |
| Voluntary Nonprofit — Private | 1,623 | 3.31 |
| Government — Local | 177 | 2.93 |
| Government — Hospital District or Authority | 229 | 2.92 |
| Proprietary (For-Profit) | 498 | 2.79 |

Tribal hospitals had an observed average of 4.33 stars, but this result was based on only three rated hospitals and therefore warrants particular caution.

### Additional Investigation: Rating Availability by Ownership

Comparing privately owned voluntary nonprofit hospitals with proprietary hospitals revealed another important difference.

| Indicator | Voluntary Nonprofit — Private | Proprietary |
|---|---:|---:|
| Total hospitals | 2,341 | 1,064 |
| Rated hospitals | 1,623 | 498 |
| Average rating | 3.31 | 2.79 |
| Rating availability | 69.33% | 46.80% |

Privately owned voluntary nonprofit hospitals demonstrated both higher observed average ratings and greater rating availability.

The difference in rating availability was approximately **22.52 percentage points**.

### Healthcare Interpretation

These results establish descriptive differences between ownership categories, but they do not demonstrate that ownership causes better or worse clinical performance.

Potential confounding factors include hospital type, clinical services, patient complexity, geographic location, available resources, and reporting eligibility.

The proprietary and private nonprofit groups also differ substantially in rating availability.

A more rigorous investigation would need to account for these factors before attributing differences in quality to ownership.

**Key insight:** Ownership-related rating differences warrant further investigation, but descriptive comparisons should not be presented as causal findings.

---

## Finding 4 — Geographic Differences Require Careful Interpretation

Hospital distribution varied substantially across geographic areas.

The three states containing the largest numbers of hospital records were:

| State | Total Hospitals |
|---|---:|
| Texas | 470 |
| California | 378 |
| Florida | 223 |

However, a higher hospital count does not necessarily indicate better healthcare access, greater capacity, or superior performance.

### Average Hospital Ratings by State

An exploratory analysis initially identified Utah as the geographic area with the highest observed average rating:

**Utah: 4.24 stars, based on 29 rated hospitals.**

To examine how rankings changed when excluding areas with fewer rated facilities, a minimum threshold of 30 rated hospitals was applied.

The leading states under this threshold were:

| State | Rated Hospitals | Average Rating |
|---|---:|---:|
| Colorado | 49 | 3.96 |
| Wisconsin | 86 | 3.78 |
| Minnesota | 56 | 3.77 |
| Virginia | 76 | 3.68 |
| Ohio | 127 | 3.59 |

The 30-hospital threshold was selected for exploratory analysis. It is not a CMS standard and does not guarantee statistical reliability.

### Healthcare Interpretation

Geographic differences in published star ratings may reflect variation in hospital characteristics, service availability, reporting eligibility, and other factors.

These results identify patterns worth investigating but do not establish that one state provides better healthcare overall.

**Key insight:** State-level rankings should be interpreted as descriptive summaries of the rated hospital population, not comprehensive evaluations of healthcare quality.

---

## Finding 5 — Oncology-Related Unplanned Hospital Visits Present an Important Quality Improvement Opportunity

The state-level dataset contained 14 performance measures, but only four had available numerical observations in the investigated `Number of Hospitals Worse` field.

The analyzed measures and their aggregated counts were:

| CMS Measure | Hospitals Classified as Worse |
|---|---:|
| OP_35_ADM | 70 |
| OP_36 | 49 |
| OP_35_ED | 16 |
| OP_32 | 3 |

These totals represent measure-specific classifications and should not be treated as directly comparable measures of clinical quality.

### Focus: OP-35 Chemotherapy Measures

CMS OP-35 concerns unplanned hospital visits following outpatient chemotherapy.

Its components include:

**OP_35_ADM:** Risk-standardized inpatient admissions within 30 days following outpatient chemotherapy.

**OP_35_ED:** Risk-standardized emergency department visits within 30 days following outpatient chemotherapy.

The state-level dataset reports the number of hospitals assigned to performance categories, rather than patient-level admissions or emergency visits.

### Selected State-Level OP_35_ADM Findings

| State | Hospitals Classified as Worse |
|---|---:|
| California | 9 |
| New York | 8 |
| Illinois | 7 |
| New Jersey | 7 |
| Pennsylvania | 7 |

These findings identify geographic areas containing hospitals classified as performing worse than the relevant national comparison for this measure.

However, they do not establish the overall quality of oncology care in those states.

The analysis cannot identify the individual hospitals involved, determine their eligible patient populations, or establish why unplanned admissions occurred.

### Clinical Interpretation

From an oncology nursing perspective, unplanned hospital visits following chemotherapy may involve complications such as:

- Febrile neutropenia and serious infection.
- Anemia and other treatment-related complications.
- Dehydration, nausea, vomiting, and diarrhea.
- Uncontrolled pain or other symptoms requiring urgent assessment.

Such complications may require emergency evaluation or inpatient management depending on severity and patient characteristics.

However, the available state-level data cannot determine which complications occurred in particular patients or whether care processes contributed to the observed classifications.

**Key insight:** OP-35 offers a clinically relevant direction for quality improvement investigation, particularly in oncology settings, but additional hospital-level and patient-level evidence is necessary before identifying causes or recommending specific treatment changes.

---

# 5. Advanced SQL and Analytical Validation

A major technical challenge involved combining the hospital-level dataset with state-level performance information.

The hospital dataset contained one record per unique Facility ID, while the unplanned-visits dataset contained one record per state and performance measure.

A JOIN performed only on State could match individual hospitals with multiple measures, multiplying the number of hospital rows in the resulting dataset.

For example, California contained 378 hospital records and 14 state-level measure records.

Joining these datasets on State without restricting the measure could produce:

**378 × 14 = 5,292 joined rows for California.**

These rows would not represent 5,292 unique hospitals.

### Approach Used

To prevent misleading calculations, the analysis:

1. Restricted relevant JOIN operations to a specific performance measure.
2. Used appropriate aggregate functions to preserve repeated state-level values.
3. Avoided summing state-level counts across duplicated hospital rows.
4. Validated JOIN outputs using distinct hospital identifiers.

### JOIN Validation Results

| Validation Metric | Result |
|---|---:|
| Total joined rows | 5,435 |
| Distinct hospital IDs | 5,435 |
| Excess joined rows | 0 |

The validated JOIN preserved all 5,435 hospital records without introducing duplicate hospital identifiers.

This validation applies to the specific OP_35_ADM JOIN investigated.

### Additional SQL Techniques

The project also applied:

- `CASE WHEN` for data cleaning and rating classifications.
- `COALESCE` for readable missing-data presentation.
- `INNER JOIN` and `LEFT JOIN` for combining data.
- `COUNT(DISTINCT)` for identifier validation.
- Common Table Expressions for multi-stage calculations.
- Correlated subqueries for comparing individual ratings with state averages.
- Window functions for calculating category percentages.
- `NOT EXISTS` for geographic consistency checks.

**Technical takeaway:** Accurate SQL syntax is only one part of reliable analytics. The structure of the data, JOIN cardinality, aggregation logic, and interpretation of resulting measurements are equally important.

---

# 6. Analytical Limitations

Several limitations must be considered before using these results for healthcare decisions.

### 6.1 Incomplete Rating Availability

Overall ratings were unavailable for 41.75% of hospitals.

The missingness was uneven across hospital types and ownership categories, potentially affecting the representativeness of comparisons based on rated hospitals.

### 6.2 CMS Reporting and Eligibility Requirements

Not all hospital categories necessarily meet the same reporting and eligibility conditions for an overall CMS star rating.

Missing ratings cannot automatically be attributed to poor performance or inadequate reporting practices.

### 6.3 Unequal Hospital Populations

Hospital groups differ in size, location, services, patient populations, and potentially other characteristics.

The analysis did not control for all such differences.

### 6.4 Different Levels of Data Granularity

The hospital-level and state-level datasets represent different units of observation.

State-level performance classifications cannot be used to identify individual hospitals or calculate patient-level admission rates.

### 6.5 Descriptive Analysis Does Not Establish Causation

The observed relationships between hospital type, ownership, geography, and published ratings are descriptive.

The analysis did not use a causal research design capable of determining whether these characteristics cause differences in clinical outcomes.

### 6.6 Limitations of Star-Rating Averages

CMS overall star ratings are ordered categories summarizing multiple quality domains.

Arithmetic averages provide useful descriptive comparisons, but they should not be interpreted as direct measurements of clinical outcomes.

### 6.7 Incomplete Measurement Coverage

Ten of the 14 state-level measures had no numerical observations in the investigated worse-classification field.

Four geographic territories also lacked numerical observations in this field.

This limits the analyses that can be performed using the available cleaned measurements.

### 6.8 Dataset Version and Reporting Period

The preserved CMS datasets are strongly consistent with the November 12, 2026 public release. The original state-level CSV contains measure-specific reporting periods.

OP_35_ADM and OP_35_ED cover January 1 through December 31, 2024. Other measures have different reporting periods, as documented in dataset_documentation.md.

The project was reproduced successfully using the preserved CSV files and SQL scripts. An exact comparison with the official archived release files has not been performed.

---

# 7. Operational Implications and Recommended Next Steps

The findings support several practical directions for further investigation.

### Recommendation 1 — Evaluate Rating Coverage Before Comparing Performance

Healthcare analysts and quality improvement teams should assess the proportion of hospitals with available ratings within each comparison group.

Comparisons should present both the performance indicator and the corresponding number and percentage of rated facilities.

This would help decision-makers understand the population represented by the reported results.

### Recommendation 2 — Investigate Performance Differences Using Comparable Hospital Groups

Differences in average ratings across ownership categories or hospital types should not immediately be attributed to managerial or clinical practices.

Further analysis should compare hospitals with similar characteristics and consider differences in eligibility, services, geography, and patient populations.

The objective should be to identify meaningful patterns rather than produce simplistic rankings.

### Recommendation 3 — Investigate Oncology-Related Unplanned Hospital Visits

Healthcare quality teams reviewing OP-35 performance should consider obtaining relevant hospital-level and patient-level data.

Potential areas for investigation include:

- Reasons for unplanned admission or emergency evaluation.
- Chemotherapy regimens and patient risk characteristics.
- Management of treatment-related complications.
- Patient education and recognition of warning symptoms.
- Appropriate supportive and prophylactic medications.
- Symptom management and access to timely follow-up care.

These are **investigation priorities**, not confirmed explanations for the state-level findings.

Any clinical intervention should be based on a more detailed review of outcomes, care processes, and applicable clinical guidelines.

### Recommendation 4 — Maintain Reproducible Data Quality and JOIN Validation Procedures

Healthcare analytics workflows should include validation of source identifiers, reporting placeholders, data granularity, and JOIN results.

In particular, analysts should verify that combining datasets does not introduce duplicate counting or incorrectly attribute aggregated results to individual patients or hospitals.

This helps strengthen the reliability of reports used for clinical and operational decision-making.

---

# 8. Conclusion

This project demonstrates how SQL can be applied to real-world healthcare data to investigate hospital characteristics, evaluate data quality, calculate performance indicators, and identify clinically relevant areas for further investigation.

The findings revealed substantial differences in hospital rating availability, variation in published ratings across hospital groups, and important opportunities for investigating unplanned hospital visits following outpatient chemotherapy.

However, the analysis also demonstrated why healthcare performance data must be interpreted cautiously.

Unavailable ratings are not equivalent to poor clinical performance. Differences in published hospital ratings do not independently establish causation. State-level performance measures cannot identify individual hospital outcomes, and successful JOIN operations must still be validated for analytical correctness.

By combining SQL-based investigation with clinical reasoning, the project emphasized the importance of moving beyond numerical results toward responsible, evidence-informed interpretation.

**The central lesson of this analysis is that trustworthy healthcare analytics depends not only on calculating the correct numbers, but also on understanding what those numbers represent, what they cannot establish, and how they can responsibly inform further investigation.**

---

# 9. Technical Competencies Demonstrated

**SQL and Database Analysis**

Data cleaning, conditional expressions, aggregations, window functions, joins, subqueries, Common Table Expressions, and validation queries.

**Data Quality Management**

Missing-value analysis, duplicate detection, identifier validation, numeric conversion checks, and reporting-placeholder handling.

**Healthcare Analytics**

Hospital performance indicators, rating availability, CMS measure interpretation, descriptive benchmarking, and clinical-context evaluation.

**Analytical Communication**

Interpretation of findings, identification of limitations, avoidance of unsupported causal claims, and development of evidence-informed recommendations.

---

## Official Data and Methodology References

**CMS Provider Data Catalog:**  
Hospital General Information and hospital quality datasets.

**CMS Overall Hospital Quality Star Rating:**  
Methodology, reporting eligibility, and interpretation of published hospital ratings.

**CMS Unplanned Hospital Visits:**  
Definitions and interpretation of hospital readmission and unplanned-visit measures.

**CMS OP-35 Chemotherapy Measure:**  
Admissions and emergency department visits following outpatient chemotherapy.

**SQLite Documentation:**  
SQL functions, Common Table Expressions, JOIN operations, and subqueries.

Publication note: The project SQL scripts were successfully executed against a freshly reconstructed database. The principal numerical findings were reproduced. Dataset release identification is strongly supported by the available CMS information, but exact archived-file identity remains unverified.