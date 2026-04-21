# Get Started

## Prerequisites

- **Windows 64-bit** (required for the bundled analysis Python runtime)
- **Python 3.9 or later** — only needed if you are *not* using the bundled `analysis/python/` runtime
- A completed xAquaticRisk simulation in a `run/` folder that you have read access to

If the bundled runtime is already present and `start.bat` works, you do **not** need to run `setup_all.bat`.
Use `setup_all.bat` only to rebuild or repair the bundled runtime.

---

## Step 1: Get xAquaticRiskAnalysis

### Option 1 — Clone from GitHub

```bat
git clone https://github.com/xlandscape/xAquaticRiskAnalysis.git
cd xAquaticRiskAnalysis
```

### Option 2 — Download ZIP

1. Open <https://github.com/xlandscape/xAquaticRiskAnalysis>  
2. Click the green **Code** button → **Download ZIP**
3. Extract the ZIP to a folder of your choice

---

## Step 2: (Optional) Set `XAQ_RUN_DIR`

xAquaticRiskAnalysis needs to know where xAquaticRisk writes its simulation output.  
You tell it by setting the [`XAQ_RUN_DIR`](../reference/configuration.md#xaq_run_dir) environment variable to the absolute path of the `run/` folder.

```bat
set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
```

!!! tip "Making the variable permanent"
    To avoid typing this every session, add `XAQ_RUN_DIR` as a **persistent user environment variable**:  
    *Windows → Start → "Edit environment variables for your account" → New → Name: `XAQ_RUN_DIR`, Value: your path*

If `XAQ_RUN_DIR` is not set, `start.bat` now defaults to `C:\`.  
For most users, setting `XAQ_RUN_DIR` is still recommended so the UI opens directly on the correct run folder.

See [Configuration](../reference/configuration.md) for all supported variables.

---

## Step 3: Launch

From the `xAquaticRiskAnalysis` folder, run:

```bat
start.bat
```

`start.bat` automatically detects the bundled `analysis\python\python.exe` runtime if present; otherwise it falls back to whichever `python` is on `PATH`.

The server starts on port **8091** by default. Open your browser and navigate to:

```
http://localhost:8091
```

### Alternative — launch with Python directly

```bat
python server.py --run-dir C:\LocalWork\xAquaticRisk\run
```

### Custom port

```bat
set XAQ_PORT=9000
start.bat
```

or

```bat
python server.py --port 9000 --run-dir C:\LocalWork\xAquaticRisk\run
```

---

## Step 4: Select a run and start analysis

1. Open the **Analysis** tab in the browser UI
2. Choose an experiment from the **Experiment** dropdown — these are read from the `run/` folder identified by `XAQ_RUN_DIR`
3. Select a **MC run** within that experiment
4. Click **Start Analysis** — xARA launches `analysis/run_basic_analysis.py` as a subprocess and streams progress in the log panel
5. When the job completes, output figures and Excel tables are available for download directly from the browser

---

## Running alongside xAquaticRisk

Both servers can run simultaneously on the same machine. They use separate ports (8090 for the prep server, 8091 for xARA by default) and communicate only through the shared `run/` folder — there is no inter-process communication between them.

```bat
REM Terminal 1 — xAquaticRisk prep server (port 8090)
cd C:\LocalWork\xAquaticRisk\controlpanel
python server.py

REM Terminal 2 — xAquaticRiskAnalysis server (port 8091)
cd C:\LocalWork\xAquaticRiskAnalysis
start.bat
```

You can still set `XAQ_RUN_DIR` explicitly if you want a specific default run folder:

```bat
set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
start.bat
```
