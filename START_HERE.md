# 🚀 START HERE - RevCart Microservices

## ✅ Backend Removed - Now Running Microservices!

The monolithic backend has been completely removed. RevCart now runs on a modern microservices architecture.

## 🎯 Quick Start

```bash
start-microservices.bat
```

This single command will:
1. Start infrastructure (Consul, MySQL, Redis, MongoDB, Kafka)
2. Start all 11 microservices
3. Start the Angular frontend

## 🌐 Access the Application

- **Frontend:** http://localhost:4200
- **API Gateway:** http://localhost:8080
- **Consul Dashboard:** http://localhost:8500

## 📚 Documentation

1. **Quick Start:** [QUICK_START_MICROSERVICES.md](QUICK_START_MICROSERVICES.md)
2. **Migration Details:** [MIGRATION_COMPLETE.md](MIGRATION_COMPLETE.md)
3. **Architecture Guide:** [microservices/README.md](microservices/README.md)
4. **Main README:** [README.md](README.md)

## 🏗️ Architecture

```
Frontend (Angular)
    ↓
API Gateway (8080)
    ↓
Service Discovery (Consul)
    ↓
11 Microservices (8081-8090)
    ↓
MySQL + Redis + MongoDB + Kafka
```

## 🎮 Demo Accounts

- **Customer:** customer@demo.com / password123
- **Admin:** admin@demo.com / password123
- **Delivery:** delivery@demo.com / password123

## 🛠️ Prerequisites

- Java 17+
- Node.js 18+
- Docker & Docker Compose
- Maven 3.6+

## 📖 Read Next

Start with [QUICK_START_MICROSERVICES.md](QUICK_START_MICROSERVICES.md) for detailed instructions.
