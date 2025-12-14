@echo off
setlocal enabledelayedexpansion
REM HMIS Desktop Chrome App Launcher
REM Each launch creates a new independent session

REM Load configuration
call "%~dp0config.bat"

REM Determine session directory based on SESSION_MODE
if "%SESSION_MODE%"=="PERSISTENT" (
    set USER_DATA_DIR=%SESSION_DIR%\PersistentSession
    set SESSION_ID=PERSISTENT
) else (
    if "%SESSION_MODE%"=="TEMPLATE" (
        REM Generate unique session ID using timestamp
        set SESSION_ID=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
        set SESSION_ID=!SESSION_ID: =0!
        set USER_DATA_DIR=%SESSION_DIR%\Session_!SESSION_ID!
        set TEMPLATE_DIR=%SESSION_DIR%\TemplateProfile

        REM Check if template exists
        if exist "!TEMPLATE_DIR!" (
            REM Copy template to new session
            echo Copying template profile to new session...
            xcopy "!TEMPLATE_DIR!" "!USER_DATA_DIR!" /E /I /Q >nul 2>&1
        ) else (
            REM First launch - create template
            echo First launch - creating template profile...
            echo Configure your printer settings, then close and relaunch.
            set USER_DATA_DIR=!TEMPLATE_DIR!
            set SESSION_ID=TEMPLATE_SETUP
        )
    ) else (
        REM Generate unique session ID using timestamp
        set SESSION_ID=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
        set SESSION_ID=!SESSION_ID: =0!
        set USER_DATA_DIR=%SESSION_DIR%\Session_!SESSION_ID!
    )
)

REM Build Chrome command
set CHROME_CMD="C:\Program Files\Google\Chrome\Application\chrome.exe"
set CHROME_ARGS=--app="%HMIS_URL%" --user-data-dir="!USER_DATA_DIR!" --window-size=%WINDOW_SIZE% --no-first-run --no-default-browser-check --load-extension="%~dp0print-extension"

REM Apply print mode settings
if "%PRINT_MODE%"=="DIRECT" (
    set CHROME_ARGS=!CHROME_ARGS! --disable-print-preview
)
if "%PRINT_MODE%"=="SILENT" (
    set CHROME_ARGS=!CHROME_ARGS! --kiosk-printing
)

REM Apply cache settings
if "%CACHE_MODE%"=="DISABLED" (
    set CHROME_ARGS=!CHROME_ARGS! --disk-cache-dir=nul --disk-cache-size=1
)

REM Apply zoom level if set
if not "%ZOOM_LEVEL%"=="" (
    set CHROME_ARGS=!CHROME_ARGS! --force-device-scale-factor=%ZOOM_LEVEL%
)

REM Create user data directory if it doesn't exist
if not exist "!USER_DATA_DIR!" mkdir "!USER_DATA_DIR!"

REM Configure print preferences
set PREFS_DIR=!USER_DATA_DIR!\Default
if not exist "!PREFS_DIR!" mkdir "!PREFS_DIR!"

REM Only create Preferences file if it doesn't exist (preserve user settings)
if not exist "!PREFS_DIR!\Preferences" (
    echo Creating initial Preferences file with print settings...
    powershell -Command "$prefs = @{printing=@{print_preview_sticky_settings=@{appState=@{version=2;recentDestinations=@();selectedDestinationId='';marginsType=3;customMargins=@{marginTop=0;marginBottom=0;marginLeft=0;marginRight=0};isHeaderFooterEnabled=$false;isLandscapeEnabled=$false;scaling='100';scalingType=0;isCssBackgroundEnabled=$true}}}}; $prefs | ConvertTo-Json -Depth 10 | Out-File -FilePath '!PREFS_DIR!\Preferences' -Encoding utf8"
)

REM Launch Chrome
start "" !CHROME_CMD! !CHROME_ARGS!

echo ================================================
echo HMIS Session Started
echo ================================================
echo Session Mode: !SESSION_MODE!
echo Session ID: !SESSION_ID!
echo Print Mode: !PRINT_MODE!
echo Cache Mode: !CACHE_MODE!
if not "!ZOOM_LEVEL!"=="" echo Zoom Level: !ZOOM_LEVEL! (80%% = 0.8, 100%% = 1.0)
echo ================================================
echo.
echo Press any key to close this window...
pause >nul
exit
