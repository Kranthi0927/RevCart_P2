@echo off
echo Starting RevCart Microservices Setup...

echo.
echo 1. Starting Consul (make sure Consul is installed)
echo Download Consul from: https://www.consul.io/downloads
echo Run: consul agent -dev
echo.

echo 2. Building all microservices...
call mvn clean install

echo.
echo 3. Services will run on:
echo API Gateway: http://localhost:8080
echo User Service: http://localhost:8081
echo Product Service: http://localhost:8082
echo Order Service: http://localhost:8083
echo Payment Service: http://localhost:8084
echo Notification Service: http://localhost:8085
echo Admin Service: http://localhost:8086
echo.
echo Consul UI: http://localhost:8500
echo.

echo Setup complete! Start each service with: java -jar target/[service-name].jar
pause