# Data Cleaning Methodology

## Healthcare SQL Analytics — Project 1

### 1. Objective

The objective of the data-cleaning process was to prepare two publicly available CMS datasets for reliable SQL analysis while preserving their original information.

The datasets included:

- **Hospital General Information:** 5,435 hospital records.
- **Unplanned Hospital Visits by State:** 784 state-level performance records.

All cleaning operations were performed using SQLite.

### 2. Cleaning Approach

The project followed a conservative cleaning strategy:

- Preserve the original CMS datasets.
- Investigate missing and unavailable values.
- Check for duplicate identifiers.
- Examine categorical inconsistencies.
- Convert valid numerical values into appropriate data types.
- Validate cleaned results against the original data.

Rather than modifying the original tables, reusable SQL views were created.

### 3. Duplicate Investigation

Duplicate checks were performed using the appropriate identifiers for each dataset.

**Hospital General Information**

The `Facility ID` column was examined for duplicate identifiers.

Result: **0 duplicate Facility IDs identified.**

**Unplanned Hospital Visits by State**

The combination of `State` and `Measure ID` was examined for duplicate records.

Result: **0 duplicate State + Measure ID combinations identified.**

No records were removed during cleaning.

### 4. Categorical Data Investigation

Hospital type and ownership categories were investigated for leading and trailing spaces.

The investigated fields contained no values requiring whitespace standardization.

**Decision:** Preserve the existing category values rather than applying unnecessary transformations.

### 5. Hospital Rating Cleaning

The original `Hospital overall rating` column contained numeric-looking ratings and the reporting placeholder `Not Available`.

A reusable view named `clean_hospital_ratings` was created.

The cleaning process:

- Converted `Not Available` into SQL `NULL` in a new column.
- Converted available ratings into integers.
- Preserved the original rating column.
- Retained all hospital records.

The new numerical column was named `cleaned_rating`.

**Validation results:**

| Indicator | Result |
|---|---:|
| Total hospital records | 5,435 |
| Available numerical ratings | 3,166 |
| Unavailable ratings | 2,269 |
| Ratings outside the 1–5 range | 0 |
| Identified conversion mismatches | 0 |

The cleaned view preserved all 5,435 hospital records.

### 6. State-Level Performance Data Cleaning

A second SQL view, `clean_unplanned_visits_state`, was created.

Four numerical fields were cleaned:

- Number of Hospitals Worse.
- Number of Hospitals Better.
- Number of Hospitals Same.
- Number of Hospitals TOO Few.

The reporting placeholders `Not Available` and `Not Applicable` were converted into SQL `NULL` in the cleaned numerical fields.

Available numeric-looking values were converted into integers.

**Important:** Numerical zeros were preserved because zero is a valid reported count and must not be treated as missing data.

The original source table was retained, preserving the distinction between `Not Available` and `Not Applicable`.

### 7. Validation of State-Level Data

For the cleaned `Number of Hospitals Worse` field:

| Indicator | Result |
|---|---:|
| Total records | 784 |
| Available numerical observations | 208 |
| NULL observations | 576 |

The cleaned view preserved all 784 source records.

Additional SQL checks compared the cleaned values with numerical conversions from their corresponding original columns.

These checks returned zero identified conversion mismatches for the four investigated numerical fields.

A separate validation of `Number of Hospitals Worse` also found zero unexpected values outside the known placeholders and expected nonnegative integer format.

### 8. Limitations

The cleaning process improved numerical usability but did not resolve every analytical limitation.

Converting reporting placeholders to `NULL` does not explain why values were unavailable or inapplicable.

Furthermore, numerical-conversion checks do not independently establish that every CMS measurement is clinically valid.

The cleaning process did not attempt to estimate or replace unavailable ratings.

CMS reporting eligibility and measure definitions must be considered when interpreting the cleaned data.

### 9. Conclusion

The data-cleaning process produced two reusable SQL views while preserving the original CMS datasets.

The approach prioritized data integrity, traceability, and validation rather than unnecessary modification.

These views provided the foundation for exploratory analysis, hospital performance comparisons, and advanced SQL investigations.

**Supporting SQL script:** 03_data_cleaning.sql

Reproducibility status: All six SQL scripts were successfully executed against a fresh SQLite database reconstructed from the preserved CMS CSV files