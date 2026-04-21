# Configuration Reference

xAquaticRiskAnalysis is configured through **environment variables** and **command-line arguments**. Environment variables are read at startup; command-line arguments override their corresponding environment variable where both exist.

---

## Environment Variables

### `XAQ_RUN_DIR`

| | |
|---|---|
| **Required** | Yes — unless `--run-dir` is supplied on the command line |
| **Type** | Absolute path (string) |
| **Example** | `C:\LocalWork\xAquaticRisk\run` |

The path to the `run/` folder that xAquaticRisk writes simulation output into.  
xAquaticRiskAnalysis reads this folder to discover experiments and MC runs, and passes the path to `run_basic_analysis.py` when a job is started.

**Why a separate variable?**  
xAquaticRiskAnalysis is an independent application — it has no knowledge of where xAquaticRisk is installed on your machine. `XAQ_RUN_DIR` is the single configuration point that connects the two. This allows xARA to be deployed on a different machine or directory from xAquaticRisk, as long as the `run/` folder is reachable (e.g., via a network share).

**Setting it for a single session (Command Prompt):**

```bat
set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
start.bat
```

**Setting it permanently (Windows user environment):**

1. Open *Start → "Edit environment variables for your account"*
2. Click **New**
3. Name: `XAQ_RUN_DIR`  
   Value: `C:\LocalWork\xAquaticRisk\run` (adjust to your actual path)
4. Click **OK** and restart any open terminals

**What happens if it is not set:**  
`start.bat` validates the variable before launching the server. If `XAQ_RUN_DIR` is empty or not defined, the script prints an error message and exits with code 1, preventing a silently broken UI.

```
ERROR: XAQ_RUN_DIR is not set.
Set it to the path of the xAquaticRisk run/ folder before launching.
Example:  set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
```

---

### `XAQ_PORT`

| | |
|---|---|
| **Required** | No |
| **Default** | `8091` |
| **Type** | Integer (1–65535) |
| **Example** | `9000` |

The TCP port the HTTP server listens on.  
Change this if port 8091 is already in use or if you want to run multiple xARA instances side by side.

```bat
set XAQ_PORT=9000
start.bat
```

!!! note "Port separation from xAquaticRisk"
    The xAquaticRisk prep server uses port **8090** by default (controlled by its own `XAQ_PORT`).  
    xAquaticRiskAnalysis defaults to **8091** so both servers can run simultaneously without conflict.

---

### `XAQ_ANALYSIS_MODE`

| | |
|---|---|
| **Required** | No |
| **Default** | `local` |
| **Allowed values** | `local` |

Controls whether analysis jobs are run locally (subprocess) or delegated to a remote service.  
Currently only `local` is implemented. Setting this to `remote` returns a `501 Not Implemented` response from the `/api/analysis/start` endpoint.

---

## Command-Line Arguments

Command-line arguments are passed to `server.py` and take precedence over the corresponding environment variable.

| Argument | Env variable equivalent | Description |
|---|---|---|
| `--run-dir <path>` | `XAQ_RUN_DIR` | Path to the xAquaticRisk `run/` folder |
| `--port <n>` | `XAQ_PORT` | TCP port to listen on |

**Example — launch without environment variables:**

```bat
python server.py --run-dir C:\LocalWork\xAquaticRisk\run --port 9000
```

---

## Summary Table

| Variable / Argument | Default | Required | Purpose |
|---|---|---|---|
| `XAQ_RUN_DIR` / `--run-dir` | *(none)* | **Yes** | Path to shared `run/` folder |
| `XAQ_PORT` / `--port` | `8091` | No | HTTP server port |
| `XAQ_ANALYSIS_MODE` | `local` | No | Analysis execution mode |
