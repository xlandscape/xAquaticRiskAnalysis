# xAquaticRiskAnalysis

Standalone analysis and reporting web interface for xAquaticRisk simulations.

**xcopy-ready**: Copy the folder to any Windows machine and run `start.bat` — no installation or dependencies required.

📖 **[Read Full Documentation](https://xlandscape.github.io/xAquaticRiskAnalysis/index.html)** — Installation, configuration, API reference, and architecture guide.

## Quick Start

### Prerequisites

- **Windows 64-bit** (any version with Python 3.9+)
- A completed xAquaticRisk simulation run

### 1. Download or Clone

**Clone:**

```powershell
git clone https://github.com/xlandscape/xAquaticRiskAnalysis.git
cd xAquaticRiskAnalysis
```

**Or download ZIP** from [xlandscape/xAquaticRiskAnalysis](https://github.com/xlandscape/xAquaticRiskAnalysis)

### 2. Run

```powershell
.\start.bat
```

`start.bat` automatically detects and repairs the embedded Python runtime on first launch. No manual setup required.

### 3. Open Browser

```text
http://localhost:8091
```

## Features

- ✅ **Auto-bootstrap** – Embedded Python runtime self-repairs on first start
- ✅ **Zero-install** – Bundled dependencies; copy-and-go deployment  
- ✅ **Web UI** – Real-time analysis job submission and result download
- ✅ **Map explorer** – Interactive reach and LULC geometry viewer
- ✅ **Publication output** – Excel tables, PNG figures, JSON/CSV data
- ✅ **Multi-user** – Run on shared LAN server for team collaboration

## Configuration

Set your simulation folder:

```powershell
set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
.\start.bat
```

Or set `XAQ_RUN_DIR` permanently in Windows environment variables.

See [Configuration Reference](https://xlandscape.github.io/xAquaticRiskAnalysis/reference/configuration.html) for all options.

## Documentation

- **[Documentation Home](https://xlandscape.github.io/xAquaticRiskAnalysis/index.html)** – Canonical entry point for the published docs
- **[Installation Guide](https://xlandscape.github.io/xAquaticRiskAnalysis/guide/installation.html)** – Setup and first run
- **[User Guide](https://xlandscape.github.io/xAquaticRiskAnalysis/guide/analysis.html)** – Running analyses and downloading results
- **[Reference](https://xlandscape.github.io/xAquaticRiskAnalysis/reference/architecture.html)** – Configuration, API, architecture
- **[About](https://xlandscape.github.io/xAquaticRiskAnalysis/about.html)** – xlandscape framework overview

## For Developers

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

```text
xAquaticRiskAnalysis/
├── start.bat                    ← Launch the server (auto-detects bundled Python)
├── setup_all.bat                ← Rebuild/validate bundled runtime (maintainers)
├── setup_analysis_python.bat    ← Rebuild analysis runtime if needed
├── server.py                    ← HTTP server (port 8091)
├── index.html                   ← Web UI (analysis + map explorer)
├── analysis/
│   ├── run_basic_analysis.py   ← Analysis engine
│   ├── basic_analysis_common.py ← Shared utilities
│   ├── requirements.txt         ← Package list for setup
│   ├── python/                  ← Bundled Python (committed with repo)
│   └── ...
└── scripts/
    ├── integrate_analysis_payload.ps1    ← Copy from xAquaticRisk
    └── validate_analysis_payload.ps1     ← Verify installation
```

---

## Environment Variables

- `XAQ_RUN_DIR`: Path to the shared `run/` folder. Example: `C:\LocalWork\xAquaticRisk\run`
- `XAQ_PORT`: Optional server port override. Example: `8091`

---

## Capabilities

- **Analysis**: Run PEC and GUTS-RA analyses on simulations
- **Map Explorer**: View reach/LULC geometries and timeseries
- **Output Download**: Export results as Excel/CSV/PNG
- **Multi-user**: Share run folder with xAquaticRisk prep server (separate ports)

---

## Troubleshooting

### Server won't start

- Verify `XAQ_RUN_DIR` is set and points to an existing folder
- Check port 8091 isn't in use: `netstat -ano | findstr :8091`
- Try custom port: `start.bat 9000`

### Python/package errors

- Delete `analysis\python\` and re-run `setup_analysis_python.bat`
- Or use system Python if setup fails: `python server.py --run-dir C:\...`

### Analysis jobs fail

- Check `analysis_output/` folder for error logs
- Ensure run folder contains completed xAquaticRisk outputs (hydro.h5, etc.)

---

## Development

- **Python**: 3.12.x (embeddable runtime)
- **Dependencies**: See `analysis/requirements.txt`
- **License**: As per xlandscape organization terms

For questions or issues, contact the xlandscape development team.
