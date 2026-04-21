@echo off
setlocal enabledelayedexpansion

REM -- setup_all.bat
REM
REM  Complete setup orchestration for xcopy-ready deployment.
REM  Ensures xAquaticRiskAnalysis is fully functional with no external dependencies.
REM
REM  Usage:
REM    setup_all.bat              (interactive, pauses on errors)
REM    setup_all.bat --silent     (non-interactive, exits on errors)

set SILENT=0
if "%1"=="--silent" set SILENT=1

cd /d "%~dp0"

echo ============================================================
echo  xAquaticRiskAnalysis - Complete Setup
echo ============================================================
echo.

REM -- Step 1: Check prerequisites -----------------------------------------------
echo [1/3] Checking prerequisites...
if not exist "analysis\requirements.txt" (
    echo ERROR: analysis\requirements.txt not found
    if %SILENT%==0 pause
    exit /b 1
)
if not exist "server.py" (
    echo ERROR: server.py not found
    if %SILENT%==0 pause
    exit /b 1
)
if not exist "index.html" (
    echo ERROR: index.html not found
    if %SILENT%==0 pause
    exit /b 1
)
echo [OK] All required files present
echo.

REM -- Step 2: Set up analysis Python runtime ------------------------------------
echo [2/3] Setting up Python 3.9 runtime (this may take 5-10 minutes)...
if exist "analysis\python\python.exe" (
    echo [OK] Python runtime already exists, validating...
) else (
    echo Creating new Python runtime...
)
call setup_analysis_python.bat
if errorlevel 1 (
    echo ERROR: Python setup failed
    if %SILENT%==0 pause
    exit /b 1
)
echo [OK] Python runtime ready
echo.

REM -- Step 3: Validate installation --------------------------------------------
echo [3/3] Validating installation...
if not exist "analysis\python\python.exe" (
    echo ERROR: Python executable not found at analysis\python\python.exe
    if %SILENT%==0 pause
    exit /b 1
)
echo [OK] Python executable found
"analysis\python\python.exe" -c "import h5py, pandas, numpy, matplotlib, seaborn, geopandas, pyogrio, openpyxl" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Not all required packages are installed
    if %SILENT%==0 pause
    exit /b 1
)
echo [OK] All required packages available
echo.

echo ============================================================
echo  Setup complete! xAquaticRiskAnalysis is xcopy-ready
echo ============================================================
echo.
echo  Your folder can now be:
echo    - Copied to any Windows machine
echo    - Zipped and distributed
echo    - Deployed without external dependencies
echo.
echo  To start the analysis server:
echo    1. Set environment variable:
echo       set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
echo    2. Run: start.bat
echo    3. Open: http://localhost:8091
echo.
if %SILENT%==0 pause
exit /b 0
