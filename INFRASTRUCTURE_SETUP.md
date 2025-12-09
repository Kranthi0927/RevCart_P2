# RevCart - Complete Infrastructure Setup

## 🏗️ Infrastructure Components

This document provides complete infrastructure setup for RevCart microservices platform.

---

## 📋 Prerequisites

### Required Software
- **Java 17+** - [Download](https://adoptium.net/)
- **Maven 3.6+** - [Download](https://maven.apache.org/download.cgi)
- **Node.js 18+** - [Download](https://nodejs.org/)
- **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
- **MySQL 8.0+** - [Download](https://dev.mysql.com/downloads/)
- **Redis** - Via Docker
- **MongoDB** - Via Docker
- **Apache Kafka** - Via Docker
- **Consul** - Via Docker

### System Requirements
- **RAM:** 16GB minimum (32GB recommended)
- **CPU:** 4 cores minimum (8 cores recommended)
- **Disk:** 20GB free space
- **OS:** Windows 10/11, macOS, Linux

---

## 🐳 Docker Infrastructure Setup

### docker-compose.yml

Create this file in `microservices/` directory:

```yaml
version: '3.8'

services:
  # Service Discovery
  consul:
    image: consul:latest
    container_name: revcart-consul
    ports:
      - "8500:8500"
      - "8600:8600/udp"
    command: agent -server -ui -bootstrap-expect=1 -client=0.0.0.0
    environment:
      - CONSUL_BIND_INTERFACE=eth0
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "consul", "members"]
      interval: 10s
      timeout: 5s
      retries: 5

  # MySQL Database
  mysql:
    image: mysql:8.0
    container_name: revcart-mysql
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: revcart
    volumes:
      - mysql-data:/var/lib/mysql
      - ./database-scripts:/docker-entrypoint-initdb.d
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: revcart-redis
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # MongoDB
  mongodb:
    image: mongo:7
    container_name: revcart-mongodb
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin
      MONGO_INITDB_DATABASE: revcart
    volumes:
      - mongodb-data:/data/db
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Zookeeper (for Kafka)
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    container_name: revcart-zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "nc", "-z", "localhost", "2181"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Apache Kafka
  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: revcart-kafka
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
      - "29092:29092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092,PLAINTEXT_INTERNAL://kafka:29092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_INTERNAL:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT_INTERNAL
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
    networks:
      - revcart-network
    healthcheck:
      test: ["CMD", "kafka-broker-api-versions", "--bootstrap-server", "localhost:9092"]
      interval: 10s
      timeout: 10s
      retries: 5

  # Kafka UI (Optional - for monitoring)
  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    container_name: revcart-kafka-ui
    depends_on:
      - kafka
    ports:
      - "8090:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: revcart-cluster
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:29092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
    networks:
      - revcart-network

networks:
  revcart-network:
    driver: bridge

volumes:
  mysql-data:
  redis-data:
  mongodb-data:
```

---

## 🗄️ Database Setup Scripts

### database-scripts/create-databases.sql

```sql
-- Create all microservice databases
CREATE DATABASE IF NOT EXISTS revcart_auth;
CREATE DATABASE IF NOT EXISTS revcart_users;
CREATE DATABASE IF NOT EXISTS revcart_products;
CREATE DATABASE IF NOT EXISTS revcart_orders;
CREATE DATABASE IF NOT EXISTS revcart_payments;
CREATE DATABASE IF NOT EXISTS revcart_delivery;

-- Grant permissions
GRANT ALL PRIVILEGES ON revcart_auth.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revcart_users.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revcart_products.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revcart_orders.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revcart_payments.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revcart_delivery.* TO 'root'@'%';

FLUSH PRIVILEGES;
```

---

## 🚀 Startup Scripts

### start-infrastructure.bat (Windows)

```batch
@echo off
echo ========================================
echo Starting RevCart Infrastructure
echo ========================================

cd microservices

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
echo Kafka UI:      http://localhost:8090
echo MySQL:         localhost:3306
echo Redis:         localhost:6379
echo MongoDB:       localhost:27017
echo Kafka:         localhost:9092
echo ========================================

pause
```

### start-infrastructure.sh (Linux/Mac)

```bash
#!/bin/bash

echo "========================================"
echo "Starting RevCart Infrastructure"
echo "========================================"

cd microservices

echo ""
echo "Starting Docker containers..."
docker-compose up -d

echo ""
echo "Waiting for services to be healthy..."
sleep 30

echo ""
echo "Checking service status..."
docker-compose ps

echo ""
echo "========================================"
echo "Infrastructure Status:"
echo "========================================"
echo "Consul UI:     http://localhost:8500"
echo "Kafka UI:      http://localhost:8090"
echo "MySQL:         localhost:3306"
echo "Redis:         localhost:6379"
echo "MongoDB:       localhost:27017"
echo "Kafka:         localhost:9092"
echo "========================================"
```

### stop-infrastructure.bat (Windows)

```batch
@echo off
echo Stopping RevCart Infrastructure...
cd microservices
docker-compose down
echo Infrastructure stopped.
pause
```

---

## 🔧 Service Configuration

### Consul Configuration

All services auto-register with Consul. Configuration in `application.properties`:

```properties
# Consul Configuration
spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.service-name=${spring.application.name}
spring.cloud.consul.discovery.hostname=localhost
spring.cloud.consul.discovery.prefer-ip-address=true
spring.cloud.consul.discovery.ip-address=127.0.0.1
spring.cloud.consul.discovery.health-check-path=/actuator/health
spring.cloud.consul.discovery.health-check-interval=10s
```

### Kafka Topics Configuration

Create topics manually or let Kafka auto-create:

```bash
# Connect to Kafka container
docker exec -it revcart-kafka bash

# Create topics
kafka-topics --create --topic order-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics --create --topic payment-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics --create --topic notification-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics --create --topic analytics-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

# List topics
kafka-topics --list --bootstrap-server localhost:9092
```

---

## 📊 Monitoring & Health Checks

### Health Check Endpoints

All services expose health endpoints:

```
http://localhost:8080/actuator/health  # API Gateway
http://localhost:8081/actuator/health  # Auth Service
http://localhost:8082/actuator/health  # User Service
http://localhost:8083/actuator/health  # Product Service
http://localhost:8084/actuator/health  # Cart Service
http://localhost:8085/actuator/health  # Order Service
http://localhost:8086/actuator/health  # Payment Service
http://localhost:8087/actuator/health  # Notification Service
http://localhost:8088/actuator/health  # Delivery Service
http://localhost:8089/actuator/health  # Analytics Service
http://localhost:8090/actuator/health  # Admin Service
```

### Consul Dashboard

Access Consul UI: http://localhost:8500

Features:
- Service registry
- Health status
- Service discovery
- Key-value store

### Kafka UI

Access Kafka UI: http://localhost:8090

Features:
- Topic management
- Message browsing
- Consumer groups
- Broker status

---

## 🔐 Security Configuration

### MySQL Security

```sql
-- Create dedicated user (recommended for production)
CREATE USER 'revcart'@'%' IDENTIFIED BY 'SecurePassword123!';
GRANT ALL PRIVILEGES ON revcart_*.* TO 'revcart'@'%';
FLUSH PRIVILEGES;
```

### Redis Security

Add password protection in docker-compose.yml:

```yaml
redis:
  command: redis-server --requirepass YourRedisPassword
```

Update application.properties:

```properties
spring.redis.password=YourRedisPassword
```

### MongoDB Security

Update docker-compose.yml with authentication:

```yaml
mongodb:
  environment:
    MONGO_INITDB_ROOT_USERNAME: revcart
    MONGO_INITDB_ROOT_PASSWORD: SecureMongoPassword
```

---

## 🌐 Network Configuration

### Port Mapping

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| Frontend | 4200 | HTTP | Angular App |
| API Gateway | 8080 | HTTP | API Entry Point |
| Auth Service | 8081 | HTTP | Authentication |
| User Service | 8082 | HTTP | User Management |
| Product Service | 8083 | HTTP | Products |
| Cart Service | 8084 | HTTP | Shopping Cart |
| Order Service | 8085 | HTTP | Orders |
| Payment Service | 8086 | HTTP | Payments |
| Notification Service | 8087 | HTTP/WS | Notifications |
| Delivery Service | 8088 | HTTP | Delivery |
| Analytics Service | 8089 | HTTP | Analytics |
| Admin Service | 8090 | HTTP | Admin Panel |
| Consul | 8500 | HTTP | Service Discovery |
| MySQL | 3306 | TCP | Database |
| Redis | 6379 | TCP | Cache |
| MongoDB | 27017 | TCP | NoSQL DB |
| Kafka | 9092 | TCP | Message Broker |
| Kafka UI | 8090 | HTTP | Kafka Dashboard |

### Firewall Rules (Production)

```bash
# Allow API Gateway
sudo ufw allow 8080/tcp

# Allow Frontend
sudo ufw allow 4200/tcp

# Block direct microservice access (only via Gateway)
sudo ufw deny 8081:8090/tcp

# Allow infrastructure (internal only)
sudo ufw allow from 10.0.0.0/8 to any port 3306
sudo ufw allow from 10.0.0.0/8 to any port 6379
sudo ufw allow from 10.0.0.0/8 to any port 27017
sudo ufw allow from 10.0.0.0/8 to any port 9092
```

---

## 📦 Backup & Recovery

### MySQL Backup

```bash
# Backup all databases
docker exec revcart-mysql mysqldump -u root -proot --all-databases > backup.sql

# Restore
docker exec -i revcart-mysql mysql -u root -proot < backup.sql
```

### MongoDB Backup

```bash
# Backup
docker exec revcart-mongodb mongodump --out /backup

# Restore
docker exec revcart-mongodb mongorestore /backup
```

### Redis Backup

```bash
# Redis automatically saves to disk (AOF enabled)
docker exec revcart-redis redis-cli BGSAVE
```

---

## 🔄 Scaling Infrastructure

### Horizontal Scaling

#### Scale Microservices

```bash
# Run multiple instances
java -jar -Dserver.port=8083 product-service.jar &
java -jar -Dserver.port=8093 product-service.jar &
java -jar -Dserver.port=8103 product-service.jar &
```

Consul automatically load balances between instances.

#### Scale Kafka

Update docker-compose.yml to add more brokers:

```yaml
kafka-2:
  image: confluentinc/cp-kafka:latest
  environment:
    KAFKA_BROKER_ID: 2
    # ... other configs
```

### Vertical Scaling

#### Increase JVM Memory

```bash
java -Xms512m -Xmx2048m -jar service.jar
```

#### Docker Resource Limits

```yaml
services:
  mysql:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
```

---

## 🚀 Production Deployment

### AWS Infrastructure

```
┌─────────────────────────────────────────┐
│         Route 53 (DNS)                  │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│    CloudFront (CDN) + S3 (Frontend)     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│    Application Load Balancer (ALB)      │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│    ECS Fargate / EKS (Microservices)    │
│  - API Gateway                          │
│  - Auth Service                         │
│  - Other Services                       │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         Data Layer                      │
│  - RDS MySQL (Multi-AZ)                 │
│  - ElastiCache Redis (Cluster)          │
│  - DocumentDB (MongoDB Compatible)      │
│  - Amazon MSK (Kafka)                   │
└─────────────────────────────────────────┘
```

### Kubernetes Deployment

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-service
  template:
    metadata:
      labels:
        app: product-service
    spec:
      containers:
      - name: product-service
        image: revcart/product-service:latest
        ports:
        - containerPort: 8083
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
```

---

## 📝 Environment Variables

### Development (.env)

```env
# Database
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=root

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# MongoDB
MONGO_HOST=localhost
MONGO_PORT=27017

# Kafka
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# Consul
CONSUL_HOST=localhost
CONSUL_PORT=8500

# JWT
JWT_SECRET=revCartSecretKeyForJWTTokenGenerationAndValidation2024
JWT_EXPIRATION=86400000
```

### Production (.env.prod)

```env
# Database
MYSQL_HOST=prod-mysql.xxxxx.rds.amazonaws.com
MYSQL_PORT=3306
MYSQL_USER=revcart_prod
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Redis
REDIS_HOST=prod-redis.xxxxx.cache.amazonaws.com
REDIS_PORT=6379

# MongoDB
MONGO_HOST=prod-mongo.xxxxx.docdb.amazonaws.com
MONGO_PORT=27017

# Kafka
KAFKA_BOOTSTRAP_SERVERS=prod-kafka.xxxxx.kafka.amazonaws.com:9092

# Consul
CONSUL_HOST=prod-consul.internal
CONSUL_PORT=8500
```

---

## ✅ Verification Checklist

After infrastructure setup, verify:

- [ ] Consul UI accessible at http://localhost:8500
- [ ] MySQL connection successful
- [ ] Redis ping successful
- [ ] MongoDB connection successful
- [ ] Kafka topics created
- [ ] All Docker containers running
- [ ] Health checks passing
- [ ] Service discovery working
- [ ] Kafka UI accessible at http://localhost:8090

---

## 🆘 Troubleshooting

### Consul Not Starting

```bash
# Check logs
docker logs revcart-consul

# Restart
docker restart revcart-consul
```

### MySQL Connection Issues

```bash
# Check if MySQL is running
docker ps | grep mysql

# Test connection
docker exec -it revcart-mysql mysql -u root -proot

# Check logs
docker logs revcart-mysql
```

### Kafka Issues

```bash
# Check Kafka logs
docker logs revcart-kafka

# Verify Zookeeper
docker logs revcart-zookeeper

# Test connection
docker exec -it revcart-kafka kafka-broker-api-versions --bootstrap-server localhost:9092
```

### Port Conflicts

```bash
# Find process using port
netstat -ano | findstr :8080

# Kill process (Windows)
taskkill /PID <PID> /F

# Kill process (Linux/Mac)
kill -9 <PID>
```

---

This infrastructure setup provides a complete, production-ready environment for RevCart microservices platform.
