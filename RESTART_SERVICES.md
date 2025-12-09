# Quick Restart Guide

## Stop all running services first (Ctrl+C in each terminal)

## Then restart in this order:

### 1. API Gateway (MUST restart first)
```bash
cd microservices/api-gateway
mvn spring-boot:run
```
Wait for "Started ApiGatewayApplication"

### 2. Order Service
```bash
cd microservices/order-service
mvn spring-boot:run
```
Wait for "Started OrderServiceApplication"

### 3. Verify
- Check Consul: http://localhost:8500
- Both services should show as healthy

## Test Order Placement:
1. Login to app
2. Add items to cart
3. Go to checkout
4. Place order
5. Check "My Orders" - should see your order

## If still getting CORS errors:
- Clear browser cache (Ctrl+Shift+Delete)
- Hard refresh (Ctrl+F5)
- Restart browser
