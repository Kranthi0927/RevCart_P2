# RevCart - E-Commerce Microservices Platform

A full-stack e-commerce platform built with Spring Boot microservices and Angular frontend.

## Features

- 🔐 OAuth2 Google Authentication
- 🛒 Shopping Cart & Checkout
- 💳 Razorpay Payment Integration
- 📦 Order Management
- 🚚 Delivery Tracking
- 📊 Admin Dashboard
- 🔔 Real-time Notifications
- 📈 Analytics

## Architecture

### Microservices
- **API Gateway** (Port 8080) - Entry point for all requests
- **Auth Service** (Port 8081) - Authentication & OAuth2
- **User Service** (Port 8082) - User management
- **Product Service** (Port 8083) - Product catalog
- **Cart Service** (Port 8084) - Shopping cart
- **Order Service** (Port 8085) - Order processing
- **Payment Service** (Port 8086) - Payment handling
- **Notification Service** (Port 8087) - Notifications
- **Delivery Service** (Port 8088) - Delivery tracking
- **Admin Service** (Port 8089) - Admin operations
- **Analytics Service** (Port 8090) - Analytics & reporting

### Frontend
- **Angular 18** - Modern, responsive UI

## Prerequisites

- Java 17+
- Node.js 18+
- MySQL 8.0+
- MongoDB 6.0+
- Redis 7.0+
- Consul 1.15+
- Docker (optional)

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/Kranthi0927/RevCart_P2.git
cd RevCart_P2
```

### 2. Configure Environment Variables

Create `.env` file in `microservices/auth-service/`:
```properties
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

### 3. Start Infrastructure
```bash
cd microservices
start-infrastructure.bat
```

### 4. Start Microservices
```bash
start-all-microservices.bat
```

### 5. Start Frontend
```bash
cd revcart-frontend
npm install
npm start
```

Access the application at `http://localhost:4200`

## Docker Deployment

Each service includes a Dockerfile for containerization.

### Build individual service:
```bash
cd microservices/auth-service
docker build -t revcart-auth-service .
```

### Build frontend:
```bash
cd revcart-frontend
docker build -t revcart-frontend .
```

## Configuration

### OAuth2 Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create OAuth 2.0 credentials
3. Add authorized redirect URI: `http://localhost:8081/login/oauth2/code/google`
4. Update `.env` file with credentials

### Database Setup
Run the database scripts:
```bash
mysql -u root -p < microservices/database-scripts/create-databases.sql
```

## API Documentation

Swagger UI available at:
- Auth Service: `http://localhost:8081/swagger-ui.html`
- Product Service: `http://localhost:8083/swagger-ui.html`
- (Similar for other services)

## Project Structure

```
RevCart_P2/
├── microservices/
│   ├── api-gateway/
│   ├── auth-service/
│   ├── user-service/
│   ├── product-service/
│   ├── cart-service/
│   ├── order-service/
│   ├── payment-service/
│   ├── notification-service/
│   ├── delivery-service/
│   ├── admin-service/
│   └── analytics-service/
└── revcart-frontend/
```

## Technologies Used

### Backend
- Spring Boot 3.2
- Spring Cloud (Consul, OpenFeign)
- Spring Security + OAuth2
- MySQL + MongoDB
- Redis
- Kafka
- JWT

### Frontend
- Angular 18
- TypeScript
- RxJS
- Bootstrap

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please open an issue on GitHub.
