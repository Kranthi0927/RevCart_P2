# Delivery Service - Kafka Integration

## Overview
Delivery Service now uses Kafka for:
1. **Consuming order-shipped events** from Order Service
2. **Publishing live location updates** for real-time tracking

---

## Kafka Topics

### Consumer Topics
- **order-shipped**: Listens for orders ready for delivery

### Producer Topics
- **delivery-location-update**: Publishes agent location updates in real-time

---

## Components Added

### 1. Event Classes
- `OrderShippedEvent.java` - Event received when order is shipped
- `LocationUpdateEvent.java` - Event published for live tracking

### 2. Kafka Components
- `OrderEventConsumer.java` - Consumes order-shipped events
- `LocationEventProducer.java` - Publishes location updates
- `KafkaConfig.java` - Kafka producer/consumer configuration

### 3. Services
- `DeliveryAgentService.java` - Manages agents and publishes location updates
- `DeliveryAgentRepository.java` - Agent data access

### 4. Controllers
- `DeliveryAgentController.java` - REST endpoints for agent management

---

## API Endpoints

### Agent Management

**Create Agent**
```
POST /agents
Body: {
  "name": "John Doe",
  "phone": "1234567890",
  "email": "john@example.com",
  "vehicleType": "Bike"
}
```

**Get Available Agents**
```
GET /agents/available
```

**Update Agent Location (Live Tracking)**
```
PUT /agents/{agentId}/location?lat=12.9716&lng=77.5946&deliveryId=123
```
This publishes location update to Kafka topic `delivery-location-update`

**Update Agent Status**
```
PUT /agents/{agentId}/status?status=BUSY
```
Status: AVAILABLE, BUSY, OFFLINE

---

## Flow

### 1. Order Shipped Flow
```
Order Service → Publishes to "order-shipped" topic
                     ↓
Delivery Service (Consumer) → Receives event
                     ↓
Auto-assigns delivery to available agent
                     ↓
Delivery created in database
```

### 2. Live Tracking Flow
```
Agent updates location via mobile app
                     ↓
PUT /agents/{id}/location
                     ↓
DeliveryAgentService updates DB
                     ↓
Publishes LocationUpdateEvent to Kafka
                     ↓
Topic: "delivery-location-update"
                     ↓
Frontend/Notification Service consumes
                     ↓
User sees live location on map
```

---

## Configuration

**application.properties**
```properties
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.consumer.group-id=delivery-service
spring.kafka.consumer.auto-offset-reset=earliest
```

---

## Testing

### 1. Start Kafka
```bash
# Start Zookeeper
bin\windows\zookeeper-server-start.bat config\zookeeper.properties

# Start Kafka
bin\windows\kafka-server-start.bat config\server.properties
```

### 2. Create Topics
```bash
# Create order-shipped topic
bin\windows\kafka-topics.bat --create --topic order-shipped --bootstrap-server localhost:9092

# Create delivery-location-update topic
bin\windows\kafka-topics.bat --create --topic delivery-location-update --bootstrap-server localhost:9092
```

### 3. Test Consumer
```bash
# Listen to location updates
bin\windows\kafka-console-consumer.bat --topic delivery-location-update --from-beginning --bootstrap-server localhost:9092
```

### 4. Test Producer (Manual)
```bash
# Publish test order-shipped event
bin\windows\kafka-console-producer.bat --topic order-shipped --bootstrap-server localhost:9092
{"orderId":123,"userId":456,"deliveryAddress":"123 Main St"}
```

---

## Benefits

✅ **Real-time tracking**: Location updates streamed via Kafka
✅ **Decoupled**: Delivery service independent of Order service
✅ **Scalable**: Handle thousands of location updates/second
✅ **Reliable**: Kafka ensures no message loss
✅ **Event-driven**: Automatic delivery assignment when order ships
