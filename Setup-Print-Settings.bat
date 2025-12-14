@echo off
setlocal enabledelayedexpansion
REM Manual Print Settings Setup for HMIS

echo ================================================
echo HMIS Print Settings - Manual Configuration
echo ================================================
echo.
echo This script will help you configure print settings manually.
echo These settings will be saved in PERSISTENT mode.
echo.
echo INSTRUCTIONS:
echo 1. Chrome will launch
echo 2. Press Ctrl+P to open Print dialog
echo 3. In the Print dialog, configure:
echo    a) Click "More settings" to expand all options
echo    b) Margins: Click dropdown and select "None"
echo    c) Headers and footers: UNCHECK this box
echo    d) Options: Check "Background graphics" if needed
echo 4. Click "Print" to save, then cancel the actual print
echo    OR just click "Cancel" after changing settings
echo 5. Close Chrome
echo 6. Your settings will be saved permanently
echo.
pause

REM Load configuration
call "%~dp0config.bat"

REM Force PERSISTENT mode for setup
set USER_DATA_DIR=%SESSION_DIR%\PersistentSession
set PREFS_DIR=!USER_DATA_DIR!\Default

REM Create directories
if not exist "!USER_DATA_DIR!" mkdir "!USER_DATA_DIR!"
if not exist "!PREFS_DIR!" mkdir "!PREFS_DIR!"

REM Build Chrome command
set CHROME_CMD="C:\Program Files\Google\Chrome\Application\chrome.exe"
set CHROME_ARGS=--app="%HMIS_URL%" --user-data-dir="!USER_DATA_DIR!" --window-size=%WINDOW_SIZE%

echo.
echo Launching Chrome for manual configuration...
echo.
start "" !CHROME_CMD! !CHROME_ARGS!

echo.
echo After configuring print settings:
echo 1. Close Chrome
echo 2. Launch normally with Launch-HMIS.bat
echo 3. Settings should now be saved
echo.
echo Press any key when done...
pause >nul
