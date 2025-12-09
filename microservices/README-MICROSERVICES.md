# RevCart Microservices Architecture

## Overview
This project has been migrated from a monolithic backend to a microservices architecture. All backend functionality has been distributed across dedicated microservices.

## Architecture

### Microservices
1. **API Gateway** (Port 8080) - Routes requests to appropriate microservices
2. **Auth Service** (Port 8081) - Authentication, JWT tokens, OTP verification
3. **User Service** (Port 8082) - User management, profiles, addresses
4. **Product Service** (Port 8083) - Product catalog, categories, inventory
5. **Cart Service** (Port 8084) - Shopping cart operations
6. **Order Service** (Port 8085) - Order processing, order history
7. **Payment Service** (Port 8086) - Payment processing, transactions
8. **Notification Service** (Port 8087) - Email, SMS, push notifications
9. **Delivery Service** (Port 8088) - Delivery tracking, logistics
10. **Analytics Service** (Port 8089) - Business analytics, reporting
11. **Admin Service** (Port 8090) - Admin dashboard, system management

### Infrastructure Services
- **Consul** (Port 8500) - Service discovery and configuration
- **MySQL** (Port 3307) - Primary database for most services
- **Redis** (Port 6379) - Caching and session storage
- **MongoDB** (Port 27017) - Analytics and logging data
- **Kafka** (Port 9092) - Message queue for async communication
- **Zookeeper** (Port 2181) - Kafka coordination

## Quick Start

### Prerequisites
- Java 17+
- Maven 3.6+
- Docker & Docker Compose

### Migration from Monolith
1. Run the migration script:
   ```bash
   cd microservices
   migrate-to-microservices.bat
   ```

### Manual Setup
1. **Build all services:**
   ```bash
   mvn clean package -DskipTests
   ```

2. **Start infrastructure:**
   ```bash
   docker-compose up -d consul mysql redis mongodb zookeeper kafka
   ```

3. **Start microservices:**
   ```bash
   docker-compose up -d
   ```

### Service Health Check
- Consul UI: http://localhost:8500
- API Gateway Health: http://localhost:8080/actuator/health
- Individual service health: http://localhost:808X/actuator/health

## API Endpoints

All requests go through the API Gateway at `http://localhost:8080/api`

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `POST /api/auth/forgot-password` - Password reset
- `POST /api/auth/verify-email` - Email verification

### Users
- `GET /api/users/{id}` - Get user by ID
- `GET /api/users/email/{email}` - Get user by email
- `PUT /api/users/{id}` - Update user profile

### Products
- `GET /api/products` - Get all products (paginated)
- `GET /api/products/{id}` - Get product by ID
- `GET /api/products/category/{category}` - Get products by category
- `POST /api/products` - Create product (admin)
- `PUT /api/products/{id}` - Update product (admin)
- `DELETE /api/products/{id}` - Delete product (admin)

### Cart
- `GET /api/cart/{userId}` - Get user's cart
- `POST /api/cart/add` - Add item to cart
- `PUT /api/cart/update` - Update cart item
- `DELETE /api/cart/remove/{itemId}` - Remove item from cart

### Orders
- `GET /api/orders/user/{userId}` - Get user's orders
- `POST /api/orders` - Create new order
- `GET /api/orders/{orderId}` - Get order details
- `PUT /api/orders/{orderId}/status` - Update order status

## Database Schema

Each service has its own database schema:
- **auth-service** → `revcart_auth`
- **user-service** → `revcart_users`
- **product-service** → `revcart_products`
- **cart-service** → Uses Redis for session storage
- **order-service** → `revcart_orders`
- **payment-service** → `revcart_payments`
- **analytics-service** → Uses MongoDB

## Configuration

### Environment Variables
- `SPRING_PROFILES_ACTIVE=docker` - Activates Docker profile
- Database connections are configured per service
- Consul discovery is enabled for all services

### Service Discovery
All services register with Consul for:
- Service discovery
- Load balancing
- Health monitoring
- Configuration management

## Development

### Adding New Microservice
1. Create new module in `microservices/` directory
2. Add to parent `pom.xml` modules section
3. Create Dockerfile
4. Add service to `docker-compose.yml`
5. Configure routes in API Gateway

### Inter-Service Communication
Services communicate via:
- **Synchronous**: OpenFeign clients for REST calls
- **Asynchronous**: Kafka for event-driven communication
- **Caching**: Redis for shared session data

## Monitoring & Observability

### Health Checks
- Spring Boot Actuator endpoints
- Consul health monitoring
- Docker container health checks

### Logging
- Centralized logging to MongoDB
- Service-specific log levels
- Request tracing across services

## Security

### Authentication Flow
1. User authenticates via Auth Service
2. JWT token issued and validated
3. API Gateway forwards authenticated requests
4. Services validate tokens independently

### Database Security
- Separate databases per service
- Connection pooling and encryption
- Environment-based credentials

## Deployment

### Docker Compose (Development)
```bash
docker-compose up -d
```

### Production Considerations
- Use Kubernetes for orchestration
- Implement circuit breakers
- Add monitoring (Prometheus/Grafana)
- Configure proper logging aggregation
- Set up backup strategies per service

## Migration Notes

### What Was Moved
- **Backend folder removed** - All functionality distributed to microservices
- **Monolithic controllers** → Service-specific controllers
- **Shared entities** → Service-specific models
- **Single database** → Multiple service databases
- **Direct calls** → Service discovery + API Gateway

### Breaking Changes
- API endpoints now prefixed with `/api`
- Authentication handled by dedicated service
- Database connections per service
- Configuration distributed across services

## Troubleshooting

### Common Issues
1. **Service not registering with Consul**
   - Check Consul connectivity
   - Verify service configuration

2. **Database connection errors**
   - Ensure MySQL is running
   - Check database credentials

3. **API Gateway routing issues**
   - Verify service registration
   - Check route configuration

### Logs
```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f auth-service
```

## Next Steps
1. Implement circuit breakers (Hystrix/Resilience4j)
2. Add distributed tracing (Zipkin/Jaeger)
3. Implement API rate limiting
4. Add comprehensive monitoring
5. Set up CI/CD pipelines per service