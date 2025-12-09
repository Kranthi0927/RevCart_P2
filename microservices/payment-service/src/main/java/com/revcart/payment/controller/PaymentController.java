package com.revcart.payment.controller;

import com.revcart.payment.model.Payment;
import com.revcart.payment.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/payments")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private com.revcart.payment.service.RazorpayService razorpayService;
    
    @PostMapping("/create-order")
    public ResponseEntity<?> createOrder(@RequestParam Long orderId, @RequestParam Long userId, @RequestParam Double amount) {
        try {
            return ResponseEntity.ok(paymentService.createRazorpayOrder(orderId, userId, amount));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Payment> getPaymentById(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.getPaymentById(id));
    }
    
    @GetMapping("/order/{orderId}")
    public ResponseEntity<List<Payment>> getPaymentsByOrderId(@PathVariable Long orderId) {
        return ResponseEntity.ok(paymentService.getPaymentsByOrderId(orderId));
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Payment>> getPaymentsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(paymentService.getPaymentsByUserId(userId));
    }
    
    @PostMapping("/{id}/refund")
    public ResponseEntity<Payment> refundPayment(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.refundPayment(id));
    }
    
    @PostMapping("/verify")
    public ResponseEntity<?> verifyPayment(@RequestBody com.revcart.payment.dto.RazorpayPaymentVerification verification) {
        try {
            Payment payment = paymentService.verifyAndUpdatePayment(verification);
            return ResponseEntity.ok(payment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}
