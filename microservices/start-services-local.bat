@echo off
echo ========================================
echo    RevCart Microservices (Local Mode)
echo ========================================
echo.

echo Starting microservices locally...
echo.

echo Starting Auth Service on port 8081...
start "Auth Service" cmd /k "cd auth-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8081"

timeout /t 5

echo Starting User Service on port 8082...
start "User Service" cmd /k "cd user-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082"

timeout /t 5

echo Starting Product Service on port 8083...
start "Product Service" cmd /k "cd product-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8083"

timeout /t 5

echo Starting API Gateway on port 8080...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8080"

echo.
echo ========================================
echo    Microservices Started Successfully!
echo ========================================
echo.
echo Services Available:
echo - API Gateway:        http://localhost:8080
echo - Auth Service:       http://localhost:8081
echo - User Service:       http://localhost:8082  
echo - Product Service:    http://localhost:8083
echo.
echo Note: Other services can be started similarly
echo Frontend should connect to: http://localhost:8080/api
echo.
pause