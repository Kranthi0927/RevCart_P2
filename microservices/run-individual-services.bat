@echo off
echo Select which service to run:
echo.
echo 1. Auth Service (Port 8081)
echo 2. User Service (Port 8082)
echo 3. Product Service (Port 8083)
echo 4. API Gateway (Port 8080)
echo 5. Cart Service (Port 8084)
echo 6. Order Service (Port 8085)
echo 7. Payment Service (Port 8086)
echo 8. Notification Service (Port 8087)
echo 9. Delivery Service (Port 8088)
echo 10. Analytics Service (Port 8089)
echo 11. Admin Service (Port 8090)
echo 12. Start All Core Services (Auth, User, Product, Gateway)
echo.
set /p choice="Enter your choice (1-12): "

if "%choice%"=="1" (
    echo Starting Auth Service...
    cd auth-service
    mvn spring-boot:run
) else if "%choice%"=="2" (
    echo Starting User Service...
    cd user-service
    mvn spring-boot:run
) else if "%choice%"=="3" (
    echo Starting Product Service...
    cd product-service
    mvn spring-boot:run
) else if "%choice%"=="4" (
    echo Starting API Gateway...
    cd api-gateway
    mvn spring-boot:run
) else if "%choice%"=="5" (
    echo Starting Cart Service...
    cd cart-service
    mvn spring-boot:run
) else if "%choice%"=="6" (
    echo Starting Order Service...
    cd order-service
    mvn spring-boot:run
) else if "%choice%"=="7" (
    echo Starting Payment Service...
    cd payment-service
    mvn spring-boot:run
) else if "%choice%"=="8" (
    echo Starting Notification Service...
    cd notification-service
    mvn spring-boot:run
) else if "%choice%"=="9" (
    echo Starting Delivery Service...
    cd delivery-service
    mvn spring-boot:run
) else if "%choice%"=="10" (
    echo Starting Analytics Service...
    cd analytics-service
    mvn spring-boot:run
) else if "%choice%"=="11" (
    echo Starting Admin Service...
    cd admin-service
    mvn spring-boot:run
) else if "%choice%"=="12" (
    echo Starting Core Services...
    start "Auth Service" cmd /k "cd auth-service && mvn spring-boot:run"
    timeout /t 3
    start "User Service" cmd /k "cd user-service && mvn spring-boot:run"
    timeout /t 3
    start "Product Service" cmd /k "cd product-service && mvn spring-boot:run"
    timeout /t 3
    start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"
    echo Core services started in separate windows!
) else (
    echo Invalid choice!
)

pause