@echo off
echo Starting Infrastructure Services...

echo Starting Docker Compose...
docker-compose up -d

echo Waiting for services to start...
timeout /t 30

echo Infrastructure services started!
echo - Consul: http://localhost:8500
echo - MySQL: localhost:3306
echo - Redis: localhost:6379
echo - MongoDB: localhost:27017
echo - Kafka: localhost:9092
echo - Keycloak: http://localhost:8080

pause