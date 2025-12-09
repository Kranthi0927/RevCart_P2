## Feign Clients - Inter-Service Communication

### Created Feign Clients:

#### 1. Order Service → Product Service
**File:** `order-service/src/main/java/com/revcart/order/client/ProductClient.java`
**Purpose:** Get product details and reduce stock when order is placed

**Methods:**
- `getProduct(Long id)` - Get product information
- `reduceStock(Long id, StockRequest request)` - Reduce product stock

---

#### 2. Order Service → Payment Service
**File:** `order-service/src/main/java/com/revcart/order/client/PaymentClient.java`
**Purpose:** Process payments for orders

**Methods:**
- `processPayment(PaymentRequest request)` - Initiate payment
- `getPaymentStatus(Long orderId)` - Check payment status

---

#### 3. Payment Service → Notification Service
**File:** `payment-service/src/main/java/com/revcart/payment/client/NotificationClient.java`
**Purpose:** Send notifications after payment success/failure

**Methods:**
- `sendNotification(NotificationRequest request)` - Send notification to user

---

### How Feign Works:

1. **Service Discovery**: Feign uses Consul to find service instances
2. **Load Balancing**: Automatically load balances between instances
3. **Circuit Breaker**: Can add Resilience4j for fault tolerance
4. **Declarative**: Just define interface, Spring handles implementation

### Usage Example:

```java
@Service
public class OrderService {
    
    @Autowired
    private ProductClient productClient;
    
    @Autowired
    private PaymentClient paymentClient;
    
    public Order createOrder(OrderRequest request) {
        // 1. Get product details
        ProductDTO product = productClient.getProduct(request.getProductId());
        
        // 2. Create order
        Order order = new Order();
        order.setTotalAmount(product.getPrice() * request.getQuantity());
        orderRepository.save(order);
        
        // 3. Reduce stock
        productClient.reduceStock(product.getId(), 
            new StockRequest(request.getQuantity()));
        
        // 4. Process payment
        PaymentResponse payment = paymentClient.processPayment(
            new PaymentRequest(order.getId(), order.getTotalAmount(), "CARD"));
        
        return order;
    }
}
```

### Configuration:

All services already have:
```java
@EnableFeignClients
@EnableDiscoveryClient
```

### Service Communication Flow:

```
Order Created
    ↓
Order Service calls Product Service (Feign)
    ↓
Stock Reduced
    ↓
Order Service calls Payment Service (Feign)
    ↓
Payment Processed
    ↓
Payment Service calls Notification Service (Feign)
    ↓
User Notified
```

### Benefits:

✅ **Type-safe** - Compile-time checking
✅ **Simple** - Just interfaces, no implementation
✅ **Resilient** - Built-in retry and fallback
✅ **Load-balanced** - Automatic load balancing
✅ **Service Discovery** - Uses Consul automatically

### Next Steps:

1. Implement service methods that use these clients
2. Add error handling and fallbacks
3. Add circuit breaker with Resilience4j
4. Test inter-service communication
