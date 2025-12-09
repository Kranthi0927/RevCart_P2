# Quick Start - Microservices

## \ud83d\ude80 Fastest Way to Run

```bash
start-microservices.bat
```

That's it! This will:
1. Start all infrastructure (Consul, MySQL, Redis, MongoDB, Kafka)
2. Start all 11 microservices
3. Start the Angular frontend

## \ud83d\udd17 Access URLs

- **Application:** http://localhost:4200
- **API Gateway:** http://localhost:8080
- **Consul Dashboard:** http://localhost:8500

## \ud83d\udcca Service Status

Check if services are running:
- Consul UI: http://localhost:8500/ui/dc1/services
- Each service health: http://localhost:808X/actuator/health

## \ud83d\udeab Troubleshooting

### Services not starting?
```bash
# Check if ports are available
netstat -ano | findstr "8080 8081 8082"

# Restart infrastructure
cd microservices
docker-compose restart
```

### Database connection issues?
```bash
# Check MySQL is running
docker ps | findstr mysql

# Connect to MySQL
docker exec -it mysql mysql -uroot -ppassword
```

### Frontend not connecting?
- Verify API Gateway is running on port 8080
- Check browser console for errors
- Ensure environment.ts points to http://localhost:8080/api

## \ud83d\udcdd Demo Accounts

- **Customer:** customer@demo.com / password123
- **Admin:** admin@demo.com / password123
- **Delivery:** delivery@demo.com / password123

## \ud83d\udd0d Architecture

```
Frontend (4200)
    \u2193
API Gateway (8080)
    \u2193
Consul Service Discovery (8500)
    \u2193
Microservices (8081-8090)
    \u2193
Databases (MySQL, Redis, MongoDB)
```

## \ud83d\udee0\ufe0f Development Mode

Start only what you need:

```bash
# Infrastructure only
cd microservices
docker-compose up -d consul mysql redis

# Specific services
cd auth-service && mvn spring-boot:run
cd product-service && mvn spring-boot:run
cd cart-service && mvn spring-boot:run
```

## \ud83d\udcda More Info

- Full documentation: [microservices/README.md](microservices/README.md)
- Migration guide: [MICROSERVICES_MIGRATION.md](MICROSERVICES_MIGRATION.md)
