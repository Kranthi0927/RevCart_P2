package com.revcart.admin.service;

import com.revcart.admin.client.OrderServiceClient;
import com.revcart.admin.client.ProductServiceClient;
import com.revcart.admin.client.UserServiceClient;
import com.revcart.admin.dto.DashboardStats;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.List;

@Service
public class AdminService {
    
    @Autowired
    private ProductServiceClient productServiceClient;
    
    @Autowired
    private OrderServiceClient orderServiceClient;
    
    @Autowired
    private UserServiceClient userServiceClient;
    
    @Autowired
    private RestTemplate restTemplate;
    
    public DashboardStats getDashboardStats() {
        return getRealDashboardStats();
    }
    
    public List<?> getRecentOrders() {
        return orderServiceClient.getRecentOrders();
    }
    
    public Object getSalesAnalytics() {
        return orderServiceClient.getSalesAnalytics();
    }
    
    public Object getTopProducts() {
        return productServiceClient.getTopProducts();
    }
    
    public Object getOrderStats() {
        return orderServiceClient.getOrderStats();
    }
    
    public Object getTodayMetrics() {
        try {
            return orderServiceClient.getTodayMetrics();
        } catch (Exception e) {
            System.err.println("Error fetching today metrics: " + e.getMessage());
            java.util.Map<String, Object> fallback = new java.util.HashMap<>();
            fallback.put("todayOrders", 0);
            fallback.put("todayRevenue", 0.0);
            fallback.put("pendingDeliveries", 0);
            return fallback;
        }
    }
    
    public DashboardStats getRealDashboardStats() {
        long products = 0;
        long orders = 0;
        long users = 0;
        double revenue = 0.0;
        
        try {
            products = restTemplate.getForObject("http://localhost:8083/products/count", Long.class);
            System.out.println("✅ Products: " + products);
        } catch (Exception e) {
            System.err.println("❌ Product service error: " + e.getMessage());
        }
        
        try {
            orders = restTemplate.getForObject("http://localhost:8085/orders/count", Long.class);
            System.out.println("✅ Orders: " + orders);
        } catch (Exception e) {
            System.err.println("❌ Order service error: " + e.getMessage());
        }
        
        try {
            users = restTemplate.getForObject("http://localhost:8082/users/count", Long.class);
            System.out.println("✅ Users: " + users);
        } catch (Exception e) {
            System.err.println("❌ User service error: " + e.getMessage());
        }
        
        try {
            revenue = restTemplate.getForObject("http://localhost:8085/orders/revenue", Double.class);
            System.out.println("✅ Revenue: " + revenue);
        } catch (Exception e) {
            System.err.println("❌ Revenue error: " + e.getMessage());
        }
        
        return new DashboardStats(products, orders, users, revenue);
    }
}
