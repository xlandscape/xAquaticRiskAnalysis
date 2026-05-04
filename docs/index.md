# Welcome to xAquaticRiskAnalysis

**xAquaticRiskAnalysis** (xARA) is a standalone web application for exploring and analysing the outputs of [xAquaticRisk](https://xlandscape.github.io/xAquaticRisk/) simulation runs.

## What it does

After xAquaticRisk has completed one or more Monte Carlo simulation runs, xARA provides:

- **Analysis workflows** — launch `run_basic_analysis.py` for a selected MC run to compute PEC metrics and GUTS risk indicators; monitor progress and download output tables and figures directly from the browser
- **Map explorer** — visualise reach geometries and spray-drift timeseries for any experiment and MC run on an interactive map
- **Run browser** — list all experiments and MC folders in the shared `run/` folder without opening xAquaticRisk itself

## Relationship to xAquaticRisk

xARA is intentionally **separate** from the xAquaticRisk prep-and-run control panel. The two applications share only a single folder on disk — the `run/` folder that xAquaticRisk writes simulation output into — and communicate that location through the [`XAQ_RUN_DIR`](reference/configuration.md#xaq_run_dir) environment variable.

```text
xAquaticRisk (port 8090)          xAquaticRiskAnalysis (port 8091)
  ├── controlpanel/                  ├── server.py
  ├── run/  ◄────────────────────────────── XAQ_RUN_DIR
  └── scenario/                      ├── analysis/
                                     └── start.bat
```

This separation means:

- xARA can be deployed on a **different machine** from the one running simulations, as long as the `run/` folder is accessible (e.g., via a network share).
- Analysts can use xARA **without access** to the xAquaticRisk parameterisation or model binaries.
- Updates to the analysis tooling do not require touching the simulation server.

## Quick start

Published documentation entry point: [https://xlandscape.github.io/xAquaticRiskAnalysis/index.html](https://xlandscape.github.io/xAquaticRiskAnalysis/index.html)

See [Get Started](getstarted/getstarted.md) for installation and launch instructions.  
See [Configuration](reference/configuration.md) for all environment variables and command-line options, including [`XAQ_RUN_DIR`](reference/configuration.md#xaq_run_dir).
