@echo off
echo ========================================
echo Stopping RevCart Infrastructure
echo ========================================

cd Revcart\microservices

echo.
echo Stopping Docker containers...
docker-compose down

echo.
echo Infrastructure stopped successfully!
echo.

pause
