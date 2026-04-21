# README - xAquaticRiskAnalysis

Standalone web server for analysis workflows, map exploration, and timeseries queries for xAquaticRisk simulations.

## Quick Start

### Prerequisites
- Python 3.9+ (bundled `analysis/python/` optional for xcopy portability)
- xAquaticRisk run folder with completed simulations

### Launch

**Windows (recommended):**
```bash
set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
start.bat
```

**Python directly:**
```bash
python server.py --run-dir C:\LocalWork\xAquaticRisk\run
```

**Custom port:**
```bash
python server.py --port 9000 --run-dir C:\path\to\run\folder
```

### Environment Variables
- `XAQ_RUN_DIR`: Path to the shared `run/` folder (required unless `--run-dir` argument provided)
- `XAQ_PORT`: Server port (defaults to 8091)
- `XAQ_ANALYSIS_MODE`: `"local"` (default, uses embedded Python) or `"remote"` (not yet implemented)

## Architecture

The analysis server:
1. **Discovers** completed xAquaticRisk experiments from the shared `run/` folder
2. **Launches** `analysis/run_basic_analysis.py` in subprocess for selected MC runs
3. **Serves** analysis outputs and live preview via HTTP + JSON APIs
4. **Hosts** interactive map explorer for reach geometries and timeseries

Routes are read-only for run monitoring; write operations (abort, delete) are disabled on the analysis server.

## Deployment

### Self-Contained (xcopy-ready)
Copy the entire `xAquaticRiskAnalysis/` folder to any Windows machine with Python 3.9+.
The bundled `analysis/python/` runtime ensures portability.

### Docker (optional future)
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
ENV XAQ_PORT=8091
CMD ["python", "server.py", "--run-dir", "/data/run"]
```

## API Endpoints

See `server.py` docstring for full endpoint list.

Analysis-specific:
- `GET /api/analysis/runs` – List experiments with MC folders
- `POST /api/analysis/start` – Launch analysis workflow
- `GET /api/analysis/status/<job_id>` – Poll job status
- `GET /api/analysis/outputs/<job_id>` – List output files

## License

Same as xAquaticRisk parent project.
