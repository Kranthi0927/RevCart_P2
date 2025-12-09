@echo off
echo ========================================
echo Creating MongoDB Databases
echo ========================================
echo.

echo Step 1: Check if services are running
echo --------------------------------------
echo.

echo Checking notification-service (8087)...
curl -s http://localhost:8087/actuator/health
if %ERRORLEVEL% NEQ 0 (
    echo ❌ notification-service is NOT running on port 8087
    echo Please start it first!
    pause
    exit /b 1
)
echo ✅ notification-service is running
echo.

echo Checking analytics-service (8089)...
curl -s http://localhost:8089/actuator/health
if %ERRORLEVEL% NEQ 0 (
    echo ❌ analytics-service is NOT running on port 8089
    echo Please start it first!
    pause
    exit /b 1
)
echo ✅ analytics-service is running
echo.
echo.

echo Step 2: Creating databases by inserting test data
echo --------------------------------------------------
echo.

echo Creating notification_db...
curl -X POST http://localhost:8087/notifications/test
echo.
echo.

echo Creating analytics_db...
curl -X POST http://localhost:8089/analytics/test
echo.
echo.

echo Step 3: Verify in MongoDB
echo --------------------------
echo.
mongosh --eval "show dbs"
echo.
echo.

echo ========================================
echo Done! Check MongoDB Compass now
echo ========================================
echo.
echo Refresh MongoDB Compass to see:
echo - notification_db
echo - analytics_db
echo.
pause
