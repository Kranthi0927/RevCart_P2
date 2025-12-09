# Test Order Placement

## Steps to Test:

### 1. Start All Services
Make sure these are running:
- MySQL (port 3306)
- Consul (port 8500)
- API Gateway (port 8080)
- Order Service (port 8085)
- Auth Service (port 8081)

### 2. Check Order Service
```bash
curl http://localhost:8085/orders/all
```

### 3. Test Order Creation via API Gateway
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "orderNumber": "TEST001",
    "totalAmount": 500,
    "shippingAddress": "Test Address",
    "couponCode": null,
    "discountAmount": 0,
    "orderItems": [
      {
        "productId": 1,
        "productName": "Test Product",
        "quantity": 2,
        "price": 250
      }
    ]
  }'
```

### 4. Check if Order was Saved
```bash
curl http://localhost:8085/orders/all
```

### 5. Check User Orders
```bash
curl -H "userId: 1" http://localhost:8085/orders/user
```

## Common Issues:

### Order Service Not Running
```bash
cd microservices/order-service
mvn spring-boot:run
```

### Database Connection Error
- Check MySQL is running
- Verify database `revcart_orders` exists
- Check credentials in application.properties

### API Gateway Not Routing
- Check Consul UI: http://localhost:8500
- Verify order-service is registered
- Check API Gateway routes configuration

## Frontend Testing:

1. Login to the application
2. Add items to cart
3. Go to checkout
4. Fill in details and place order
5. Check browser console for:
   - "Attempting to save order with payload"
   - "✅ Order saved successfully" OR error message
6. Check backend console for:
   - "=== Received Order Request ==="
   - "✅ Order saved successfully with ID: X"

## Database Check:

```sql
USE revcart_orders;
SELECT * FROM orders;
SELECT * FROM order_items;
```
