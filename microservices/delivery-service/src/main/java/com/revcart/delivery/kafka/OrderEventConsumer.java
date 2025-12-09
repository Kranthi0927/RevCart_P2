package com.revcart.delivery.kafka;

import com.revcart.delivery.event.OrderShippedEvent;
import com.revcart.delivery.model.Delivery;
import com.revcart.delivery.service.DeliveryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

//@Component
public class OrderEventConsumer {
    
    @Autowired
    private DeliveryService deliveryService;
    
    @KafkaListener(topics = "order-shipped", groupId = "delivery-service")
    public void handleOrderShipped(OrderShippedEvent event) {
        Delivery delivery = new Delivery();
        delivery.setOrderId(event.getOrderId());
        delivery.setDeliveryAddress(event.getDeliveryAddress());
        deliveryService.assignDelivery(delivery);
    }
}
