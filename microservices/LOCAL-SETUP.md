# Local Setup Guide (Without Docker)

## Prerequisites
1. Java 17
2. Maven
3. MySQL (running on localhost:3306)
4. Redis (running on localhost:6379)
5. MongoDB (running on localhost:27017)
6. Consul (running on localhost:8500)

## Step 1: Start Infrastructure Services

### Start Consul
```bash
consul agent -dev
```
Or download from: https://www.consul.io/downloads

### Start MySQL
Ensure MySQL is running on port 3306 with:
- Username: root
- Password: root

### Start Redis
```bash
redis-server
```

### Start MongoDB
```bash
mongod
```

## Step 2: Service Ports Configuration

| Service | Port |
|---------|------|
| api-gateway | 8080 |
| auth-service | 8081 |
| user-service | 8082 |
| product-service | 8083 |
| cart-service | 8084 |
| order-service | 8085 |
| payment-service | 8086 |
| notification-service | 8087 |
| delivery-service | 8088 |
| analytics-service | 8089 |
| admin-service | 8090 |

## Step 3: Start Microservices

Navigate to each service directory and run:
```bash
cd microservices/<service-name>
mvn spring-boot:run
```

### Recommended Startup Order:
1. auth-service (8081)
2. user-service (8082)
3. product-service (8083)
4. cart-service (8084)
5. order-service (8085)
6. payment-service (8086)
7. delivery-service (8088)
8. notification-service (8087)
9. analytics-service (8089)
10. admin-service (8090)
11. api-gateway (8080) - Start this last

## Step 4: Verify Services

Check Consul UI: http://localhost:8500
Check API Gateway: http://localhost:8080/actuator/health

## Notes
- All services are configured to use localhost for Consul
- Databases will be created automatically
- Feign clients are configured for service-to-service communication via Consul
