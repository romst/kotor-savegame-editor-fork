@echo off
setlocal enabledelayedexpansion

call "%~dp0perl_env.bat"
if errorlevel 1 (
    pause
    exit /b 1
)

echo [1/3] Checking cpm...
call cpm --version >nul 2>nul
if errorlevel 1 (
    echo   cpm not found, installing...
    call cpan -fi App::cpm
    call cpm --version >nul 2>nul
    if errorlevel 1 (
        echo ERROR: cpm installation failed.
        pause
        exit /b 1
    )
) else (
    echo   [ OK ] cpm already installed, skipping.
)
echo.

echo [2/3] Installing packages with cpm...
call cpm install -g Tk Tk::Autoscroll Tk::DynaTabFrame Win32::FileOp PAR::Packer
echo.

echo [3/3] Verifying installation...
set FAILED=0

for %%M in (Tk Tk::HList Tk::Autoscroll Tk::DynaTabFrame Win32::FileOp PAR::Packer) do (
    perl -M%%M -e "1" 2>nul
    if errorlevel 1 (
        echo   [FAIL] Module %%M not found
        set FAILED=1
    ) else (
        echo   [ OK ] Module %%M
    )
)

call pp --version >nul 2>nul
if errorlevel 1 (
    echo   [FAIL] pp is not available
    set FAILED=1
) else (
    echo   [ OK ] pp
)

echo.
if "!FAILED!"=="0" (
    echo SUCCESS: All modules and pp are installed.
) else (
    echo ERROR: At least one component is missing, see above.
)

endlocal