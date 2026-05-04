# Results & Output

## Analysis Output Files

When an analysis completes, xAquaticRiskAnalysis generates several output files for download:

### Excel Tables (`.xlsx`)

**pecsw_table.json** – Summary table with:
- Reach ID and name
- Mean PEC (water)
- 90th percentile PEC
- Effect ratios for test species (Daphnia, algae, etc.)

These tables are suitable for:
- Risk assessment reports
- Stakeholder presentations
- Integration with other decision-support tools

### Figures (`.png`)

Generated visualizations include:

- **PEC Distribution** – Histogram of predicted environmental concentrations across reaches
- **Fraction Affected** – Stacked bar chart showing proportion of reaches in different risk categories
- **Effects by Species** – Grouped charts showing effect ratios for each test species
- **Timeseries Plots** – PEC or effect dynamics over the simulation period (if applicable)

All figures are publication-quality, 300 DPI PNG files.

### Data Files (`.json`, `.csv`)

Raw analysis output for custom post-processing:

- **Full reach dataset** – Complete analysis results for all reaches
- **Summary statistics** – Aggregated risk metrics
- **Timeseries data** – Reach-level concentrations over time (if applicable)

## File Organization

All outputs for a given job are stored in:
```
analysis_output/<job_id>/
├── pecsw_table.json
├── figures/
│   ├── pec_distribution.png
│   ├── fraction_affected.png
│   └── effects_by_species.png
└── data/
    ├── full_results.json
    └── summary.csv
```

Downloads are temporary for the current session. To preserve results long-term, download files immediately after analysis completes.

## Interpreting Results

### PEC Interpretation

- **PEC (Predicted Environmental Concentration)** – Average concentration of the substance in the water
- **Units** – µg/L (micrograms per liter)
- **Risk Assessment** – Higher PEC → higher hazard; compare against regulatory threshold or hazard quotient

### Effect Ratios

- **Ratio > 1.0** – Predicted concentration exceeds hazard threshold (potential risk)
- **Ratio < 1.0** – Concentration below threshold (acceptable risk)
- **Ratio** – Inverse of the "hazard quotient"; ratios <<1 indicate high safety margins

### Recommended Actions

| Result | Interpretation | Action |
|--------|----------------|--------|
| Most ratios <<1 | Low environmental risk | Document findings; no mitigation needed |
| Some ratios >1 | Moderate risk in certain reaches/species | Consider targeted mitigation in high-risk areas |
| Widespread ratios >1 | Widespread significant risk | Major mitigation or alternative substance needed |

## Sharing Results

xAquaticRiskAnalysis is designed for collaborative risk assessment. You can:

1. **Download files** and share via email or file storage
2. **Run multiple experiments** and compare results side-by-side
3. **Export to standardized formats** (Excel, CSV) for integration with regulatory frameworks

For questions about result interpretation, consult xlandscape documentation or contact the development team.
