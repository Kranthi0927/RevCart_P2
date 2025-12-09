@echo off
echo Starting microservices without database...

echo Starting Auth Service (No DB)...
start "Auth Service" cmd /k "cd auth-service && mvn spring-boot:run -Dspring-boot.run.profiles=local"

timeout /t 5

echo Starting API Gateway...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"

echo.
echo Services started without database dependencies!
echo - Auth Service: http://localhost:8081/actuator/health
echo - API Gateway: http://localhost:8080/actuator/health
pause