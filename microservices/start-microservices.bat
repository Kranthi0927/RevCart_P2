@echo off
echo ========================================
echo    RevCart Microservices Startup
echo ========================================
echo.

echo Step 1: Starting infrastructure services...
docker-compose up -d consul mysql redis mongodb zookeeper kafka

echo.
echo Waiting for infrastructure to be ready (30 seconds)...
timeout /t 30 /nobreak

echo.
echo Step 2: Starting all microservices...
docker-compose up -d

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
echo - Cart Service:       http://localhost:8084
echo - Order Service:      http://localhost:8085
echo - Payment Service:    http://localhost:8086
echo - Notification:      http://localhost:8087
echo - Delivery Service:   http://localhost:8088
echo - Analytics Service:  http://localhost:8089
echo - Admin Service:      http://localhost:8090
echo.
echo Infrastructure:
echo - Consul UI:          http://localhost:8500
echo - MySQL:              localhost:3307
echo - Redis:              localhost:6379
echo - MongoDB:            localhost:27017
echo.
echo Frontend should connect to: http://localhost:8080/api
echo.
echo Check service health: docker-compose ps
echo View logs: docker-compose logs -f [service-name]
echo.
pause