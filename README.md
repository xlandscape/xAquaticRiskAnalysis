# xAquaticRiskAnalysis

Analysis and reporting functionality for xAquaticRisk.

## Integration Status

This repository is intended to run the former `controlpanel-analysis` functionality as a standalone app.
To do that, it needs a local `analysis/` payload folder (scripts and optional bundled runtime).

## Step-by-Step Payload Integration

Run from PowerShell in the repo root:

```powershell
# 1) Copy analysis payload from sibling xAquaticRisk repo
./scripts/integrate_analysis_payload.ps1 -SourceRepo "C:\LocalWork\xAquaticRisk" -TargetRepo "C:\LocalWork\xAquaticRiskAnalysis"

# 2) Optional: include bundled runtime for self-contained deployment
./scripts/integrate_analysis_payload.ps1 -SourceRepo "C:\LocalWork\xAquaticRisk" -TargetRepo "C:\LocalWork\xAquaticRiskAnalysis" -IncludeBundledRuntime

# 3) Validate required files and runtime
./scripts/validate_analysis_payload.ps1 -RepoRoot "C:\LocalWork\xAquaticRiskAnalysis"
```

## Start the Analysis Control Panel

```powershell
set-item env:XAQ_RUN_DIR "C:\LocalWork\xAquaticRisk\run"
./start.bat
```

Open `http://localhost:8091`.
