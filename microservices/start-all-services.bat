@echo off
echo Starting RevCart Microservices...

echo Starting API Gateway...
start "API Gateway" cmd /k "cd api-gateway && java -jar target/api-gateway-1.0.0.jar"

timeout /t 5

echo Starting User Service...
start "User Service" cmd /k "cd user-service && java -jar target/user-service-1.0.0.jar"

timeout /t 3

echo Starting Product Service...
start "Product Service" cmd /k "cd product-service && java -jar target/product-service-1.0.0.jar"

timeout /t 3

echo Starting Order Service...
start "Order Service" cmd /k "cd order-service && java -jar target/order-service-1.0.0.jar"

echo All services started!
echo Check Consul UI: http://localhost:8500
echo API Gateway: http://localhost:8080
pause