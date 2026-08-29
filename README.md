# HR Attrition & Workforce Analytics

End-to-end HR analytics project covering the full workflow of a real analyst task: messy employee data → Excel exploration → Python cleaning → SQL analysis → Power BI dashboard.

---

## Problem Statement

Employee attrition is expensive — every employee who leaves costs a company in lost productivity, recruitment, and training. The business question this project answers:

> **"Why are employees leaving, and which employee segments are at the highest risk of attrition?"**

Specifically, the goal was to identify:
- Which departments and job roles have the highest attrition
- Whether overtime, tenure, or compensation are linked to employees leaving
- Whether attrition is concentrated in specific managers or teams
- What HR could act on to reduce attrition going forward

## Dataset

- **Source:** Synthetic employee-level HR dataset (1,500+ rows, 29 columns), built to mirror the data quality issues found in real HR systems.
- **Fields:** demographic info (age, gender, marital status, DOB), job info (department, job role, hire date, tenure, manager), compensation (monthly salary, hourly rate, overtime), satisfaction survey scores (job satisfaction, environment satisfaction, work-life balance), and attrition status with reason for leaving.
- **Known data issues (intentional, to simulate a real messy HR export):**
  - Inconsistent casing across categorical fields (`Male`/`M`/`m`, `Yes`/`yes`/`Y`)
  - Mixed date formats across `DOB`, `hire_date`, and `exit_date`
  - Invalid values — negative/zero ages, a performance rating outside its valid 1–5 scale, a negative salary
  - Heavy missing values in subjective survey fields (job satisfaction, environment satisfaction, work-life balance) — realistic, since employees often skip survey questions
  - Duplicate rows and duplicate `employee_id`s with conflicting data

## Tools Used

`Excel` · `Python (Pandas, NumPy)` · `SQL` · `Power BI`

## Process

**1. Excel — initial exploration**
- Used `TRIM()` and `PROPER()` to fix spacing/casing issues
- Used Conditional Formatting to visually flag invalid ages, performance ratings, and negative salaries
- Built a quick pivot table (Attrition Count by Department) to sanity-check the data before deeper cleaning

**2. Python — data cleaning**
- Standardized categorical fields (gender, marital status, overtime, business travel) to consistent values
- Parsed multiple mixed date formats correctly using per-row format inference (avoided the common pandas pitfall of guessing one format for an entire column)
- Applied **grouped imputation** for recoverable missing values — e.g., missing salary filled using the median salary for that job role, not a blanket average
- **Deliberately left survey-based fields (job satisfaction, environment satisfaction, work-life balance) as null where missing**, rather than fabricating values — added a flag column instead, since guessing subjective survey responses would have corrupted the analysis
- Removed exact duplicate rows; flagged (not blindly deleted) duplicate `employee_id`s for manual review
- Engineered new features — `age_group` and `tenure_group` buckets — to support cleaner segmentation in the dashboard

**3. SQL — analysis**
- Loaded cleaned data and wrote queries to calculate: overall attrition rate, attrition rate by department, average tenure of leavers vs. stayers, attrition by overtime status, salary comparison by department and attrition status, and manager-level attrition patterns
- See [`sql/queries.sql`](sql/queries.sql)

**4. Power BI — dashboard**
- KPIs: Total Employees, Attrition Rate %, Average Tenure, Average Monthly Salary, Average Satisfaction Score
- Visuals: attrition rate by department (bar), attrition by age group (bar), hires vs. exits by year (line), attrition by overtime status (stacked bar), attrition split by gender among leavers only (donut), salary vs. job satisfaction (scatter, one point per employee)
- Filters: Department, Job Role, Gender, Age Group, Tenure Group, Overtime

## What I Solved / Key Insights

- **Overall attrition rate is 17.6%** — a healthy benchmark for most industries sits around 10–15%, so this is elevated enough to warrant investigation, but not a crisis-level number.
- **Finance and Marketing show the highest departmental attrition (~19–20%)**, notably higher than IT and Human Resources (~14–16%), pointing to department-specific retention issues rather than a company-wide problem.
- **Employees with overtime show a visibly higher attrition rate** than those without — supporting the well-documented link between overtime workload and voluntary attrition.
- **Attrition is roughly evenly split by gender**, ruling out gender-specific attrition drivers in this dataset.
- **Salary vs. job satisfaction analysis** shows attrition isn't purely a compensation issue — several leavers had mid-to-high salaries but low satisfaction scores, suggesting non-monetary factors (workload, management, growth) play a meaningful role.

## Recommendation

Prioritize a retention review in Finance and Marketing specifically, with a focus on overtime workload — since overtime employees show disproportionately higher attrition, reducing excessive overtime or improving overtime compensation could meaningfully lower attrition in the highest-risk segments, rather than relying on blanket salary increases.

## Repository Structure

```
hr-attrition-analytics/
├── README.md
├── data/
│   ├── hr_attrition_raw.xlsx
│   └── hr_attrition_clean.csv
├── excel/
│   └── excel_cleaning_notes.xlsx
├── python/
│   └── hr_cleaning_and_eda.ipynb
├── sql/
│   └── queries.sql
└── dashboard/
    ├── HR_Attrition_Dashboard.pbix
    └── screenshots/
        └── dashboard_overview.png
```

## Known Limitations / Next Steps

- `manager_name` was reassigned from a small fixed pool per department to enable meaningful grouping, since the original data had a near-unique manager per employee — a real dataset would already have this structure correctly.
- Next iteration: bring in exit interview text data (if available) to combine structured attrition analysis with qualitative reasons for leaving.
- Next iteration: build a simple attrition risk score combining tenure, overtime, and satisfaction into a single weighted indicator per employee.
