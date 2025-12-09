@echo off
echo ========================================
echo Starting Complete Microfrontend System
echo ========================================
echo.

echo Step 1: Installing MFE Dependencies...
cd mfe-apps
call SETUP-AND-RUN.bat

echo.
echo Step 2: Starting All Microfrontends...
call START-ALL-MFES.bat

echo.
echo ========================================
echo System Started!
echo ========================================
echo.
echo Access: http://localhost:4200
echo.
pause
