@echo off
echo Testing RevCart Microservices...
echo.

echo Testing Infrastructure:
echo [MySQL] 
curl -s http://localhost:3307 >nul 2>&1 && echo OK || echo FAIL
echo [MongoDB]
curl -s http://localhost:27018 >nul 2>&1 && echo OK || echo FAIL
echo [Redis]
curl -s http://localhost:6380 >nul 2>&1 && echo OK || echo FAIL
echo [Consul]
curl -s http://localhost:8500/v1/status/leader >nul 2>&1 && echo OK || echo FAIL
echo.

echo Testing Microservices:
echo [Auth Service - 8081]
curl -s http://localhost:8081/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [User Service - 8082]
curl -s http://localhost:8082/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Product Service - 8083]
curl -s http://localhost:8083/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Cart Service - 8084]
curl -s http://localhost:8084/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Order Service - 8085]
curl -s http://localhost:8085/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Payment Service - 8086]
curl -s http://localhost:8086/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Notification Service - 8087]
curl -s http://localhost:8087/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Delivery Service - 8088]
curl -s http://localhost:8088/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Admin Service - 8089]
curl -s http://localhost:8089/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [Analytics Service - 8090]
curl -s http://localhost:8090/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo [API Gateway - 8080]
curl -s http://localhost:8080/actuator/health | findstr "UP" >nul && echo OK || echo FAIL

echo.
echo Testing Product API:
curl -s http://localhost:8083/products?size=1 | findstr "name" >nul && echo Products API: OK || echo Products API: FAIL

echo.
echo All tests complete!
pause
