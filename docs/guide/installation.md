# Installation

## Prerequisites

- **Windows 64-bit** (any Windows that supports Python 3.9+)
- A completed xAquaticRisk simulation run in a `run/` folder

## Quick Install

### 1. Clone or Download

**Clone from GitHub:**
```bash
git clone https://github.com/xlandscape/xAquaticRiskAnalysis.git
cd xAquaticRiskAnalysis
```

**Or download as ZIP:**
1. Visit https://github.com/xlandscape/xAquaticRiskAnalysis
2. Click **Code** → **Download ZIP**
3. Extract to your desired location

### 2. First Run (Auto-Bootstrap)

Simply run:
```batch
start.bat
```

The first time you run `start.bat`, it automatically:
- Detects the embedded Python runtime
- Downloads and installs it if missing
- Validates and repairs analysis packages if needed
- Starts the server on port 8091

No manual setup steps are required.

### 3. (Optional) Set Run Directory

Set `XAQ_RUN_DIR` to point to your xAquaticRisk simulation folder:

**Temporary (current session):**
```batch
set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
start.bat
```

**Permanent (Windows environment):**
1. Press `Win+X` → **System**
2. Click **Advanced system settings**
3. Click **Environment Variables...**
4. Under **User variables**, click **New**
5. Name: `XAQ_RUN_DIR`
6. Value: `C:\path\to\xAquaticRisk\run`
7. Click **OK** and restart terminals

## Verify Installation

After first run, open your browser:
```
http://localhost:8091
```

You should see the xAquaticRiskAnalysis web interface with:
- **Analysis** tab for running PEC/GUTS analyses
- **Map Explorer** tab for viewing reach and LULC geometries

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 8091 in use | Set `XAQ_PORT=9000` before running `start.bat` |
| Python/package errors | Delete `analysis\python\` and re-run `start.bat` |
| Analysis button disabled | Ensure your run folder is set correctly via `XAQ_RUN_DIR` |

See [Configuration](../reference/configuration.md) for all available options.
