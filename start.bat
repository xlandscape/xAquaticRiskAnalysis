@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "NO_PAUSE=%XAQ_NO_PAUSE%"

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
    call :fatal "No Python found. Run setup_all.bat first."
    exit /b 1
)
echo [..] Using system Python

:check_rundir
if not defined XAQ_RUN_DIR (
    echo.
    echo ERROR: XAQ_RUN_DIR is not set.
    echo.
    echo Hint: Set XAQ_RUN_DIR to the xAquaticRisk run folder before starting, e.g.:
    echo   set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
    echo.
    if /I "%NO_PAUSE%"=="1" exit /b 1
    pause
    exit /b 1
)
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
echo   Set XAQ_RUN_DIR to your xAquaticRisk run folder, e.g.:
echo     set XAQ_RUN_DIR=C:\path\to\xAquaticRisk\run
if /I "%NO_PAUSE%"=="1" goto :eof
pause
goto :eof