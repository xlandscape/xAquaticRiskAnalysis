# API Endpoints

The xAquaticRiskAnalysis server exposes a JSON HTTP API. All endpoints return `application/json` unless noted otherwise. Error responses use HTTP status codes ≥ 400 and include a `{"status": "error", "message": "..."}` body.

---

## Run discovery

### `GET /api/runs`

Returns all experiment folders and their MC runs found under [`XAQ_RUN_DIR`](configuration.md#xaq_run_dir).

**Response:**

```json
{
  "status": "success",
  "runs": [
    {
      "experiment": "Test_Run_aqRisk_20042026-140155",
      "mc_runs": ["mc_run_1", "mc_run_2"]
    }
  ]
}
```

---

### `GET /api/analysis/runs`

Returns experiments that have at least one completed MC run folder recognised by the analysis scripts.

---

### `GET /api/analysis/exposure-models`

Returns the list of exposure models supported by `run_basic_analysis.py`.

**Response:**

```json
{
  "status": "success",
  "exposure_models": ["CascadeToxswa", "StepsRiverNetwork"]
}
```

---

## Analysis jobs

### `POST /api/analysis/start`

Launches `analysis/run_basic_analysis.py` as a subprocess for a selected MC run.

**Request body:**

```json
{
  "experiment": "Test_Run_aqRisk_20042026-140155",
  "mc_run": "mc_run_1",
  "run_root": "C:\\LocalWork\\xAquaticRisk\\run",
  "scenario_path": "scenario/oudebeek-beek7-tdi",
  "scenario_name": "Oudebeek-Beek7-TDI",
  "exposure_model": "CascadeToxswa",
  "run_pec": true,
  "run_guts": true,
  "exposed_only": false
}
```

`run_root` defaults to `XAQ_RUN_DIR` if omitted.

**Response:**

```json
{
  "status": "success",
  "job_id": "Test_Run_aqRisk_20042026-140155_mc_run_1__20260421120000",
  "message": "Analysis started (job: ...)"
}
```

---

### `GET /api/analysis/status/<job_id>`

Polls the status of a running or completed analysis job.

**Response:**

```json
{
  "status": "success",
  "job_status": "running",
  "started_at": "2026-04-21 12:00:00",
  "log_tail": "... last lines of analysis.log ..."
}
```

`job_status` is one of `running`, `done`, `failed`.

---

### `GET /api/analysis/outputs/<job_id>`

Lists output files produced by a completed analysis job.

**Response:**

```json
{
  "status": "success",
  "files": ["pec_summary.xlsx", "lp50_plot.png", "guts_results.png"]
}
```

---

### `GET /api/analysis/file/<job_id>/<filename>`

Downloads a specific output file. Returns the file with an appropriate `Content-Type` (`image/png`, `image/svg+xml`, `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`, etc.).

---

### `GET /api/analysis/table/<job_id>`

Returns a summary table for the analysis job as JSON (used by the browser UI to render inline previews).

---

## Map explorer

### `POST /api/map-explorer/geometry`

Returns reach geometries (GeoJSON) and LULC field polygons for a selected experiment and MC run.

**Request body:**

```json
{
  "experiment": "Test_Run_aqRisk_20042026-140155",
  "mc_run": "mc_run_1",
  "run_root": "C:\\LocalWork\\xAquaticRisk\\run"
}
```

**Response:**

```json
{
  "status": "success",
  "scenario_path": "scenario/oudebeek-beek7-tdi",
  "geojson": { ... },
  "lulc_geojson": { ... },
  "meta": { ... },
  "lulc_meta": { ... }
}
```

---

### `POST /api/map-explorer/timeseries`

Returns PEC timeseries for selected reach IDs within a given time window.

**Request body:**

```json
{
  "experiment": "Test_Run_aqRisk_20042026-140155",
  "mc_run": "mc_run_1",
  "reach_ids": ["reach_001", "reach_002"],
  "time_from": "2026-01-01",
  "time_to": "2026-12-31",
  "resolution": "auto"
}
```

`time_from`, `time_to` and `resolution` are optional. `resolution` accepts `"auto"`, `"day"`, `"week"`, `"month"`.

---

## Status

### `GET /api/controlpanel/status`

Returns server health and configuration summary.

**Response:**

```json
{
  "status": "ok",
  "run_dir": "C:\\LocalWork\\xAquaticRisk\\run",
  "port": 8091
}
```
