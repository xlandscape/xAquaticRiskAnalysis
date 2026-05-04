@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "NO_PAUSE=%XAQ_NO_PAUSE%"

echo ============================================================
echo xAquaticRisk Analysis Server
echo ============================================================
echo.

if not defined XAQ_PORT set "XAQ_PORT=8091"

REM -- Use embedded Python runtime and auto-bootstrap it if missing/incomplete
set "PYTHON_EXE=%SCRIPT_DIR%analysis\python\python.exe"
if exist "%SCRIPT_DIR%analysis\python\python.exe" (
    echo [OK] Using embedded Python runtime
    goto :check_analysis_runtime
)
echo [..] Embedded Python runtime not found. Preparing now...
if /I "%NO_PAUSE%"=="1" (
    call "%SCRIPT_DIR%setup_analysis_python.bat" --silent
) else (
    call "%SCRIPT_DIR%setup_analysis_python.bat"
)
if errorlevel 1 (
    call :fatal "Failed to prepare embedded Python runtime automatically."
    exit /b 1
)
echo [OK] Embedded Python runtime prepared

:check_analysis_runtime
echo [..] Validating analysis runtime...
"%SCRIPT_DIR%analysis\python\python.exe" -c "import importlib.util,sys;mods=('h5py','numpy','pandas','matplotlib','seaborn','openpyxl','geopandas','pyogrio');missing=[m for m in mods if importlib.util.find_spec(m) is None];sys.exit(1 if missing else 0)" >nul 2>nul
if not errorlevel 1 (
    echo [OK] Analysis runtime is ready
    goto :check_rundir
)

echo [!!] Analysis runtime is incomplete. Repairing now...
if /I "%NO_PAUSE%"=="1" (
    call "%SCRIPT_DIR%setup_analysis_python.bat" --silent
) else (
    call "%SCRIPT_DIR%setup_analysis_python.bat"
)
if errorlevel 1 (
    call :fatal "Failed to prepare analysis runtime automatically."
    exit /b 1
)
echo [OK] Analysis runtime repaired

:check_rundir
REM -- Default to C:\ so the user can browse to any run folder via the Web UI.
REM    Set XAQ_RUN_DIR to a specific run folder to override the starting browse root.
if not defined XAQ_RUN_DIR set "XAQ_RUN_DIR=C:\"
if not exist "%XAQ_RUN_DIR%" goto :bad_rundir

echo [OK] Run folder : %XAQ_RUN_DIR%
echo [OK] Port       : %XAQ_PORT%
echo.

set "RUN_DIR_ARG=%XAQ_RUN_DIR%"
if /I "%RUN_DIR_ARG:~-1%"=="\" set "RUN_DIR_ARG=%RUN_DIR_ARG%."

"%PYTHON_EXE%" "%SCRIPT_DIR%server.py" --port %XAQ_PORT% --run-dir "%RUN_DIR_ARG%" %*
goto :eof

:bad_rundir
call :fatal "Run directory does not exist: %XAQ_RUN_DIR%"
exit /b 1

:fatal
echo.
echo ERROR: %~1
echo.
echo Hint:
echo   XAQ_RUN_DIR (optional) sets the starting browse root. Default is C:\
echo   Example: set XAQ_RUN_DIR=D:\MyRuns
if /I "%NO_PAUSE%"=="1" goto :eof
pause
goto :eof