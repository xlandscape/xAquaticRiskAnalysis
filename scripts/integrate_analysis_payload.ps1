param(
    [string]$SourceRepo = "C:\LocalWork\xAquaticRisk",
    [string]$TargetRepo = "C:\LocalWork\xAquaticRiskAnalysis",
    [switch]$IncludeBundledRuntime,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[step] $Message" -ForegroundColor Cyan
}

function Assert-Path {
    param([string]$PathToCheck, [string]$Message)
    if (-not (Test-Path -LiteralPath $PathToCheck)) {
        throw $Message
    }
}

Write-Step "Validate source and target repositories"
Assert-Path $SourceRepo "Source repository not found: $SourceRepo"
Assert-Path $TargetRepo "Target repository not found: $TargetRepo"

$sourceAnalysis = Join-Path $SourceRepo "analysis"
$targetAnalysis = Join-Path $TargetRepo "analysis"

Assert-Path $sourceAnalysis "Source analysis payload folder not found: $sourceAnalysis"
Assert-Path (Join-Path $sourceAnalysis "run_basic_analysis.py") "Source analysis entrypoint missing: analysis/run_basic_analysis.py"

if (-not (Test-Path -LiteralPath $targetAnalysis)) {
    Write-Step "Create target analysis folder"
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $targetAnalysis | Out-Null
    }
}

Write-Step "Copy analysis payload from source to target"
$robocopyArgs = @(
    $sourceAnalysis,
    $targetAnalysis,
    "/E",
    "/R:1",
    "/W:1",
    "/NFL",
    "/NDL",
    "/NP"
)

# Runtime is large and often distributed separately. Include it only when explicitly requested.
if (-not $IncludeBundledRuntime) {
    $robocopyArgs += @("/XD", "python", "lib")
}

if ($DryRun) {
    Write-Host "[dry-run] robocopy $($robocopyArgs -join ' ')" -ForegroundColor Yellow
} else {
    $null = & robocopy @robocopyArgs
    $rc = $LASTEXITCODE
    if ($rc -ge 8) {
        throw "robocopy failed with exit code $rc"
    }
}

Write-Step "Integration completed"
if ($IncludeBundledRuntime) {
    Write-Host "Bundled runtime was included (analysis/python and analysis/lib)." -ForegroundColor Green
} else {
    Write-Host "Bundled runtime was not included. Use -IncludeBundledRuntime for fully self-contained payload." -ForegroundColor Yellow
}

Write-Host "Next: run scripts/validate_analysis_payload.ps1" -ForegroundColor Green
