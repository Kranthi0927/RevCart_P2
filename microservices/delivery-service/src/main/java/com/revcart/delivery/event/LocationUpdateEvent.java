package com.revcart.delivery.event;

public class LocationUpdateEvent {
    private Long deliveryId;
    private Long agentId;
    private Double latitude;
    private Double longitude;
    private String status;
    
    public LocationUpdateEvent() {}
    
    public LocationUpdateEvent(Long deliveryId, Long agentId, Double latitude, Double longitude, String status) {
        this.deliveryId = deliveryId;
        this.agentId = agentId;
        this.latitude = latitude;
        this.longitude = longitude;
        this.status = status;
    }
    
    public Long getDeliveryId() { return deliveryId; }
    public void setDeliveryId(Long deliveryId) { this.deliveryId = deliveryId; }
    
    public Long getAgentId() { return agentId; }
    public void setAgentId(Long agentId) { this.agentId = agentId; }
    
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
