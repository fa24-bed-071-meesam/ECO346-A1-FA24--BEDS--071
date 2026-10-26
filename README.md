# ECO346 Assignment 1 — Data Visualization Techniques for Economists

**Student:** Meesam Rizvi  
**Registration number:** FA24-BEDS-071  
**Course:** ECO346, Fall 2026  
**Variant:** 7 — urban Balochistan, Pakistan

## Purpose
This project examines positive annual earnings for people aged 15–64 in urban Balochistan using the provided PSLM 2019–20 subset files. Person and household records are joined by `hhid`; household weights (`hhweight`) are used for weighted summaries.

## Sample rules
The analysis selects `prov_code == 4`, `urban_rural == 2`, ages 15–64 inclusive, positive finite `earn_annual`, and finite positive `hhweight`. Age bands are five-year groups from 15–19 through 60–64. A band is marked thin when it has fewer than 30 unweighted observations. Weighted quantiles are calculated by sorting earnings and choosing the first value whose cumulative weight share reaches the requested probability.

## Main results
- Eligible earners: **486**
- Unweighted median annual earnings: **Rs 264,000**
- Weighted P10: **Rs 96,000**
- Weighted median: **Rs 250,000**
- Weighted P90: **Rs 540,000**
- P90/P10 ratio: **5.62**
- Ages 25–29 weighted mean: **Rs 307,994**
- Ages 45–49 weighted mean: **Rs 372,723**
- Highest mean band: **60-64**, Rs 476,422; this band is thin (interpret cautiously).

The histogram uses log10 earnings bins of width 0.1 between 4 and 7. No eligible earners fall outside that plotting range in this sample.

## Files
- `data/`: source CSV files supplied with the project
- `scripts/01_check_data.R`: sample checks and weighted quantile function
- `scripts/02_q2_histogram.R`: weighted earnings distribution
- `scripts/03_q3_age_profile.R`: age-band table and redesigned figure
- `scripts/04_q4_default.R`: minimal default scatterplot
- `scripts/05_q5_age_profile.py`: Python reproduction for Q5
- `figures/`: SVG figures and summary tables
- `slides/FA24-BEDS-071.pptx`: four-slide presentation

## Reproduction
Run R scripts from this project folder with `ggplot2` installed. Run the Python script with `pandas`, `numpy`, and `matplotlib` installed. CSV inputs should remain in `data/`. The figures in this package were generated from the included source data; the R scripts are provided to reproduce the R-based tasks.

## Interpretation and limitations
The figures describe an observational sample and do not show that age causes earnings to rise. Age bands may differ in occupation, education, hours worked, and other characteristics. The oldest group has a small sample and its mean is less stable. Results apply only to the specified urban Balochistan subset, not all of Pakistan.
