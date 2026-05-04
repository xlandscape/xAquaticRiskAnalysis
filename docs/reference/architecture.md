# Architecture

xAquaticRiskAnalysis is a standalone web application for analyzing aquatic risk assessment simulations from xAquaticRisk.

## High-Level Design

```
┌─────────────────────────────────────────────────────────┐
│  Web Browser (http://localhost:8091)                    │
│  ├─ Analysis Tab (run/download PEC-GUTS analyses)      │
│  └─ Map Explorer Tab (explore reaches & timeseries)    │
└────────────────┬────────────────────────────────────────┘
                 │ HTTP
┌────────────────▼────────────────────────────────────────┐
│  Python HTTP Server (server.py)                         │
│  ├─ Static routes: /index.html, /api/*                 │
│  ├─ Analysis routes: /api/analysis/start, /status      │
│  └─ Map routes: /api/map-explorer/* (geometry, TS)     │
└────────────────┬────────────────────────────────────────┘
                 │
        ┌────────┼────────┐
        │                 │
        ▼                 ▼
    Run Folder      Analysis Runtime
    (shared)        (embedded Python)
    ├─ Exp1/        ├─ run_basic_analysis.py
    ├─ Exp2/        ├─ Dependencies
    └─ ...          │  (h5py, pandas, geopandas)
                    └─ analysis_output/
```

## Components

### 1. Web UI (index.html)

- Single-page JavaScript application
- Tabs for Analysis and Map Explorer
- Real-time log streaming for job progress
- Download manager for output files

Built with vanilla JS; no external framework required for lightweight distribution.

### 2. HTTP Server (server.py)

Python 3.12 application providing:

- Static file serving (HTML, CSS, JS)
- Run discovery and metadata endpoints
- Analysis job queue and execution
- Map geometry and timeseries data endpoints
- File download/upload

Runs on port 8091 by default (configurable via `XAQ_PORT`).

### 3. Embedded Python Runtime

Located at `analysis/python/`:

- Python 3.12.10 (embeddable distribution)
- Site-packages with analysis dependencies:
  - **h5py** – Read xAquaticRisk HDF5 outputs
  - **pandas** – Data manipulation
  - **geopandas** – Spatial geometry (reach networks, LULC)
  - **matplotlib, seaborn** – Figure generation
  - **openpyxl** – Excel output

Packaged with the repository for zero-install deployment.

### 4. Shared Run Folder

xAquaticRiskAnalysis and xAquaticRisk controlpanel both read from `XAQ_RUN_DIR`:

```
run/
├── Experiment1/
│   ├── ExperimentDescription.xml
│   ├── mc_store_1/
│   │   └── (HDF5 outputs from xAquaticRisk)
│   └── mc_store_2/
├── Experiment2/
│   └── ...
```

This folder-sharing architecture allows:
- Both applications to run simultaneously
- Real-time access to simulation outputs
- No data copying between applications

## Workflow: Running an Analysis

```
1. User clicks "Start Analysis" in Web UI
   ↓
2. server.py spawns subprocess:
   analysis/python/python.exe run_basic_analysis.py <params>
   ↓
3. Analysis script:
   - Reads HDF5 simulation data
   - Performs PEC/risk calculations
   - Generates figures (PNG) and tables (Excel)
   ↓
4. Outputs written to analysis_output/<job_id>/
   ↓
5. Web UI polls /api/analysis/status/<job_id>
   ↓
6. When done, user downloads files via browser
```

## Technology Stack

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| UI | HTML/CSS/JS | Lightweight; works in any browser; no build required |
| Server | Python 3.12 | Fast development; rich scientific ecosystem |
| Theme | Material (mkdocs) | Professional; responsive; accessibility-focused |
| Data | HDF5 | Efficient storage; xAquaticRisk native format |
| Output | PNG, Excel, CSV | Universal; easy to share and archive |

## Deployment

### Single-User Desktop

Standard use case:

```batch
set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
start.bat
```

Server listens on `http://localhost:8091` (localhost only).

### Shared Server (Multi-User, LAN)

For organizations:

1. Run server on shared Windows machine
2. Configure firewall to allow port 8091 on LAN
3. Users access via `http://<server-ip>:8091`
4. Use `XAQ_RUN_DIR` pointing to shared network folder

Server has no built-in authentication; rely on network access controls.

## Limitations & Future Work

**Current Limitations:**
- Single-instance only (one job at a time; queuing not implemented)
- No user authentication/authorization
- No persistent job history (outputs cleared when server restarts)

**Planned Features:**
- Job queue for parallel analysis submissions
- User authentication (Windows integrated auth or local accounts)
- Job history and results archive
- Remote analysis service (delegate to HPC cluster)
