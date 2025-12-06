@echo off
REM Cleanup old HMIS Chrome sessions

echo ================================================
echo HMIS Chrome Session Cleanup
echo ================================================
echo.
echo This will delete all temporary session data.
echo.
choice /C YN /M "Do you want to continue"

if errorlevel 2 goto :cancel
if errorlevel 1 goto :cleanup

:cleanup
echo.
echo Cleaning up old sessions...
rd /s /q "%TEMP%\HMIS-Chrome" 2>nul
echo.
echo Done! All session data has been cleared.
echo.
pause
exit

:cancel
echo.
echo Cleanup cancelled.
echo.
pause
exit
