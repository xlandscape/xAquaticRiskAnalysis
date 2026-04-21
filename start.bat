@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo xAquaticRisk Analysis Server
echo ============================================================
echo.

REM Set default port for analysis server
if not defined XAQ_PORT set "XAQ_PORT=8091"

REM Validate XAQ_RUN_DIR environment variable
if not defined XAQ_RUN_DIR (
    echo ERROR: Environment variable XAQ_RUN_DIR is not set!
    echo.
    echo The analysis server requires XAQ_RUN_DIR to point to the shared
    echo run/ folder (typically C:\LocalWork\xAquaticRisk\run).
    echo.
    echo Set it before starting:
    echo   set XAQ_RUN_DIR=C:\LocalWork\xAquaticRisk\run
    echo.
    echo Or pass it as an argument:
    echo   python server.py --run-dir C:\LocalWork\xAquaticRisk\run
    echo.
    exit /b 1
)

REM Verify the run directory exists
if not exist "!XAQ_RUN_DIR!" (
    echo ERROR: Run directory does not exist: !XAQ_RUN_DIR!
    exit /b 1
)

echo Run folder         : !XAQ_RUN_DIR!
echo Port               : !XAQ_PORT!
echo.

REM Use embedded Python runtime if available, otherwise fall back to system Python
set PYTHON_EXE=python.exe
if exist "!~dp0analysis\python\python.exe" (
    set "PYTHON_EXE=!~dp0analysis\python\python.exe"
    echo Using embedded Python runtime: !PYTHON_EXE!
) else (
    echo Using system Python: %PYTHON_EXE%
)

echo.
"!PYTHON_EXE!" "!~dp0server.py" --port !XAQ_PORT! --run-dir "!XAQ_RUN_DIR!" %*
