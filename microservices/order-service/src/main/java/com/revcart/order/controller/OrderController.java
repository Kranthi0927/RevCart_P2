package com.revcart.order.controller;

import com.revcart.order.model.Order;
import com.revcart.order.model.OrderStatus;
import com.revcart.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/orders")
public class OrderController {
    
    @Autowired
    private OrderService orderService;
    
    @PostMapping
    public ResponseEntity<?> createOrder(@RequestBody Order order) {
        try {
            System.out.println("\n=== Received Order Request ===");
            System.out.println("Order userId: " + order.getUserId());
            System.out.println("Order number: " + order.getOrderNumber());
            System.out.println("Order total: " + order.getTotalAmount());
            System.out.println("Coupon code: " + order.getCouponCode());
            System.out.println("Discount: " + order.getDiscountAmount());
            System.out.println("Order items count: " + (order.getOrderItems() != null ? order.getOrderItems().size() : 0));
            
            Order savedOrder = orderService.createOrder(order);
            System.out.println("\u2705 Order saved successfully with ID: " + savedOrder.getId());
            return ResponseEntity.ok(savedOrder);
        } catch (Exception e) {
            System.err.println("\u274c Error creating order: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error creating order: " + e.getMessage());
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrderById(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.getOrderById(id));
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Order>> getOrdersByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(orderService.getOrdersByUserId(userId));
    }
    
    @GetMapping("/user")
    public ResponseEntity<List<Order>> getCurrentUserOrders(@RequestHeader("userId") Long userId) {
        return ResponseEntity.ok(orderService.getOrdersByUserId(userId));
    }
    
    @GetMapping("/all")
    public ResponseEntity<List<Order>> getAllOrders() {
        return ResponseEntity.ok(orderService.getAllOrders());
    }
    
    @GetMapping("/admin")
    public ResponseEntity<?> getAdminOrders() {
        return ResponseEntity.ok(orderService.getAllOrdersWithCustomers());
    }
    
    @GetMapping("/recent")
    public ResponseEntity<List<Order>> getRecentOrders() {
        List<Order> recentOrders = orderService.getAllOrders();
        return ResponseEntity.ok(recentOrders.stream()
            .sorted((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()))
            .limit(10)
            .toList());
    }
    
    @GetMapping("/count")
    public ResponseEntity<Long> getOrderCount() {
        return ResponseEntity.ok(orderService.getOrderCount());
    }
    
    @GetMapping("/revenue")
    public ResponseEntity<Double> getTotalRevenue() {
        return ResponseEntity.ok(orderService.getTotalRevenue());
    }
    
    @PatchMapping("/{id}/status")
    public ResponseEntity<Order> updateOrderStatus(
            @PathVariable Long id,
            @RequestParam OrderStatus status) {
        return ResponseEntity.ok(orderService.updateOrderStatus(id, status));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> cancelOrder(@PathVariable Long id) {
        orderService.cancelOrder(id);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/analytics/sales")
    public ResponseEntity<?> getSalesAnalytics() {
        return ResponseEntity.ok(orderService.getSalesAnalytics());
    }
    
    @GetMapping("/analytics/stats")
    public ResponseEntity<?> getOrderStats() {
        return ResponseEntity.ok(orderService.getOrderStats());
    }
    
    @GetMapping("/analytics/today")
    public ResponseEntity<?> getTodayMetrics() {
        return ResponseEntity.ok(orderService.getTodayMetrics());
    }
}
