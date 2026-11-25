# Dataset Documentation
## Healthcare SQL Analytics — Project 1

### 1. Overview

This project analyzes two publicly available datasets published by the Centers for Medicare & Medicaid Services (CMS).

The datasets describe hospital characteristics, published quality ratings, and state-level performance measures.

**Total source records analyzed: 6,219.**

| Dataset | Records | Level of Analysis |
|---|---:|---|
| Hospital General Information | 5,435 | Individual hospital |
| Unplanned Hospital Visits — State | 784 | State and measure |

The original CSV files were preserved throughout the project.

---

### 2. Data Sources

#### Dataset 1: Hospital General Information

**Publisher:** Centers for Medicare & Medicaid Services (CMS)

**Official source:**  
https://data.cms.gov/provider-data/dataset/xubh-q36u

**Dataset identifier:** `xubh-q36u`

**Records in project snapshot:** 5,435

**SQLite table:** `Hospital_General_Information`

**Description:**

Contains hospital characteristics and publicly reported performance information, including facility identifiers, geographic locations, ownership categories, hospital types, emergency services, and overall CMS star ratings.

#### Dataset 2: Unplanned Hospital Visits — State

**Publisher:** Centers for Medicare & Medicaid Services (CMS)

**Official source:**  
https://data.cms.gov/provider-data/dataset/4gkm-5ypv

**Dataset identifier:** `4gkm-5ypv`

**Records in project snapshot:** 784

**SQLite table:** `Unplanned_Hospital_Visits-State`

**Description:**

Contains state-level information for selected CMS hospital performance measures.

The investigated dataset includes 14 measures across 56 geographic codes.

Each record represents a specific geographic code and performance measure.

---

### 3. Dataset Version Information

The project uses preserved CMS CSV files that are strongly consistent with the November 12, 2026 public data release.

| Metadata | Hospital General Information | Unplanned Hospital Visits — State |
|---|---|---|
| CMS dataset ID | xubh-q36u | 4gkm-5ypv |
| CMS release date | November 12, 2026 | November 12, 2026 |
| CMS last modified | October 26, 2026 | October 20, 2026 |
| Records analyzed | 5,435 | 784 |
| Source columns | 38 | 14 |
| Original filename | Hospital_General_Information_2.csv | Unplanned_Hospital_Visits-State.csv |
| Original download date | Not independently confirmed | Not independently confirmed |
| Measurement period | Varies by underlying quality measure | Measure-specific; see below |

The preserved files were inspected directly. Their structure, record counts, and selected contents are consistent with the published CMS release.

An exact byte-for-byte comparison against the official archived downloads has not been performed.

#### State-Level Measurement Periods

The state-level CSV contains explicit Start Date and End Date columns.

| Measures | Start Date | End Date |
|---|---|---|
| OP_35_ADM, OP_35_ED, OP_36 | 2024-01-01 | 2024-12-31 |
| OP_32 | 2022-01-01 | 2024-12-31 |
| EDAC_30_AMI, EDAC_30_HF, EDAC_30_PN | 2022-07-01 | 2025-06-30 |
| READM_30_AMI, READM_30_CABG, READM_30_COPD, READM_30_HF, READM_30_HIP_KNEE, READM_30_PN | 2023-07-01 | 2025-06-30 |
| Hybrid_HWR | 2024-07-01 | 2025-06-30 |

These periods were verified directly against the original CSV.

The OP_35_ADM and OP_35_ED findings therefore describe the January–December 2024 measurement period.

The Hospital General Information CSV does not provide one universal measurement period for its overall star ratings. Reporting periods vary across the underlying CMS quality measures.

#### Data Import Considerations

The source CSV files were imported into SQLite using DB Browser for SQLite.

The analysis uses these database table names:

- `Hospital_General_Information`
- `Unplanned_Hospital_Visits-State`

Facility ID must be preserved as text because the source contains leading-zero identifiers.

The corrected database was created with automatic data-type detection disabled. Facility IDs and ZIP codes were verified as text, and the analytical results were reproduced successfully

The verified SQLite database was reconstructed with automatic data-type detection disabled during CSV import. Validation confirmed that all Facility ID and ZIP Code values are stored as text. The source record counts and principal analytical findings were reproduced successfully

### 4. Dataset 1 — Selected Data Dictionary

The following columns were used in the analysis.

| Column | Description | Analytical Use |
|---|---|---|
| Facility ID | Unique hospital identifier | Duplicate checks and facility identification |
| Facility Name | Hospital name | Facility description |
| State | Geographic code | Geographic analysis and JOIN operations |
| Hospital Type | Hospital classification | Hospital-type comparisons |
| Hospital Ownership | Ownership category | Ownership analysis |
| Hospital overall rating | Published CMS overall rating | Performance analysis |
| Emergency Services | Reported emergency-service availability | Hospital characteristics |

**Identifier:** `Facility ID`

All 5,435 hospital records had unique Facility IDs.

Repeated hospital names were identified, confirming that Facility Name should not be used as a unique identifier.

Facility IDs should be handled as text to preserve any leading zeros.

---

### 5. Dataset 2 — Selected Data Dictionary

| Column | Description |
|---|---|
| State | Geographic code |
| Measure ID | Unique identifier of a CMS performance measure |
| Measure Name | Description of the performance measure |
| Number of Hospitals Worse | Number of hospitals classified as worse for the measure |
| Number of Hospitals Better | Number of hospitals classified as better |
| Number of Hospitals Same | Number of hospitals in the corresponding same/no-difference category |
| Number of Hospitals TOO Few | Reported count associated with insufficient data |

**Record identifier:** Combination of `State` and `Measure ID`.

The analysis identified no duplicate combinations.

**Data structure:** 56 geographic codes × 14 measures = 784 records.

The data contains aggregated hospital classifications, not patient-level records or individual hospital outcomes.

The precise interpretation of each classification depends on CMS measure methodology.

---

### 6. Cleaned SQL Views

Two reusable views were created using SQLite.

#### View 1: `clean_hospital_ratings`

**Source table:** `Hospital_General_Information`

**Transformation:**

The original hospital rating was converted into an additional numerical column:

`cleaned_rating`

Values marked `Not Available` were represented as SQL `NULL`.

Valid published ratings were converted to integers.

**Records preserved:** 5,435.

#### View 2: `clean_unplanned_visits_state`

**Source table:** `Unplanned_Hospital_Visits-State`

**Transformations:**

Four cleaned numerical columns were created:

- `cleaned_hospitals_worse`
- `cleaned_hospitals_better`
- `cleaned_hospitals_same`
- `cleaned_hospitals_too_few`

Reporting placeholders were converted into SQL `NULL` for numerical analysis.

Valid numerical values, including zero, were preserved.

**Records preserved:** 784.

**Important:** SQL views do not create independent copies of the cleaned records. They apply the defined transformations when queried.

---

### 7. Relationships Between Datasets

Both datasets contain the `State` column.

This allows geographic-level relationships to be investigated.

However, the datasets have different levels of granularity:

**Hospital General Information:** One record per hospital.

**Unplanned Hospital Visits — State:** One record per state and measure.

Joining the datasets on State alone can multiply hospital rows because several performance measures exist for each geographic area.

To prevent this, relevant JOIN operations were restricted to individual measures and validated using unique hospital identifiers.

The validated OP_35_ADM JOIN contained:

| Metric | Result |
|---|---:|
| Joined rows | 5,435 |
| Unique hospital identifiers | 5,435 |
| Excess rows | 0 |

State-level performance values remain aggregated measures and cannot be attributed to individual hospital records.

---

### 8. Missing Values and Reporting Limitations

The investigation identified:

**Hospital ratings:**

- Available: 3,166.
- Unavailable: 2,269.

**State-level `Number of Hospitals Worse`:**

- Numerical observations: 208.
- `Not Available`: 408.
- `Not Applicable`: 168.

Missing and inapplicable values must not be treated as observed zeros.

Additionally, unavailable overall ratings may reflect CMS reporting and eligibility requirements.

---

### 9. Data Storage and Reproduction

The original CSV files are stored in:

`data/raw/`

The SQL scripts are stored in:

`sql/`

The database was developed using SQLite and DB Browser for SQLite.

To reproduce the analysis:

1. Import the original CSV files into a SQLite database.
2. Preserve the original column names.
3. Use the SQLite table names documented above.
4. Execute data-exploration 01_data_exploration.sql
5. Execute the data-quality script.
6. Execute the cleaning script to create the views.
7. Execute exploratory, performance, and advanced SQL scripts.
8. Validate the resulting measurements against the documented findings.

The cleaned views depend on the original imported tables.

The import configuration was verified during the final database reconstruction. Exact identity with the official archived CMS files has not been independently confirmed.

---

### 10. Limitations

The datasets are publicly reported administrative and quality-measure data.

They are not equivalent to patient-level clinical records.

The analysis does not independently verify the clinical events underlying CMS classifications.

Differences in reporting eligibility, measure definitions, and measurement periods may affect comparisons.

The datasets should not be used to establish causal relationships between hospital characteristics and clinical outcomes without further investigation.

---

### 11. Official References

**CMS Hospital General Information**  
https://data.cms.gov/provider-data/dataset/xubh-q36u

**CMS Unplanned Hospital Visits — State**  
https://data.cms.gov/provider-data/dataset/4gkm-5ypv

**CMS Hospital Data Collection Periods**  
https://data.cms.gov/provider-data/topics/hospitals/measures-and-current-data-collection-periods

**CMS Hospital Data Dictionary**  
https://data.cms.gov/provider-data/sites/default/files/data_dictionaries/hospital/HOSPITAL_Data_Dictionary.pdf

---

Documentation status: Database reconstruction, SQL execution, and principal analytical findings verified. Exact archived CMS file identity remains unconfirmed.