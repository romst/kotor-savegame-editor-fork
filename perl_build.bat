@echo off
setlocal

call "%~dp0perl_env.bat"
if errorlevel 1 (
    pause
    exit /b 1
)

set SCRIPT=kse.pl
set OUTPUT=KSE.exe
set MODULES=-M Tk::HList -M Tk::Autoscroll -M Tk::DynaTabFrame -M Win32::FileOp

REM Usage: build.bat          builds the GUI version
REM        build.bat debug    builds with a console window to show errors
set GUI=--gui
if /i "%~1"=="debug" (
    set GUI=
    set OUTPUT=KSE_debug.exe
    echo Debug mode: building with console window.
)

echo [1/3] Checking prerequisites...
if not exist "%SCRIPT%" (
    echo ERROR: %SCRIPT% not found. Run this file from the repository folder.
    goto :fail
)
call pp --version >nul 2>nul
if errorlevel 1 (
    echo ERROR: pp not found. Run the install script first and start this from the portable shell.
    goto :fail
)
echo   [ OK ] Prerequisites

echo.
echo [2/3] Building %OUTPUT%...
if exist "%OUTPUT%" del /q "%OUTPUT%"
call pp %GUI% %MODULES% -o %OUTPUT% %SCRIPT%
if errorlevel 1 (
    echo ERROR: pp failed, see output above.
    goto :fail
)

echo.
echo [3/3] Verifying result...
if not exist "%OUTPUT%" (
    echo ERROR: %OUTPUT% was not created.
    goto :fail
)
echo   [ OK ] %OUTPUT% created

echo.
echo SUCCESS: Build finished. Start it with %OUTPUT%
endlocal
exit /b 0

:fail
echo.
echo BUILD FAILED.
endlocal
exit /b 1