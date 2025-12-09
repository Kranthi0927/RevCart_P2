@echo off
echo ========================================
echo Starting RevCart Monolithic Frontend
echo ========================================
echo.

cd revcart-frontend

echo Starting Angular application on http://localhost:4200
echo Press Ctrl+C to stop the server
echo.

ng serve --port 4200 --open

pause