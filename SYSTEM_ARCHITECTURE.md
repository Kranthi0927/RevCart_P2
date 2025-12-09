# RevCart - Complete System Architecture

## 🏗️ Architecture Overview

RevCart is a **microservices-based e-commerce platform** for grocery delivery built with modern cloud-native patterns.

### Architecture Type
- **Microservices Architecture** with API Gateway pattern
- **Event-Driven** communication using Kafka
- **Service Discovery** with Consul
- **Distributed Caching** with Redis
- **Polyglot Persistence** (MySQL + MongoDB)

---

## 📊 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         Angular 18 Frontend (Port 4200)                   │   │
│  │  - Standalone Components  - RxJS  - WebSocket            │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↓ HTTPS/WSS
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                           │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │      Spring Cloud Gateway (Port 8080)                     │   │
│  │  - JWT Authentication  - Rate Limiting  - CORS           │   │
│  │  - Load Balancing     - Circuit Breaker                  │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                   SERVICE DISCOVERY LAYER                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │           Consul (Port 8500)                              │   │
│  │  - Service Registry  - Health Checks  - Config Store     │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    MICROSERVICES LAYER                           │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Auth Service  │  │User Service  │  │Product Svc   │          │
│  │Port: 8081    │  │Port: 8082    │  │Port: 8083    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Cart Service  │  │Order Service │  │Payment Svc   │          │
│  │Port: 8084    │  │Port: 8085    │  │Port: 8086    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Notification  │  │Delivery Svc  │  │Analytics Svc │          │
│  │Port: 8087    │  │Port: 8088    │  │Port: 8089    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐                                                │
│  │Admin Service │                                                │
│  │Port: 8090    │                                                │
│  └──────────────┘                                                │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    MESSAGE BROKER LAYER                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         Apache Kafka (Port 9092)                          │   │
│  │  - Order Events  - Notification Events  - Analytics      │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER                                  │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │MySQL         │  │Redis         │  │MongoDB       │          │
│  │Port: 3306    │  │Port: 6379    │  │Port: 27017   │          │
│  │              │  │              │  │              │          │
│  │- Users       │  │- Cart Data   │  │- Logs        │          │
│  │- Products    │  │- Sessions    │  │- Notifications│         │
│  │- Orders      │  │- Cache       │  │- Analytics   │          │
│  │- Payments    │  │              │  │              │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Microservices Details

### 1. API Gateway (Port 8080)
**Technology:** Spring Cloud Gateway
**Responsibilities:**
- Request routing to microservices
- JWT token validation
- CORS handling
- Rate limiting
- Load balancing
- Circuit breaker pattern

**Key Features:**
- Routes all `/api/*` requests to appropriate services
- Validates JWT tokens before forwarding
- Service discovery integration with Consul

---

### 2. Auth Service (Port 8081)
**Database:** MySQL (revcart_auth)
**Responsibilities:**
- User authentication (login/signup)
- JWT token generation & validation
- OAuth2 integration (Google)
- Password management
- Email verification

**API Endpoints:**
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `POST /api/auth/refresh` - Token refresh
- `POST /api/auth/forgot-password` - Password reset

**Dependencies:**
- Spring Security
- JWT (jjwt)
- Spring Mail
- OAuth2 Client

---

### 3. User Service (Port 8082)
**Database:** MySQL (revcart_users)
**Responsibilities:**
- User profile management
- Address management
- User preferences
- Profile updates

**API Endpoints:**
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `POST /api/users/address` - Add address
- `GET /api/users/addresses` - Get all addresses

---

### 4. Product Service (Port 8083)
**Database:** MySQL (revcart_products)
**Responsibilities:**
- Product catalog management
- Category management
- Product search & filtering
- Inventory tracking

**API Endpoints:**
- `GET /api/products` - List all products
- `GET /api/products/{id}` - Get product details
- `GET /api/products/category/{category}` - Filter by category
- `POST /api/products/search` - Search products

**Features:**
- Category-based filtering
- Price range filtering
- Stock management
- Product images handling

---

### 5. Cart Service (Port 8084)
**Database:** Redis (In-memory)
**Responsibilities:**
- Shopping cart management
- Real-time cart updates
- Cart persistence
- Cart expiration

**API Endpoints:**
- `POST /api/cart/add` - Add item to cart
- `GET /api/cart` - Get cart items
- `PUT /api/cart/update` - Update quantity
- `DELETE /api/cart/remove/{id}` - Remove item

**Features:**
- Redis-based fast access
- Session-based cart storage
- Auto-expiration after 24 hours

---

### 6. Order Service (Port 8085)
**Database:** MySQL (revcart_orders)
**Responsibilities:**
- Order creation & management
- Order status tracking
- Order history
- Order cancellation

**API Endpoints:**
- `POST /api/orders` - Create order
- `GET /api/orders/user` - Get user orders
- `GET /api/orders/{id}` - Get order details
- `PUT /api/orders/{id}/status` - Update status

**Order States:**
1. PENDING
2. CONFIRMED
3. PREPARING
4. OUT_FOR_DELIVERY
5. DELIVERED
6. CANCELLED

**Kafka Events:**
- Publishes `order.created` event
- Publishes `order.status.updated` event

---

### 7. Payment Service (Port 8086)
**Database:** MySQL (revcart_payments)
**Responsibilities:**
- Payment processing
- Razorpay integration
- Payment verification
- Refund handling

**API Endpoints:**
- `POST /api/payments/create` - Create payment
- `POST /api/payments/verify` - Verify payment
- `GET /api/payments/{orderId}` - Get payment status
- `POST /api/payments/refund` - Process refund

**Payment Methods:**
- Razorpay (UPI, Cards, Wallets)
- Cash on Delivery

---

### 8. Notification Service (Port 8087)
**Database:** MongoDB (revcart_notifications)
**Responsibilities:**
- Email notifications
- SMS notifications
- Push notifications
- WebSocket real-time updates

**Kafka Consumers:**
- Listens to `order.created`
- Listens to `order.status.updated`
- Listens to `payment.completed`

**Notification Types:**
- Order confirmation
- Order status updates
- Delivery updates
- Payment confirmations

---

### 9. Delivery Service (Port 8088)
**Database:** MySQL (revcart_delivery)
**Responsibilities:**
- Delivery assignment
- Delivery tracking
- Delivery agent management
- Route optimization

**API Endpoints:**
- `GET /api/delivery/orders` - Get assigned orders
- `PUT /api/delivery/{id}/status` - Update delivery status
- `GET /api/delivery/track/{orderId}` - Track delivery

**Delivery States:**
- ASSIGNED
- PICKED_UP
- IN_TRANSIT
- DELIVERED

---

### 10. Analytics Service (Port 8089)
**Database:** MongoDB (revcart_analytics)
**Responsibilities:**
- Business analytics
- Sales reports
- User behavior tracking
- Performance metrics

**API Endpoints:**
- `GET /api/analytics/sales` - Sales analytics
- `GET /api/analytics/products` - Product analytics
- `GET /api/analytics/users` - User analytics
- `GET /api/analytics/dashboard` - Dashboard metrics

---

### 11. Admin Service (Port 8090)
**Database:** MySQL (shared with other services)
**Responsibilities:**
- Admin dashboard
- Product management (CRUD)
- Order management
- User management
- System monitoring

**API Endpoints:**
- `GET /api/admin/dashboard` - Dashboard stats
- `POST /api/admin/products` - Add product
- `PUT /api/admin/products/{id}` - Update product
- `DELETE /api/admin/products/{id}` - Delete product
- `GET /api/admin/orders` - All orders
- `GET /api/admin/users` - All users

---

## 🔄 Communication Patterns

### Synchronous Communication
- **REST APIs** via Spring Cloud OpenFeign
- **Service-to-Service** calls through API Gateway
- **Load Balanced** using Spring Cloud LoadBalancer

### Asynchronous Communication
- **Apache Kafka** for event streaming
- **Event Topics:**
  - `order-events` - Order lifecycle events
  - `payment-events` - Payment events
  - `notification-events` - Notification triggers
  - `analytics-events` - Analytics data

### Real-time Communication
- **WebSocket** for live updates
- **STOMP Protocol** over SockJS
- **Use Cases:**
  - Order status updates
  - Delivery tracking
  - Admin notifications

---

## 💾 Database Architecture

### MySQL Databases (Port 3306)
```
revcart_auth       → Auth Service
revcart_users      → User Service
revcart_products   → Product Service
revcart_orders     → Order Service
revcart_payments   → Payment Service
revcart_delivery   → Delivery Service
```

### Redis (Port 6379)
- **Cart Service** - Shopping cart data
- **Session Management** - User sessions
- **Caching Layer** - Frequently accessed data

### MongoDB (Port 27017)
```
revcart_notifications → Notification Service
revcart_analytics     → Analytics Service
revcart_logs          → Application logs
```

---

## 🔐 Security Architecture

### Authentication Flow
1. User sends credentials to Auth Service
2. Auth Service validates and generates JWT
3. JWT contains: userId, email, role, expiration
4. Client stores JWT in localStorage
5. All requests include JWT in Authorization header
6. API Gateway validates JWT before routing

### Authorization
- **Role-Based Access Control (RBAC)**
- **Roles:** CUSTOMER, ADMIN, DELIVERY_AGENT
- **JWT Claims** include user role
- **Service-level** authorization checks

### Security Features
- JWT token expiration (24 hours)
- Password encryption (BCrypt)
- HTTPS enforcement
- CORS configuration
- Rate limiting
- SQL injection prevention (JPA)

---

## 📈 Scalability & Performance

### Horizontal Scaling
- Each microservice can scale independently
- Load balancing via Spring Cloud LoadBalancer
- Stateless services (except Cart Service)

### Caching Strategy
- **Redis** for cart and session data
- **Application-level** caching for products
- **Database query** optimization

### Performance Optimizations
- Connection pooling (HikariCP)
- Lazy loading in JPA
- Pagination for large datasets
- Async processing with Kafka
- CDN for static assets

---

## 🔍 Monitoring & Observability

### Health Checks
- Spring Boot Actuator on all services
- `/actuator/health` endpoint
- Consul health monitoring (10s interval)

### Logging
- Centralized logging to MongoDB
- Log levels: INFO, WARN, ERROR
- Request/Response logging in Gateway

### Metrics
- Service availability metrics
- Response time tracking
- Error rate monitoring
- Business metrics in Analytics Service

---

## 🚀 Deployment Architecture

### Local Development
- All services run on localhost
- Different ports for each service
- Shared databases

### Production (Recommended)
```
┌─────────────────────────────────────────┐
│         Load Balancer (AWS ALB)         │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      API Gateway (ECS/Kubernetes)       │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│    Microservices (ECS/Kubernetes)       │
│  - Auto-scaling groups                  │
│  - Container orchestration              │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         Data Layer                      │
│  - RDS (MySQL)                          │
│  - ElastiCache (Redis)                  │
│  - DocumentDB (MongoDB)                 │
│  - MSK (Kafka)                          │
└─────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack Summary

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | Angular | 18.0.0 |
| Backend | Spring Boot | 3.1.0 |
| Cloud | Spring Cloud | 2022.0.3 |
| Gateway | Spring Cloud Gateway | - |
| Discovery | Consul | Latest |
| Message Broker | Apache Kafka | Latest |
| Cache | Redis | Latest |
| Database | MySQL | 8.0+ |
| NoSQL | MongoDB | Latest |
| Build | Maven | 3.6+ |
| Java | OpenJDK | 17 |
| Node | Node.js | 18+ |

---

## 📦 Service Dependencies

```
API Gateway
  ├── Consul (Service Discovery)
  └── All Microservices

Auth Service
  ├── MySQL
  ├── Consul
  └── Spring Mail

User Service
  ├── MySQL
  ├── Consul
  └── Auth Service (Feign)

Product Service
  ├── MySQL
  └── Consul

Cart Service
  ├── Redis
  ├── Consul
  └── Product Service (Feign)

Order Service
  ├── MySQL
  ├── Kafka (Producer)
  ├── Consul
  ├── Cart Service (Feign)
  └── Product Service (Feign)

Payment Service
  ├── MySQL
  ├── Kafka (Producer)
  ├── Consul
  └── Razorpay API

Notification Service
  ├── MongoDB
  ├── Kafka (Consumer)
  ├── Consul
  └── WebSocket

Delivery Service
  ├── MySQL
  ├── Kafka (Producer/Consumer)
  └── Consul

Analytics Service
  ├── MongoDB
  ├── Kafka (Consumer)
  └── Consul

Admin Service
  ├── MySQL
  ├── Consul
  └── All Services (Feign)
```

---

## 🔄 Data Flow Examples

### Order Placement Flow
1. User adds items to cart (Cart Service → Redis)
2. User proceeds to checkout (Frontend → API Gateway)
3. Order created (Order Service → MySQL)
4. Kafka event published: `order.created`
5. Payment initiated (Payment Service → Razorpay)
6. Payment verified (Payment Service → MySQL)
7. Kafka event published: `payment.completed`
8. Notification sent (Notification Service → Email/SMS)
9. Delivery assigned (Delivery Service → MySQL)
10. Real-time updates (WebSocket → Frontend)

### Product Search Flow
1. User searches product (Frontend → API Gateway)
2. Request routed (API Gateway → Product Service)
3. Database query (Product Service → MySQL)
4. Results cached (Product Service → Redis)
5. Response returned (Product Service → Frontend)

---

## 📝 Best Practices Implemented

1. **Microservices Principles**
   - Single Responsibility
   - Independent deployment
   - Database per service

2. **Cloud-Native Patterns**
   - Service Discovery
   - API Gateway
   - Circuit Breaker
   - Event-Driven Architecture

3. **Security**
   - JWT authentication
   - Role-based authorization
   - Encrypted passwords
   - HTTPS enforcement

4. **Performance**
   - Caching with Redis
   - Async processing with Kafka
   - Connection pooling
   - Pagination

5. **Resilience**
   - Health checks
   - Circuit breakers
   - Retry mechanisms
   - Graceful degradation

---

This architecture provides a scalable, maintainable, and production-ready e-commerce platform.
