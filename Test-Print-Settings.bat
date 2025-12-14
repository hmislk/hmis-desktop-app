@echo off
setlocal enabledelayedexpansion
REM Test Script to Verify Print Settings

REM Load configuration
call "%~dp0config.bat"

echo ================================================
echo HMIS Print Settings Test
echo ================================================
echo.
echo Configuration:
echo   PRINT_MODE: %PRINT_MODE%
echo   PRINT_MARGINS: %PRINT_MARGINS%
echo   PRINT_HEADERS: %PRINT_HEADERS%
echo   SESSION_MODE: %SESSION_MODE%
echo.

REM Determine session directory
if "%SESSION_MODE%"=="PERSISTENT" (
    set USER_DATA_DIR=%SESSION_DIR%\PersistentSession
) else (
    set SESSION_ID=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set SESSION_ID=!SESSION_ID: =0!
    set USER_DATA_DIR=%SESSION_DIR%\Session_!SESSION_ID!
)

set PREFS_DIR=!USER_DATA_DIR!\Default

echo Checking for existing Preferences file...
if exist "!PREFS_DIR!\Preferences" (
    echo Found: !PREFS_DIR!\Preferences
    echo.
    echo Contents:
    type "!PREFS_DIR!\Preferences"
) else (
    echo NOT FOUND: !PREFS_DIR!\Preferences
    echo This file will be created on next launch.
)

echo.
echo ================================================
echo.
echo To test print settings:
echo 1. Launch the app normally
echo 2. Try printing a page (Ctrl+P)
echo 3. Check if headers/footers are disabled
echo.
echo If still seeing headers/footers, they may be:
echo   A) Chrome's print headers (URL, date, page numbers)
echo   B) Part of the webpage itself
echo.
echo Press any key to exit...
pause >nul
