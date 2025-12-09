package com.revcart.admin.controller;

import com.revcart.admin.dto.DashboardStats;
import com.revcart.admin.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AdminService adminService;
    
    @GetMapping("/dashboard")
    public ResponseEntity<DashboardStats> getDashboardStats() {
        DashboardStats stats = adminService.getDashboardStats();
        System.out.println("Returning stats: " + stats);
        return ResponseEntity.ok(stats);
    }
    
    @GetMapping("/stats/real")
    public ResponseEntity<DashboardStats> getRealStats() {
        return ResponseEntity.ok(adminService.getRealDashboardStats());
    }
    
    @GetMapping("/orders/recent")
    public ResponseEntity<?> getRecentOrders() {
        return ResponseEntity.ok(adminService.getRecentOrders());
    }
    
    @GetMapping("/analytics/sales")
    public ResponseEntity<?> getSalesAnalytics() {
        return ResponseEntity.ok(adminService.getSalesAnalytics());
    }
    
    @GetMapping("/analytics/top-products")
    public ResponseEntity<?> getTopProducts() {
        return ResponseEntity.ok(adminService.getTopProducts());
    }
    
    @GetMapping("/analytics/order-stats")
    public ResponseEntity<?> getOrderStats() {
        return ResponseEntity.ok(adminService.getOrderStats());
    }
    
    @GetMapping("/metrics/today")
    public ResponseEntity<?> getTodayMetrics() {
        return ResponseEntity.ok(adminService.getTodayMetrics());
    }
}
