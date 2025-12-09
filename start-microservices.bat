@echo off
echo ========================================
echo RevCart Microservices Architecture
echo ========================================
echo.
echo Starting Infrastructure Services...
cd microservices
start "Infrastructure" cmd /k "docker-compose up -d consul mysql redis mongodb zookeeper kafka"
echo.
echo Waiting 30 seconds for infrastructure to initialize...
timeout /t 30 /nobreak
echo.
echo Starting Microservices...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"
timeout /t 5 /nobreak
start "Auth Service" cmd /k "cd auth-service && mvn spring-boot:run"
start "User Service" cmd /k "cd user-service && mvn spring-boot:run"
start "Product Service" cmd /k "cd product-service && mvn spring-boot:run"
start "Cart Service" cmd /k "cd cart-service && mvn spring-boot:run"
start "Order Service" cmd /k "cd order-service && mvn spring-boot:run"
start "Payment Service" cmd /k "cd payment-service && mvn spring-boot:run"
start "Notification Service" cmd /k "cd notification-service && mvn spring-boot:run"
start "Delivery Service" cmd /k "cd delivery-service && mvn spring-boot:run"
start "Analytics Service" cmd /k "cd analytics-service && mvn spring-boot:run"
start "Admin Service" cmd /k "cd admin-service && mvn spring-boot:run"
cd ..
echo.
echo Waiting 60 seconds for services to start...
timeout /t 60 /nobreak
echo.
echo Starting Frontend...
start "Frontend" cmd /k "cd revcart-frontend && npm start"
echo.
echo ========================================
echo All Services Started!
echo ========================================
echo API Gateway: http://localhost:8080
echo Consul UI: http://localhost:8500
echo Frontend: http://localhost:4200
echo.
pause
