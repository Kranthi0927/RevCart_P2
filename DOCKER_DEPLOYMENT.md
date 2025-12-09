# RevCart Docker Deployment Guide

## Complete End-to-End Docker Setup

### Prerequisites
- Docker Desktop installed and running
- 8GB RAM minimum
- Ports 8080-8090, 3307, 27018, 6380, 8500 available

### Quick Start

1. **Set Environment Variables**
```bash
# Create .env file in project root (use your actual credentials)
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

2. **Start All Services**
```bash
docker-compose -f docker-compose-fixed.yml up -d
```

3. **Wait for Services to Start (3-5 minutes)**
```bash
# Watch logs
docker-compose -f docker-compose-fixed.yml logs -f
```

4. **Test Services**
```bash
test-services.bat
```

### Service Architecture

#### Infrastructure Services
- **MySQL** (Port 3307) - Main database for auth, user, product, order, payment, delivery
- **MongoDB** (Port 27018) - NoSQL database for cart, notifications, analytics
- **Redis** (Port 6380) - Caching layer
- **Consul** (Port 8500) - Service discovery and health checks

#### Microservices
- **API Gateway** (8080) - Entry point for all requests
- **Auth Service** (8081) - Authentication & OAuth2
- **User Service** (8082) - User management
- **Product Service** (8083) - Product catalog
- **Cart Service** (8084) - Shopping cart
- **Order Service** (8085) - Order processing
- **Payment Service** (8086) - Payment handling
- **Notification Service** (8087) - Notifications
- **Delivery Service** (8088) - Delivery tracking
- **Admin Service** (8089) - Admin operations
- **Analytics Service** (8090) - Analytics & reporting

### Access Points

- **Frontend**: http://localhost (if frontend container is running)
- **API Gateway**: http://localhost:8080
- **Consul UI**: http://localhost:8500
- **Direct Service Access**: http://localhost:808X (where X is service number)

### Testing Individual Services

```bash
# Test Product Service
curl http://localhost:8083/products

# Test Auth Service Health
curl http://localhost:8081/actuator/health

# Test API Gateway
curl http://localhost:8080/actuator/health
```

### Common Issues & Solutions

#### Issue 1: Services showing as unhealthy in Consul
**Cause**: Health check using 127.0.0.1 instead of container hostname
**Solution**: Services are functional, ignore Consul UI status

#### Issue 2: Services not connecting to database
**Cause**: Database not ready when service starts
**Solution**: docker-compose-fixed.yml has health checks, services wait for MySQL

#### Issue 3: Port already in use
**Cause**: Local services running on same ports
**Solution**: Stop local services or change ports in docker-compose

#### Issue 4: Out of memory
**Cause**: All 11 services + infrastructure = high memory usage
**Solution**: Increase Docker Desktop memory to 8GB+

### Monitoring

```bash
# View all container status
docker ps

# View logs for specific service
docker logs revcart-product-service-1 -f

# View resource usage
docker stats

# Check container health
docker inspect revcart-mysql-1 | findstr Health
```

### Stopping Services

```bash
# Stop all services
docker-compose -f docker-compose-fixed.yml down

# Stop and remove volumes (clean slate)
docker-compose -f docker-compose-fixed.yml down -v
```

### Rebuilding After Code Changes

```bash
# Rebuild specific service
docker-compose -f docker-compose-fixed.yml up -d --build product-service

# Rebuild all services
docker-compose -f docker-compose-fixed.yml up -d --build
```

### Database Access

```bash
# MySQL
mysql -h 127.0.0.1 -P 3307 -u root -p
# Password: root

# MongoDB
mongosh mongodb://localhost:27018

# Redis
redis-cli -p 6380
```

### Troubleshooting Commands

```bash
# Restart specific service
docker restart revcart-product-service-1

# View service logs with timestamps
docker logs revcart-product-service-1 --timestamps

# Execute command in container
docker exec -it revcart-product-service-1 sh

# Check network connectivity
docker exec revcart-product-service-1 ping mysql
```

### Performance Optimization

1. **Reduce startup time**: Pre-build images
```bash
docker-compose -f docker-compose-fixed.yml build
```

2. **Limit resources per service**: Add to docker-compose
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
```

3. **Use Docker BuildKit**
```bash
set DOCKER_BUILDKIT=1
```

### Production Deployment

For production, update:
1. Change database passwords
2. Use external databases (AWS RDS, MongoDB Atlas)
3. Add SSL/TLS certificates
4. Configure proper logging (ELK stack)
5. Add monitoring (Prometheus + Grafana)
6. Use Docker Swarm or Kubernetes for orchestration

### Success Criteria

✅ All 11 microservices running
✅ MySQL, MongoDB, Redis, Consul healthy
✅ Products API returns data: `curl http://localhost:8083/products`
✅ Health checks passing: `curl http://localhost:8081/actuator/health`
✅ Frontend accessible (if deployed)

### Support

If services don't start after 5 minutes:
1. Check Docker Desktop has enough resources
2. Run `test-services.bat` to identify failing service
3. Check logs: `docker logs revcart-[service-name]-1`
4. Verify ports are not in use: `netstat -ano | findstr "808"`
