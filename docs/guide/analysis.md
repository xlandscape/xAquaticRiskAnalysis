# Running Analysis

The **Analysis** tab in the xAquaticRiskAnalysis web UI lets you run PEC and GUTS-RA analyses on completed xAquaticRisk simulations.

## Prerequisites

- At least one completed xAquaticRisk simulation run in your configured run folder (see [Configuration](../reference/configuration.md))
- Run folder must contain analysis-ready experiments with Monte Carlo stores

## Starting an Analysis

### 1. Select Experiment

1. Open http://localhost:8091 in your browser
2. Click the **Analysis** tab
3. In the **Experiment** dropdown, select a completed xAquaticRisk experiment

The dropdown is populated automatically from your run folder. Experiments without Monte Carlo data are grayed out.

### 2. Select Monte Carlo Run

After selecting an experiment, the **MC Run** dropdown shows available Monte Carlo runs for that experiment.

Select the MC run you want to analyze.

### 3. Click "Start Analysis"

Click the **Start Analysis** button to launch the job.

The interface will:
- Disable the button (prevents duplicate submissions)
- Display a progress log in the **Log** panel
- Show a spinning indicator while the job runs

## Monitoring Progress

The **Log** panel shows real-time updates from the analysis subprocess:

- `[INFO]` messages indicate successful steps
- `[WARNING]` messages flag non-critical issues
- `[ERROR]` messages indicate failures

Most analyses take 5–30 minutes depending on the simulation size and number of reaches.

## Downloading Results

When the analysis completes:

1. The **Downloads** section appears in the interface
2. Click any file name to download results:
   - **Excel tables** (`.xlsx`) – PEC and effect summary tables
   - **Figures** (`.png`) – Charts showing PEC distribution, risk distribution, etc.
   - **Data files** (`.json`, `.csv`) – Raw analysis output for custom processing

All files are stored server-side in the `analysis_output/` folder for the duration of the session.

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| "No analysis-ready experiments found" | Run folder has no completed simulations | Ensure `XAQ_RUN_DIR` points to a folder with completed xAquaticRisk runs |
| "Analysis Python missing" | Embedded runtime corrupted or deleted | Re-run `start.bat`; it will auto-repair |
| Analysis button disabled | Job already running or no MC run selected | Wait for current job to finish or select a valid run |
| Long analysis times | Large simulation or many reaches | This is normal; check the log for progress updates |

## API

For automation or integration, the analysis workflow is available via HTTP:

- **POST** `/api/analysis/start` – Launch new job
- **GET** `/api/analysis/status/<job_id>` – Check job status
- **GET** `/api/analysis/outputs/<job_id>` – List job outputs
- **GET** `/api/analysis/file/<job_id>/<filename>` – Download file

See the [API Reference](../reference/api.md) for details.
