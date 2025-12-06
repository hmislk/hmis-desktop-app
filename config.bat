@echo off
REM ========================================
REM HMIS Chrome App Configuration
REM ========================================

REM Application URL
set HMIS_URL=https://stg.carecode.org/coopprod/faces/index1.xhtml

REM Window Size (width,height)
set WINDOW_SIZE=1400,1000

REM Zoom Level (percentage as decimal: 0.8 = 80%, 1.0 = 100%, 1.25 = 125%)
REM Set to empty to use default zoom (100%)
set ZOOM_LEVEL=0.8

REM Session Mode
REM Options: UNIQUE, PERSISTENT, TEMPLATE
REM   UNIQUE     - Create new session each launch (multi-user, no saved settings)
REM   PERSISTENT - Use same session (single-user, preserves printer settings, shared login)
REM   TEMPLATE   - Copy template profile to each session (preserves printer settings, independent logins)
set SESSION_MODE=TEMPLATE

REM Print Settings
REM Options: PREVIEW, DIRECT, SILENT
REM   PREVIEW - Show print preview dialog (default Chrome behavior)
REM   DIRECT  - Print directly without preview
REM   SILENT  - Print silently to default printer (kiosk mode)
set PRINT_MODE=SILENT

REM Cache Settings
REM Options: ENABLED, DISABLED
REM   ENABLED  - Use cache (faster, may show old data)
REM   DISABLED - Disable cache (always fresh data)
set CACHE_MODE=DISABLED

REM Session Storage Location
set SESSION_DIR=%TEMP%\HMIS-Chrome
