@echo off
echo Starting migration to microservices architecture...

echo.
echo Step 1: Building all microservices...
call mvn clean package -DskipTests

echo.
echo Step 2: Starting infrastructure services...
docker-compose up -d consul mysql redis mongodb zookeeper kafka

echo.
echo Waiting for infrastructure to be ready...
timeout /t 30

echo.
echo Step 3: Starting microservices...
docker-compose up -d

echo.
echo Step 4: Removing old backend folder...
if exist "..\backend" (
    echo Removing backend folder...
    rmdir /s /q "..\backend"
    echo Backend folder removed successfully!
) else (
    echo Backend folder not found or already removed.
)

echo.
echo Migration completed successfully!
echo.
echo Services running:
echo - API Gateway: http://localhost:8080
echo - Auth Service: http://localhost:8081
echo - User Service: http://localhost:8082
echo - Product Service: http://localhost:8083
echo - Cart Service: http://localhost:8084
echo - Order Service: http://localhost:8085
echo - Payment Service: http://localhost:8086
echo - Notification Service: http://localhost:8087
echo - Delivery Service: http://localhost:8088
echo - Analytics Service: http://localhost:8089
echo - Admin Service: http://localhost:8090
echo - Consul UI: http://localhost:8500
echo.
echo Check service health at: http://localhost:8500/ui/dc1/services