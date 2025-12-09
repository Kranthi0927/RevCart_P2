@echo off
echo ========================================
echo Starting RevCart Monolithic Frontend
echo ========================================
echo.

cd revcart-frontend

echo Installing dependencies...
call npm install

echo.
echo Starting Angular application on http://localhost:4200
echo.

call npm start

pause