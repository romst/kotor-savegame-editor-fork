@echo off
REM Sets up the portable Strawberry Perl environment for this script only.
REM Change PERL_DIR if you switch to another Perl version.
set PERL_DIR=%~dp0strawberry-perl-no64-5.32.1.1-32bit-portable

if not exist "%PERL_DIR%\perl\bin\perl.exe" (
    echo ERROR: Portable Perl not found in "%PERL_DIR%"
    exit /b 1
)

set PATH=%PERL_DIR%\perl\site\bin;%PERL_DIR%\perl\bin;%PERL_DIR%\c\bin;%PATH%

REM Make sure the scripts run from the repository folder
cd /d "%~dp0"

echo Using:
perl -e "print qq(  Perl $^V\n)"
exit /b 0