package com.revcart.delivery.kafka;

import com.revcart.delivery.event.LocationUpdateEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

//@Component
public class LocationEventProducer {
    
    //@Autowired
    //private KafkaTemplate<String, LocationUpdateEvent> kafkaTemplate;
    
    public void publishLocationUpdate(LocationUpdateEvent event) {
        //kafkaTemplate.send("delivery-location-update", event);
        System.out.println("Location update (Kafka disabled): " + event);
    }
}
