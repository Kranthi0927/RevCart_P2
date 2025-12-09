@echo off
echo ========================================
echo MongoDB Database Verification
echo ========================================
echo.

echo Checking if MongoDB is running...
echo.

echo Testing MongoDB connection on localhost:27017
mongosh --eval "db.version()" --quiet

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ MongoDB is NOT running!
    echo.
    echo Please start MongoDB:
    echo 1. Open Services (services.msc)
    echo 2. Find "MongoDB" service
    echo 3. Click "Start"
    echo.
    echo OR run: net start MongoDB
    pause
    exit /b 1
)

echo.
echo ✅ MongoDB is running!
echo.
echo Checking databases...
echo.

mongosh --eval "show dbs" --quiet

echo.
echo ========================================
echo.
echo Expected databases:
echo - notification_db (created by notification-service)
echo - analytics_db (created by analytics-service)
echo.
echo If databases are missing:
echo 1. Make sure notification-service (8087) is running
echo 2. Make sure analytics-service (8089) is running
echo 3. Databases are created automatically when services start
echo.
pause
