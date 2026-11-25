# Data Quality Assessment Report
## Healthcare SQL Analytics — Project 1

**Data Source:** Centers for Medicare & Medicaid Services (CMS)  
**Database:** SQLite  
**Supporting SQL:** `sql/02_data_quality.sql`  
**Assessment Scope:** Hospital General Information and Unplanned Hospital Visits by State

---

## 1. Executive Summary

This assessment investigated the completeness, consistency, uniqueness, and numerical usability of two publicly available CMS healthcare datasets.

The investigation covered:

| Dataset | Records |
|---|---:|
| Hospital General Information | 5,435 |
| Unplanned Hospital Visits by State | 784 |
| **Total** | **6,219** |

The assessment found no duplicate records under the selected identifying keys and no unmatched geographic codes between the datasets.

However, substantial limitations were identified in the availability of performance measurements.

In particular, 41.75% of hospital records lacked an available overall CMS star rating, and 73.47% of state-level records contained reporting placeholders in the investigated `Number of Hospitals Worse` field.

These findings informed the subsequent cleaning strategy and established important limitations for interpreting hospital performance.

---

## 2. Assessment Objectives

The data-quality investigation evaluated:

1. Completeness of key identifying fields.
2. Uniqueness of hospital and state-measure identifiers.
3. Availability of hospital quality ratings.
4. Consistency of hospital characteristics.
5. Numerical validity of selected performance fields.
6. Geographic consistency between datasets.
7. Risks associated with interpreting aggregated performance information.

The purpose was to identify potential analytical problems before cleaning and performance evaluation.

---

## 3. Hospital General Information

### 3.1 Identifier Validation

The dataset contained 5,435 hospital records with 5,435 distinct Facility IDs.

**Result:** No duplicate Facility IDs were identified.

Repeated hospital names were observed.

For example, 13 records shared the name `MEMORIAL HOSPITAL`, but their Facility IDs were distinct.

**Interpretation:** Facility names are not reliable unique identifiers. Facility ID was selected as the appropriate hospital identifier.

### 3.2 Missing-Value Investigation

The following fields were investigated for SQL `NULL`, empty strings, and whitespace-only values:

| Field | Identified Missing or Blank Values |
|---|---:|
| Facility ID | 0 |
| Facility Name | 0 |
| State | 0 |
| Hospital Type | 0 |
| Hospital Ownership | 0 |

These results describe the investigated fields and checks, not every field in the original dataset.

### 3.3 Hospital Rating Completeness

The original hospital rating field contained the reporting placeholder `Not Available`.

| Rating Status | Hospitals | Percentage |
|---|---:|---:|
| Available | 3,166 | 58.25% |
| Not Available | 2,269 | 41.75% |
| **Total** | **5,435** | **100%** |

The unavailable ratings represented a substantial limitation for performance comparisons.

Further investigation found that rating availability varied across hospital types.

| Hospital Type | Rating Availability |
|---|---:|
| Acute Care Hospitals | 85.78% |
| Veterans Administration | 84.85% |
| Critical Access Hospitals | 28.86% |

Six additional hospital types had no available overall ratings.

**Interpretation:** Rating availability is not uniform across hospital categories.

**Limitation:** The absence of a published rating cannot automatically be interpreted as poor clinical performance. CMS eligibility and reporting methodology require consideration.

---

## 4. State-Level Performance Dataset

### 4.1 Record Structure

The dataset contained:

- 784 records.
- 56 geographic codes.
- 14 distinct measures for each geographic code.

The combination of `State` and `Measure ID` was investigated for duplicates.

**Result:** No duplicate combinations were identified.

Each geographic code had 14 distinct measure records.

### 4.2 Missing and Unavailable Measurements

The `Number of Hospitals Worse` field contained numerical values and two reporting placeholders.

| Value Category | Records | Percentage |
|---|---:|---:|
| Not Available | 408 | 52.04% |
| Not Applicable | 168 | 21.43% |
| Numerical observations | 208 | 26.53% |
| **Total** | **784** | **100%** |

The two reporting placeholders together represented 576 records, or 73.47% of the dataset.

These categories were preserved in the original source table.

**Interpretation:** Most records did not contain an available numerical value in this field.

This does not mean the corresponding hospitals experienced no quality events.

### 4.3 Measure-Level Availability

Of the 14 measures investigated, four contained available numerical observations in `Number of Hospitals Worse`:

| Measure | Available Geographic Observations |
|---|---:|
| OP_32 | 52 |
| OP_35_ADM | 52 |
| OP_35_ED | 52 |
| OP_36 | 52 |
| Remaining 10 measures | 0 |

Four geographic codes had no numerical observations in this field:

- AS — American Samoa.
- GU — Guam.
- MP — Northern Mariana Islands.
- VI — U.S. Virgin Islands.

These findings describe data availability, not the clinical performance of these geographic areas.

### 4.4 Numerical Validation

The investigated numerical values in `Number of Hospitals Worse` ranged from 0 to 9.

An additional format-validation query found zero unexpected values outside the known placeholders and expected nonnegative integer format.

**Cleaning implication:** Valid numerical zeros should be retained. Reporting placeholders should not be converted into zero.

---

## 5. Geographic Consistency

Geographic-code matching was investigated between the hospital-level and state-level datasets.

`NOT EXISTS` queries were used to identify unmatched codes in both directions.

**Results:**

| Validation | Finding |
|---|---|
| Hospital geographic codes | 56 |
| State-level geographic codes | 56 |
| Hospital codes absent from state-level data | 0 |
| State-level codes absent from hospital data | 0 |

The matching geographic codes support joining the datasets by State.

However, geographic consistency alone does not establish that both datasets contain equivalent reporting populations.

---

## 6. Data Quality Risks and Decisions

### Risk 1 — Unavailable Hospital Ratings

**Finding:** 41.75% of hospital records had unavailable overall ratings.

**Decision:** Preserve the original values and use SQL `NULL` for unavailable numerical ratings in a cleaned view.

**Reason:** Prevent reporting placeholders from affecting numerical calculations.

### Risk 2 — State-Level Reporting Placeholders

**Finding:** The investigated performance-count field contained both `Not Available` and `Not Applicable`.

**Decision:** Convert these placeholders to SQL `NULL` in cleaned numerical fields while preserving their original values in the source table.

**Reason:** Prevent invalid numerical conversions and maintain traceability.

### Risk 3 — Repeated Hospital Names

**Finding:** Multiple facilities shared identical names.

**Decision:** Use Facility ID rather than Facility Name to identify hospitals.

**Reason:** Avoid incorrectly treating separate facilities as duplicate records.

### Risk 4 — Different Data Granularity

**Finding:** One dataset contained individual hospitals, while the other contained state-level measure records.

**Decision:** Validate JOIN cardinality and avoid attributing aggregated state-level values to individual hospitals.

**Reason:** Prevent duplicate counting and misleading clinical interpretations.

---

## 7. Assessment Limitations

The data-quality assessment focused on selected identifiers, categorical fields, hospital ratings, and state-level performance-count columns.

It did not constitute a complete validation of every source field or every CMS quality measure.

The investigation also did not independently verify the underlying clinical validity of CMS measurements.

Missingness and reporting placeholders may reflect measure eligibility, publication rules, or other methodology-specific conditions.

The preserved CSV files are consistent with the CMS November 12, 2026 release. Measure-specific reporting periods have been documented in dataset_documentation.md. Exact file identity has not been verified through an archived-file hash comparison.

---

## 8. Conclusion

The data-quality assessment established that the investigated datasets had consistent identifying keys and matching geographic codes.

However, performance-measure availability presented an important analytical limitation.

The investigation directly informed the project's cleaning decisions, including preservation of original records, creation of numerical views, and appropriate handling of unavailable values.

**The central finding is that reliable healthcare performance analysis requires explicit investigation of missingness, reporting eligibility, data granularity, and identifier integrity before interpreting performance indicators.**

---

## Supporting Documentation

**SQL Investigation:** `sql/02_data_quality.sql`

**Cleaning Methodology:** `docs/cleaning_methodology.md`

**Official Data Source:** Centers for Medicare & Medicaid Services (CMS)

Reproducibility status: The project SQL scripts were successfully executed against a fresh database reconstructed from the original CSV files.