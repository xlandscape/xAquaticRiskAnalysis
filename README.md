# xAquaticRiskAnalysis

Standalone analysis and reporting web interface for xAquaticRisk simulations.

**xcopy-ready**: Copy the folder to any Windows machine and run `start.bat` — no installation or dependencies required.

## Quick Start

### Prerequisites

- Windows 7 SP1 or later (any Windows that supports Python 3.9)
- Completed xAquaticRisk simulation run(s) in a `run/` folder

### 1. Download or Clone

**Option A: Released ZIP (end users)**
```
Unzip xAquaticRiskAnalysis.zip to any folder
→ Includes everything: analysis scripts, bundled Python, UI
→ No setup needed
```

**Option B: Clone from GitHub (developers)**
```powershell
git clone https://github.com/xlandscape/xAquaticRiskAnalysis.git
cd xAquaticRiskAnalysis
```

### 2. Setup (developers only — end users skip this)

```powershell
# Create embedded Python runtime and install all dependencies
# This makes your folder xcopy-ready (~5-10 min, one-time only)
.\setup_all.bat
```

This step:
- Downloads Python 3.9 (embeddable, no installation)
- Installs analysis packages (h5py, pandas, geopandas, matplotlib, etc.)
- Validates everything works
- After this, your folder can be ZIP'd and shared without further setup

### 3. Configure Run Directory

Set `XAQ_RUN_DIR` to point to your xAquaticRisk `run/` folder:

```powershell
# Temporary (this session only)
set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run

# Permanent (Windows Control Panel → Environment Variables)
# Or: [Environment]::SetEnvironmentVariable("XAQ_RUN_DIR", "C:\path\to\xAquaticRisk\run", "User")
```

### 4. Start the Server

```powershell
# From xAquaticRiskAnalysis folder:
.\start.bat
```

Open `http://localhost:8091` in your browser.

---

## For Developers: Integration Workflow

If you're integrating analysis payload from xAquaticRisk (e.g., after pulling changes):

```powershell
# 1) Copy analysis payload
./scripts/integrate_analysis_payload.ps1 -SourceRepo "C:\LocalWork\xAquaticRisk"

# 2) Optional: update bundled Python
./setup_analysis_python.bat

# 3) Validate everything
./scripts/validate_analysis_payload.ps1
```

---

## Architecture

```
xAquaticRiskAnalysis/
├── start.bat                    ← Launch the server (auto-detects bundled Python)
├── setup_all.bat                ← One-time setup (creates bundled runtime)
├── setup_analysis_python.bat    ← Rebuild Python runtime if needed
├── server.py                    ← HTTP server (port 8091)
├── index.html                   ← Web UI (analysis + map explorer)
├── analysis/
│   ├── run_basic_analysis.py   ← Analysis engine
│   ├── basic_analysis_common.py ← Shared utilities
│   ├── requirements.txt         ← Package list for setup
│   ├── python/                  ← Bundled Python (created by setup)
│   └── ...
└── scripts/
    ├── integrate_analysis_payload.ps1    ← Copy from xAquaticRisk
    └── validate_analysis_payload.ps1     ← Verify installation
```

---

## Environment Variables

| Variable       | Purpose | Example |
|---|---|---|
| `XAQ_RUN_DIR`  | Path to shared `run/` folder | `C:\LocalWork\xAquaticRisk\run` |
| `XAQ_PORT`     | Server port (optional) | `8091` (default) |

---

## Features

- **Analysis**: Run PEC and GUTS-RA analyses on simulations
- **Map Explorer**: View reach/LULC geometries and timeseries
- **Output Download**: Export results as Excel/CSV/PNG
- **Multi-user**: Share run folder with xAquaticRisk prep server (separate ports)

---

## Troubleshooting

**Server won't start**
- Verify `XAQ_RUN_DIR` is set and points to an existing folder
- Check port 8091 isn't in use: `netstat -ano | findstr :8091`
- Try custom port: `start.bat 9000`

**Python/package errors**
- Delete `analysis\python\` and re-run `setup_analysis_python.bat`
- Or use system Python if setup fails: `python server.py --run-dir C:\...`

**Analysis jobs fail**
- Check `analysis_output/` folder for error logs
- Ensure run folder contains completed xAquaticRisk outputs (hydro.h5, etc.)

---

## Development

- **Python**: 3.9.7 (embeddable runtime)
- **Dependencies**: See `analysis/requirements.txt`
- **License**: As per xlandscape organization terms

For questions or issues, contact the xlandscape development team.
