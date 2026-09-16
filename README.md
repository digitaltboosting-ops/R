![Uploading image.png…]()
# R
Showcasing R and Reg Ex for data processing
# README.md — Operational KPI Pipeline (Logistics Data)

## Executive Summary
This project demonstrates how a logistics company can transform inconsistent operational data into reliable KPIs and predictive insights. Using a synthetic dataset (2–5K rows) that reflects real industry challenges, the pipeline cleans messy shipment records, standardizes key fields, resolves data quality issues, and produces actionable metrics for decision‑makers. The project also includes a simple delay‑prediction model to support proactive operations.

---

## Scope of Work
* Synthetic logistics dataset (2–5K rows)
* Regex‑based cleaning of IDs, dates, weights, currencies, and text fields
* Data validation and quality checks
* KPI generation for operational performance
* Delay‑prediction model (random forest)
* Summary tables and static plots
* Executive‑ready documentation and Google Sites presentation

---

## Tools & Methods
* **R:** `tidyverse`, `lubridate`, `stringr`, `randomForest`
* **Regex:** Normalization of IDs, weights, delay reasons
* **Data Validation:** Missing values, duplicates, timestamp logic
* **Modeling:** Delay classification + feature importance
* **Reporting:** Static plots + structured summary
* **Versioning:** GitHub repository

---

## Industry Problems Addressed (Top 7)
This project resolves seven common operational data issues in logistics:

1. **Inconsistent Data Formats:** Mixed IDs, date formats, weight strings, and currency symbols.
2. **Missing or Invalid Values:** Missing timestamps, negative weights, impossible delivery sequences.
3. **Duplicate or Fragmented Records:** Multiple entries for the same shipment or split data across systems.
4. **Unstandardized KPI Definitions:** Conflicting interpretations of “on‑time delivery” and other metrics.
5. **Poorly Structured Delay Reasons:** Free‑text notes requiring regex normalization for analysis.
6. **Currency & Cost Inconsistencies:** Mixed currencies, symbols, and formatting errors affecting cost KPIs.
7. **Lack of Predictive Insight:** No early warning for high‑risk shipments; reactive operations.

---

## Key Outputs
* Cleaned and validated shipment dataset
* Unified KPI pipeline (on‑time rate, delay drivers, cost metrics)
* Delay‑prediction model with feature importance
* Static visualizations for operational insights
* Executive summary + Google Sites presentation
* Fully reproducible R script (single‑cell)

---

## Business Value
* **Higher Data Trust:** Achieved through automated cleaning
* **Faster Reporting:** Reduced from hours to minutes
* **Clear Visibility:** Into delay drivers and cost patterns
* **Proactive Operations:** Enabled via early risk identification
* **Standardized KPIs:** For management alignment
* **Solid Foundation:** For future automation and AI‑driven routing

---

## Repository Structure
```text
/data
  └── shipments_raw.csv
  └── shipments_clean.csv
/src
  └── pipeline.R (single‑cell script)
/report
  └── summary_plots.png
  └── kpi_tables.csv
README.md
