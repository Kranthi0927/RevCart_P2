package com.revcart.delivery.event;

public class OrderShippedEvent {
    private Long orderId;
    private Long userId;
    private String deliveryAddress;
    
    public OrderShippedEvent() {}
    
    public OrderShippedEvent(Long orderId, Long userId, String deliveryAddress) {
        this.orderId = orderId;
        this.userId = userId;
        this.deliveryAddress = deliveryAddress;
    }
    
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
}
