@echo off
setlocal

set "SCRIPT_DIR=%~dp0"

echo ============================================================
echo xAquaticRisk Analysis Server
echo ============================================================
echo.

if not defined XAQ_PORT set "XAQ_PORT=8091"

REM -- Use embedded Python if available, else system Python
set "PYTHON_EXE=python.exe"
if exist "%SCRIPT_DIR%analysis\python\python.exe" (
    set "PYTHON_EXE=%SCRIPT_DIR%analysis\python\python.exe"
    echo [OK] Using embedded Python runtime
    goto :check_rundir
)
where /q python.exe
if errorlevel 1 (
    echo ERROR: No Python found. Run setup_all.bat first.
    exit /b 1
)
echo [..] Using system Python

:check_rundir
if not defined XAQ_RUN_DIR goto :no_rundir
if not exist "%XAQ_RUN_DIR%" goto :bad_rundir

echo [OK] Run folder : %XAQ_RUN_DIR%
echo [OK] Port       : %XAQ_PORT%
echo.

"%PYTHON_EXE%" "%SCRIPT_DIR%server.py" --port %XAQ_PORT% --run-dir "%XAQ_RUN_DIR%" %*
goto :eof

:no_rundir
echo ERROR: XAQ_RUN_DIR is not set!
exit /b 1

:bad_rundir
echo ERROR: Run directory does not exist: %XAQ_RUN_DIR%
exit /b 1