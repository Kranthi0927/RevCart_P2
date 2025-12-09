# API Testing Guide

## Swagger UI Access

After restarting services, access Swagger UI for each service:

- **Auth Service**: http://localhost:8081/swagger-ui.html
- **User Service**: http://localhost:8082/swagger-ui.html
- **Product Service**: http://localhost:8083/swagger-ui.html
- **Cart Service**: http://localhost:8084/swagger-ui.html
- **Order Service**: http://localhost:8085/swagger-ui.html
- **Payment Service**: http://localhost:8086/swagger-ui.html

## Postman Setup

1. Open Postman
2. Click **Import** → Select `RevCart-API-Collection.postman_collection.json`
3. Collection will be imported with all endpoints

## Quick Test Flow

### 1. Register a User
```bash
POST http://localhost:8080/api/auth/register
Body:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "1234567890"
}
```

### 2. Login
```bash
POST http://localhost:8080/api/auth/login
Body:
{
  "email": "john@example.com",
  "password": "password123"
}
```
**Save the JWT token from response!**

### 3. Get User Profile
```bash
GET http://localhost:8080/api/users/profile
Header: Authorization: Bearer YOUR_JWT_TOKEN
```

### 4. Create Product (if you have admin role)
```bash
POST http://localhost:8080/api/products
Header: Authorization: Bearer YOUR_JWT_TOKEN
Body:
{
  "name": "Laptop",
  "description": "Gaming Laptop",
  "price": 999.99,
  "stock": 50,
  "category": "Electronics"
}
```

### 5. Get All Products
```bash
GET http://localhost:8080/api/products
Header: Authorization: Bearer YOUR_JWT_TOKEN
```

### 6. Add to Cart
```bash
POST http://localhost:8080/api/cart/items
Header: Authorization: Bearer YOUR_JWT_TOKEN
Body:
{
  "productId": 1,
  "quantity": 2
}
```

### 7. View Cart
```bash
GET http://localhost:8080/api/cart
Header: Authorization: Bearer YOUR_JWT_TOKEN
```

### 8. Create Order
```bash
POST http://localhost:8080/api/orders
Header: Authorization: Bearer YOUR_JWT_TOKEN
Body:
{
  "shippingAddress": "123 Main St, City",
  "paymentMethod": "CARD"
}
```

## Testing with cURL (Windows)

```bash
# Register
curl -X POST http://localhost:8080/api/auth/register -H "Content-Type: application/json" -d "{\"name\":\"John Doe\",\"email\":\"john@example.com\",\"password\":\"password123\",\"phone\":\"1234567890\"}"

# Login
curl -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"john@example.com\",\"password\":\"password123\"}"

# Get Profile (replace TOKEN)
curl http://localhost:8080/api/users/profile -H "Authorization: Bearer TOKEN"
```

## Next Steps

1. **Restart auth-service** to enable Swagger:
   ```bash
   cd microservices/auth-service
   mvn spring-boot:run
   ```

2. **Access Swagger UI**: http://localhost:8081/swagger-ui.html

3. **Import Postman Collection**: Use the JSON file created

4. **Test the APIs** following the flow above
