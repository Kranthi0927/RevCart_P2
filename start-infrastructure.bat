@echo off
echo ========================================
echo Starting RevCart Infrastructure
echo ========================================

cd Revcart\microservices

echo.
echo Starting Docker containers...
docker-compose up -d

echo.
echo Waiting for services to be healthy...
timeout /t 30 /nobreak

echo.
echo Checking service status...
docker-compose ps

echo.
echo ========================================
echo Infrastructure Status:
echo ========================================
echo Consul UI:     http://localhost:8500
echo Kafka UI:      http://localhost:8091
echo MySQL:         localhost:3306
echo Redis:         localhost:6379
echo MongoDB:       localhost:27017
echo Kafka:         localhost:9092
echo ========================================
echo.
echo Infrastructure is ready!
echo You can now start the microservices.
echo.

pause
