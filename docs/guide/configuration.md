# Configuration

xAquaticRiskAnalysis is configured through environment variables and command-line arguments.

## Environment Variables

### XAQ_RUN_DIR

**Purpose:** Path to the xAquaticRisk simulation `run/` folder

**Type:** Absolute file path

**Default:** `C:\` (when using `start.bat`)

**Example:**
```batch
set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
```

xAquaticRiskAnalysis reads this folder to discover simulation experiments and Monte Carlo runs. The same folder is passed to analysis jobs when started.

### XAQ_PORT

**Purpose:** HTTP server listen port

**Type:** Integer (1–65535)

**Default:** `8091`

**Example:**
```batch
set XAQ_PORT=9000
start.bat
```

Use this to run multiple instances on the same machine or if port 8091 is already in use.

!!! note
    xAquaticRisk prep server defaults to port **8090**, so xARA defaults to **8091** to avoid conflicts.

### XAQ_ANALYSIS_MODE

**Purpose:** Analysis execution mode (reserved for future use)

**Type:** `local` (only supported value)

**Default:** `local`

Currently, all analysis runs locally as subprocesses. Remote analysis services are not yet implemented.

## Command-Line Arguments

Arguments passed to `server.py` override environment variables:

| Argument | Equivalent Env Var | Description |
|----------|-------------------|-------------|
| `--port <n>` | `XAQ_PORT` | Server port |
| `--run-dir <path>` | `XAQ_RUN_DIR` | Run folder path |

**Example:**
```batch
python server.py --port 9000 --run-dir C:\LocalWork\xAquaticRisk\run
```

## Start Method Comparison

| Method | Auto-bootstrap | Port Config | Run Dir Required |
|--------|----------------|-------------|------------------|
| `start.bat` | ✓ Yes | `XAQ_PORT` env var | `XAQ_RUN_DIR` env var (defaults to `C:\`) |
| `python server.py --run-dir <path>` | ✗ No | `XAQ_PORT` env var or `--port` | Required |

For most users, `start.bat` is recommended because it:
- Auto-repairs embedded Python runtime on first run
- Uses sensible defaults for run directory
- Requires no manual dependency installation
