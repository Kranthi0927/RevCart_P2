# RevCart Microservices Architecture

## Services Overview

| Service | Port | Database | Responsibility |
|---------|------|----------|----------------|
| API Gateway | 8080 | - | Request routing, load balancing |
| User Service | 8081 | MySQL (user_db) | Authentication, profile, address management |
| Product Service | 8082 | MySQL (product_db) | Product catalog, pricing, category management |
| Cart Service | 8083 | Redis | Cart management, quantity updates, session persistence |
| Order Service | 8084 | MySQL (order_db) | Order placement, status updates, history |
| Payment Service | 8085 | MySQL (payment_db) | Payment processing, refunds, invoice generation |
| Delivery Service | 8086 | MySQL (delivery_db) | Delivery agent management, live tracking |
| Notification Service | 8087 | MongoDB | Order and delivery notifications |
| Analytics Service | 8088 | MongoDB | Sales trends, customer insights |

## Infrastructure Services

| Service | Port | Purpose |
|---------|------|---------|
| Consul | 8500 | Service Discovery |
| MySQL | 3306 | Primary Database |
| Redis | 6379 | Caching & Session Storage |
| MongoDB | 27017 | Document Storage |
| Kafka | 9092 | Message Queue |
| Keycloak | 8080 | Identity Provider |

## Quick Start

### 1. Start Infrastructure
```bash
# Start all infrastructure services
start-infrastructure.bat

# Or manually with Docker Compose
docker-compose up -d
```

### 2. Setup Databases
```bash
# Connect to MySQL and run
mysql -u root -p < database-scripts/create-databases.sql
```

### 3. Start Microservices
```bash
# Start all microservices
start-all-microservices.bat

# Or start individually
cd user-service && mvn spring-boot:run
cd product-service && mvn spring-boot:run
# ... etc
```

## Technology Stack

### Core Technologies
- **Spring Boot 3.1.0** - Microservice framework
- **Spring Cloud 2022.0.3** - Cloud-native patterns
- **Consul** - Service discovery and configuration
- **OpenFeign** - Service-to-service communication

### Databases
- **MySQL 8.0** - Relational data (Users, Products, Orders, Payments, Delivery)
- **Redis 7** - Caching and session storage (Cart)
- **MongoDB 6.0** - Document storage (Notifications, Analytics)

### Message Queue
- **Apache Kafka** - Event streaming and async communication

### Security & Authentication
- **Keycloak** - Identity and access management
- **Spring Security** - Application security
- **JWT** - Token-based authentication

### External Integrations
- **AWS S3** - Product image storage
- **Razorpay/Stripe** - Payment processing
- **WebSocket** - Real-time notifications

## Service Communication

```
Frontend → API Gateway → Microservices
                ↓
        Service Discovery (Consul)
                ↓
        Load Balancing & Routing
```

## Development Guidelines

### Database Per Service
Each microservice has its own database to ensure loose coupling:
- User Service → user_db
- Product Service → product_db  
- Order Service → order_db
- Payment Service → payment_db
- Delivery Service → delivery_db
- Cart Service → Redis
- Notification Service → MongoDB
- Analytics Service → MongoDB

### API Design
- RESTful APIs with proper HTTP methods
- Consistent response formats
- Proper error handling
- API versioning support

### Configuration Management
- Environment-specific configurations
- Externalized configuration via Consul
- Secure credential management

## Monitoring & Health Checks

All services expose:
- `/actuator/health` - Health check endpoint
- `/actuator/info` - Service information
- Consul health checks every 10 seconds

## Deployment

### Local Development
1. Start infrastructure services
2. Start microservices in dependency order
3. Access via API Gateway on port 8080

### Production Considerations
- Container orchestration (Kubernetes/Docker Swarm)
- Load balancers for high availability
- Database clustering and replication
- Monitoring and logging (ELK stack)
- CI/CD pipelines

## API Endpoints

### User Service (8081)
- `POST /api/users/register` - User registration
- `POST /api/users/login` - User authentication
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `GET /api/users/addresses` - Get user addresses

### Product Service (8082)
- `GET /api/products` - List products
- `GET /api/products/{id}` - Get product details
- `POST /api/products` - Create product (admin)
- `PUT /api/products/{id}` - Update product (admin)
- `GET /api/products/category/{category}` - Products by category

### Cart Service (8083)
- `GET /api/cart/{sessionId}` - Get cart items
- `POST /api/cart/{sessionId}/add` - Add to cart
- `DELETE /api/cart/item/{itemId}` - Remove from cart
- `DELETE /api/cart/{sessionId}/clear` - Clear cart

### Order Service (8084)
- `POST /api/orders` - Place order
- `GET /api/orders/{userId}` - Get user orders
- `GET /api/orders/{id}` - Get order details
- `PUT /api/orders/{id}/status` - Update order status

### Payment Service (8085)
- `POST /api/payments/process` - Process payment
- `GET /api/payments/{orderId}` - Get payment status
- `POST /api/payments/refund` - Process refund

## Environment Variables

Create `.env` file for sensitive configurations:
```
# Database
MYSQL_ROOT_PASSWORD=your_password
USER_DB_PASSWORD=user_password
PRODUCT_DB_PASSWORD=product_password

# AWS
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# Payment Gateways
RAZORPAY_KEY_ID=your_razorpay_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
STRIPE_API_KEY=your_stripe_key

# Email
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
```