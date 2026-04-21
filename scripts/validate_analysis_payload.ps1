param(
    [string]$RepoRoot = "C:\LocalWork\xAquaticRiskAnalysis"
)

$ErrorActionPreference = "Stop"

function Test-RequiredFile {
    param([string]$Path, [string]$Label)
    if (Test-Path -LiteralPath $Path) {
        Write-Host "[ok] $Label" -ForegroundColor Green
        return $true
    }
    Write-Host "[missing] $Label -> $Path" -ForegroundColor Red
    return $false
}

$analysisDir = Join-Path $RepoRoot "analysis"
$requiredFiles = @(
    @{ Rel = "analysis\run_basic_analysis.py"; Label = "Analysis entrypoint" },
    @{ Rel = "analysis\basic_analysis_common.py"; Label = "Shared analysis module" },
    @{ Rel = "index.html"; Label = "Web UI" },
    @{ Rel = "server.py"; Label = "Analysis server" },
    @{ Rel = "start.bat"; Label = "Windows launcher" }
)

$allOk = $true
foreach ($item in $requiredFiles) {
    $full = Join-Path $RepoRoot $item.Rel
    $ok = Test-RequiredFile -Path $full -Label $item.Label
    if (-not $ok) { $allOk = $false }
}

$runtimePython = Join-Path $analysisDir "python\python.exe"
if (Test-Path -LiteralPath $runtimePython) {
    Write-Host "[ok] Bundled runtime detected: $runtimePython" -ForegroundColor Green

    $probe = @(
        "-c",
        "import importlib.util;mods=('h5py','numpy','pandas','matplotlib','seaborn','openpyxl','geopandas','pyogrio');missing=[m for m in mods if importlib.util.find_spec(m) is None];print(','.join(missing))"
    )

    $proc = Start-Process -FilePath $runtimePython -ArgumentList $probe -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\\xaq_runtime_probe.out" -RedirectStandardError "$env:TEMP\\xaq_runtime_probe.err"
    $missing = ""
    if (Test-Path "$env:TEMP\\xaq_runtime_probe.out") {
        $missing = (Get-Content "$env:TEMP\\xaq_runtime_probe.out" -Raw).Trim()
    }

    if ($proc.ExitCode -ne 0) {
        Write-Host "[warn] Runtime probe failed (exit $($proc.ExitCode))." -ForegroundColor Yellow
        $allOk = $false
    } elseif ($missing) {
        Write-Host "[warn] Bundled runtime missing packages: $missing" -ForegroundColor Yellow
        $allOk = $false
    } else {
        Write-Host "[ok] Bundled runtime package probe passed" -ForegroundColor Green
    }
} else {
    Write-Host "[warn] Bundled runtime not present: $runtimePython" -ForegroundColor Yellow
    Write-Host "       You can still run with system Python + XAQ_ALLOW_DEV_PYTHON=1 for development." -ForegroundColor Yellow
}

if ($allOk) {
    Write-Host "\nValidation result: READY" -ForegroundColor Green
    exit 0
}

Write-Host "\nValidation result: INCOMPLETE" -ForegroundColor Red
exit 1
