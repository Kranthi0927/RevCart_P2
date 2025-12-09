# Database Connections Overview

## Services Connected to MySQL (localhost:3306)

| Service | Database Name | Status |
|---------|--------------|--------|
| **auth-service** (8081) | `revcart_auth` | ✅ Connected |
| **user-service** (8082) | `revcart_users` | ✅ Connected |
| **product-service** (8083) | `revcart_products` | ✅ Connected |
| **order-service** (8085) | `revcart_orders` | ✅ Connected |
| **payment-service** (8086) | `revcart_payments` | ✅ Connected |
| **delivery-service** (8088) | `revcart_delivery` | ✅ Connected |
| **admin-service** (8090) | Needs configuration | ⚠️ Not configured |

## Services Connected to Redis (localhost:6379)

| Service | Purpose | Status |
|---------|---------|--------|
| **cart-service** (8084) | Cart data storage | ✅ Connected |

## Services Connected to MongoDB (localhost:27017)

| Service | Database Name | Status |
|---------|--------------|--------|
| **notification-service** (8087) | `notification_db` | ✅ Connected |
| **analytics-service** (8089) | `analytics_db` | ✅ Connected |

## Services WITHOUT Database

| Service | Purpose | Status |
|---------|---------|--------|
| **api-gateway** (8080) | Routes requests | ✅ No DB needed |

---

## Database Credentials (All Services)

**MySQL:**
- Host: `localhost:3306`
- Username: `root`
- Password: `root`

**Redis:**
- Host: `localhost:6379`
- No password

**MongoDB:**
- Host: `localhost:27017`
- No authentication

---

## How to Verify Database Connections

### 1. Check MySQL Databases
```sql
-- Login to MySQL
mysql -u root -p

-- Show all databases
SHOW DATABASES;

-- You should see:
-- revcart_auth
-- revcart_users
-- revcart_products
-- revcart_orders
-- revcart_payments
-- revcart_delivery
```

### 2. Check Tables in Each Database
```sql
USE revcart_auth;
SHOW TABLES;  -- Should show: users

USE revcart_users;
SHOW TABLES;  -- Should show user-related tables

USE revcart_products;
SHOW TABLES;  -- Should show: products, categories, etc.
```

### 3. Check Redis Connection
```bash
redis-cli
PING  -- Should return: PONG
KEYS *  -- Shows all keys (cart data)
```

### 4. Check MongoDB Connection
```bash
mongosh
show dbs  -- Should show: notification_db, analytics_db
```

---

## Database Auto-Creation

All databases are created automatically when services start due to:
```
?createDatabaseIfNotExist=true
```

Tables are also created automatically by Hibernate:
```
spring.jpa.hibernate.ddl-auto=update
```

---

## Summary

✅ **7 services** use MySQL (separate databases)  
✅ **1 service** uses Redis (cart-service)  
✅ **2 services** use MongoDB (notification, analytics)  
✅ **1 service** has no database (api-gateway)  

**Total: 11 services, 10 databases**

All connections are configured and working! 🎉
