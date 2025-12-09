# RevCart - AWS Production Deployment Guide

## 🚀 AWS Infrastructure Architecture

This guide provides complete AWS deployment architecture for RevCart microservices platform.

---

## 📋 AWS Services Used

| Service | Purpose | Estimated Cost/Month |
|---------|---------|---------------------|
| **ECS Fargate** | Container orchestration | $150-300 |
| **RDS MySQL** | Relational database | $100-200 |
| **ElastiCache Redis** | Caching layer | $50-100 |
| **DocumentDB** | MongoDB compatible | $100-200 |
| **Amazon MSK** | Managed Kafka | $200-400 |
| **Application Load Balancer** | Load balancing | $20-40 |
| **Route 53** | DNS management | $1-5 |
| **CloudFront** | CDN for frontend | $20-50 |
| **S3** | Static file hosting | $5-10 |
| **CloudWatch** | Monitoring & logs | $30-60 |
| **Secrets Manager** | Secrets management | $5-10 |
| **VPC** | Network isolation | Free |
| **ECR** | Container registry | $5-10 |
| **Total** | | **$686-1385/month** |

---

## 🏗️ Architecture Diagram

```
                    ┌─────────────────────┐
                    │     Route 53        │
                    │   (DNS Management)  │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │    CloudFront       │
                    │  (CDN + S3 Static)  │
                    └──────────┬──────────┘
                               │
        ┌──────────────────────┴──────────────────────┐
        │                                              │
┌───────▼────────┐                          ┌─────────▼────────┐
│  S3 Bucket     │                          │  ALB (Public)    │
│  (Frontend)    │                          │  Port 443/80     │
└────────────────┘                          └─────────┬────────┘
                                                      │
                                    ┌─────────────────┴─────────────────┐
                                    │         VPC (10.0.0.0/16)         │
                                    │                                   │
                    ┌───────────────┴───────────────┐                  │
                    │   Public Subnets (2 AZs)      │                  │
                    │   - NAT Gateways              │                  │
                    └───────────────┬───────────────┘                  │
                                    │                                   │
                    ┌───────────────▼───────────────┐                  │
                    │   Private Subnets (2 AZs)     │                  │
                    │                                │                  │
                    │  ┌──────────────────────────┐ │                  │
                    │  │   ECS Fargate Cluster    │ │                  │
                    │  │                          │ │                  │
                    │  │  ┌────────────────────┐ │ │                  │
                    │  │  │  API Gateway       │ │ │                  │
                    │  │  │  (2 tasks)         │ │ │                  │
                    │  │  └────────────────────┘ │ │                  │
                    │  │                          │ │                  │
                    │  │  ┌────────────────────┐ │ │                  │
                    │  │  │  Auth Service      │ │ │                  │
                    │  │  │  (2 tasks)         │ │ │                  │
                    │  │  └────────────────────┘ │ │                  │
                    │  │                          │ │                  │
                    │  │  ┌────────────────────┐ │ │                  │
                    │  │  │  Other Services    │ │ │                  │
                    │  │  │  (2 tasks each)    │ │ │                  │
                    │  │  └────────────────────┘ │ │                  │
                    │  └──────────────────────────┘ │                  │
                    └───────────────┬───────────────┘                  │
                                    │                                   │
                    ┌───────────────▼───────────────┐                  │
                    │   Data Subnets (2 AZs)        │                  │
                    │                                │                  │
                    │  ┌──────────────────────────┐ │                  │
                    │  │  RDS MySQL (Multi-AZ)    │ │                  │
                    │  │  Primary + Standby       │ │                  │
                    │  └──────────────────────────┘ │                  │
                    │                                │                  │
                    │  ┌──────────────────────────┐ │                  │
                    │  │  ElastiCache Redis       │ │                  │
                    │  │  (Cluster Mode)          │ │                  │
                    │  └──────────────────────────┘ │                  │
                    │                                │                  │
                    │  ┌──────────────────────────┐ │                  │
                    │  │  DocumentDB              │ │                  │
                    │  │  (3 node cluster)        │ │                  │
                    │  └──────────────────────────┘ │                  │
                    │                                │                  │
                    │  ┌──────────────────────────┐ │                  │
                    │  │  Amazon MSK (Kafka)      │ │                  │
                    │  │  (3 brokers)             │ │                  │
                    │  └──────────────────────────┘ │                  │
                    └────────────────────────────────┘                  │
                                                                        │
                    ┌───────────────────────────────────────────────────┘
                    │
            ┌───────▼────────┐
            │  CloudWatch    │
            │  Logs & Metrics│
            └────────────────┘
```

---

## 🔧 Step-by-Step Deployment

### 1. VPC Setup

```bash
# Create VPC
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=revcart-vpc}]'

# Create Public Subnets (2 AZs)
aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=revcart-public-1a}]'

aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=revcart-public-1b}]'

# Create Private Subnets (2 AZs)
aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.10.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=revcart-private-1a}]'

aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.11.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=revcart-private-1b}]'

# Create Internet Gateway
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=revcart-igw}]'

# Attach to VPC
aws ec2 attach-internet-gateway \
  --vpc-id vpc-xxxxx \
  --internet-gateway-id igw-xxxxx

# Create NAT Gateways (for private subnets)
aws ec2 create-nat-gateway \
  --subnet-id subnet-public-1a \
  --allocation-id eipalloc-xxxxx
```

### 2. RDS MySQL Setup

```bash
# Create DB Subnet Group
aws rds create-db-subnet-group \
  --db-subnet-group-name revcart-db-subnet \
  --db-subnet-group-description "RevCart DB Subnet Group" \
  --subnet-ids subnet-private-1a subnet-private-1b

# Create RDS Instance
aws rds create-db-instance \
  --db-instance-identifier revcart-mysql \
  --db-instance-class db.t3.medium \
  --engine mysql \
  --engine-version 8.0.35 \
  --master-username admin \
  --master-user-password <SecurePassword> \
  --allocated-storage 100 \
  --storage-type gp3 \
  --db-subnet-group-name revcart-db-subnet \
  --vpc-security-group-ids sg-xxxxx \
  --multi-az \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "mon:04:00-mon:05:00" \
  --enable-cloudwatch-logs-exports '["error","general","slowquery"]'
```

### 3. ElastiCache Redis Setup

```bash
# Create Cache Subnet Group
aws elasticache create-cache-subnet-group \
  --cache-subnet-group-name revcart-redis-subnet \
  --cache-subnet-group-description "RevCart Redis Subnet" \
  --subnet-ids subnet-private-1a subnet-private-1b

# Create Redis Cluster
aws elasticache create-replication-group \
  --replication-group-id revcart-redis \
  --replication-group-description "RevCart Redis Cluster" \
  --engine redis \
  --cache-node-type cache.t3.medium \
  --num-cache-clusters 2 \
  --cache-subnet-group-name revcart-redis-subnet \
  --security-group-ids sg-xxxxx \
  --automatic-failover-enabled \
  --at-rest-encryption-enabled \
  --transit-encryption-enabled
```

### 4. DocumentDB Setup

```bash
# Create DocumentDB Subnet Group
aws docdb create-db-subnet-group \
  --db-subnet-group-name revcart-docdb-subnet \
  --db-subnet-group-description "RevCart DocumentDB Subnet" \
  --subnet-ids subnet-private-1a subnet-private-1b

# Create DocumentDB Cluster
aws docdb create-db-cluster \
  --db-cluster-identifier revcart-docdb \
  --engine docdb \
  --master-username admin \
  --master-user-password <SecurePassword> \
  --db-subnet-group-name revcart-docdb-subnet \
  --vpc-security-group-ids sg-xxxxx \
  --backup-retention-period 7

# Create DocumentDB Instances
aws docdb create-db-instance \
  --db-instance-identifier revcart-docdb-1 \
  --db-instance-class db.t3.medium \
  --engine docdb \
  --db-cluster-identifier revcart-docdb
```

### 5. Amazon MSK (Kafka) Setup

```bash
# Create MSK Cluster
aws kafka create-cluster \
  --cluster-name revcart-kafka \
  --broker-node-group-info '{
    "InstanceType": "kafka.t3.small",
    "ClientSubnets": ["subnet-private-1a", "subnet-private-1b"],
    "SecurityGroups": ["sg-xxxxx"],
    "StorageInfo": {
      "EbsStorageInfo": {
        "VolumeSize": 100
      }
    }
  }' \
  --kafka-version 3.5.1 \
  --number-of-broker-nodes 3 \
  --encryption-info '{
    "EncryptionInTransit": {
      "ClientBroker": "TLS",
      "InCluster": true
    }
  }'
```

### 6. ECR Repository Setup

```bash
# Create ECR repositories for each service
services=("api-gateway" "auth-service" "user-service" "product-service" "cart-service" "order-service" "payment-service" "notification-service" "delivery-service" "analytics-service" "admin-service")

for service in "${services[@]}"
do
  aws ecr create-repository \
    --repository-name revcart/$service \
    --image-scanning-configuration scanOnPush=true
done
```

### 7. Build and Push Docker Images

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build and push each service
cd microservices/api-gateway
docker build -t revcart/api-gateway .
docker tag revcart/api-gateway:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/revcart/api-gateway:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/revcart/api-gateway:latest

# Repeat for all services
```

### 8. ECS Cluster Setup

```bash
# Create ECS Cluster
aws ecs create-cluster \
  --cluster-name revcart-cluster \
  --capacity-providers FARGATE FARGATE_SPOT \
  --default-capacity-provider-strategy capacityProvider=FARGATE,weight=1

# Create Task Execution Role
aws iam create-role \
  --role-name ecsTaskExecutionRole \
  --assume-role-policy-document file://ecs-trust-policy.json

aws iam attach-role-policy \
  --role-name ecsTaskExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

### 9. ECS Task Definitions

Create `task-definition-api-gateway.json`:

```json
{
  "family": "revcart-api-gateway",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "executionRoleArn": "arn:aws:iam::<account-id>:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::<account-id>:role/ecsTaskRole",
  "containerDefinitions": [
    {
      "name": "api-gateway",
      "image": "<account-id>.dkr.ecr.us-east-1.amazonaws.com/revcart/api-gateway:latest",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "SPRING_PROFILES_ACTIVE",
          "value": "prod"
        }
      ],
      "secrets": [
        {
          "name": "JWT_SECRET",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:<account-id>:secret:revcart/jwt-secret"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/revcart-api-gateway",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8080/actuator/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3
      }
    }
  ]
}
```

Register task definition:

```bash
aws ecs register-task-definition --cli-input-json file://task-definition-api-gateway.json
```

### 10. Application Load Balancer Setup

```bash
# Create ALB
aws elbv2 create-load-balancer \
  --name revcart-alb \
  --subnets subnet-public-1a subnet-public-1b \
  --security-groups sg-xxxxx \
  --scheme internet-facing \
  --type application

# Create Target Group
aws elbv2 create-target-group \
  --name revcart-api-gateway-tg \
  --protocol HTTP \
  --port 8080 \
  --vpc-id vpc-xxxxx \
  --target-type ip \
  --health-check-path /actuator/health \
  --health-check-interval-seconds 30

# Create Listener
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:... \
  --protocol HTTPS \
  --port 443 \
  --certificates CertificateArn=arn:aws:acm:... \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:...
```

### 11. ECS Service Creation

```bash
# Create ECS Service for API Gateway
aws ecs create-service \
  --cluster revcart-cluster \
  --service-name api-gateway-service \
  --task-definition revcart-api-gateway \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-private-1a,subnet-private-1b],securityGroups=[sg-xxxxx],assignPublicIp=DISABLED}" \
  --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=api-gateway,containerPort=8080" \
  --health-check-grace-period-seconds 60

# Repeat for all microservices
```

### 12. Auto Scaling Configuration

```bash
# Register scalable target
aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension ecs:service:DesiredCount \
  --resource-id service/revcart-cluster/api-gateway-service \
  --min-capacity 2 \
  --max-capacity 10

# Create scaling policy
aws application-autoscaling put-scaling-policy \
  --service-namespace ecs \
  --scalable-dimension ecs:service:DesiredCount \
  --resource-id service/revcart-cluster/api-gateway-service \
  --policy-name cpu-scaling-policy \
  --policy-type TargetTrackingScaling \
  --target-tracking-scaling-policy-configuration '{
    "TargetValue": 70.0,
    "PredefinedMetricSpecification": {
      "PredefinedMetricType": "ECSServiceAverageCPUUtilization"
    },
    "ScaleInCooldown": 300,
    "ScaleOutCooldown": 60
  }'
```

### 13. Frontend Deployment (S3 + CloudFront)

```bash
# Create S3 bucket
aws s3 mb s3://revcart-frontend

# Build Angular app
cd revcart-frontend
npm run build

# Upload to S3
aws s3 sync dist/revcart-frontend s3://revcart-frontend --delete

# Create CloudFront distribution
aws cloudfront create-distribution \
  --origin-domain-name revcart-frontend.s3.amazonaws.com \
  --default-root-object index.html
```

### 14. Route 53 DNS Setup

```bash
# Create hosted zone
aws route53 create-hosted-zone \
  --name revcart.com \
  --caller-reference $(date +%s)

# Create A record for ALB
aws route53 change-resource-record-sets \
  --hosted-zone-id Z1234567890ABC \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "api.revcart.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z35SXDOTRQ7X7K",
          "DNSName": "revcart-alb-123456789.us-east-1.elb.amazonaws.com",
          "EvaluateTargetHealth": false
        }
      }
    }]
  }'
```

### 15. Secrets Manager Setup

```bash
# Store database credentials
aws secretsmanager create-secret \
  --name revcart/mysql-credentials \
  --secret-string '{
    "username": "admin",
    "password": "<SecurePassword>",
    "host": "revcart-mysql.xxxxx.rds.amazonaws.com",
    "port": "3306"
  }'

# Store JWT secret
aws secretsmanager create-secret \
  --name revcart/jwt-secret \
  --secret-string "revCartSecretKeyForJWTTokenGenerationAndValidation2024"

# Store Redis credentials
aws secretsmanager create-secret \
  --name revcart/redis-credentials \
  --secret-string '{
    "host": "revcart-redis.xxxxx.cache.amazonaws.com",
    "port": "6379"
  }'
```

---

## 📊 Monitoring & Logging

### CloudWatch Dashboards

```bash
# Create custom dashboard
aws cloudwatch put-dashboard \
  --dashboard-name RevCart-Dashboard \
  --dashboard-body file://dashboard.json
```

### CloudWatch Alarms

```bash
# CPU Utilization Alarm
aws cloudwatch put-metric-alarm \
  --alarm-name revcart-high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/ECS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2

# Database Connection Alarm
aws cloudwatch put-metric-alarm \
  --alarm-name revcart-db-connections \
  --alarm-description "Alert when DB connections exceed 80%" \
  --metric-name DatabaseConnections \
  --namespace AWS/RDS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold
```

---

## 💰 Cost Optimization

### 1. Use Spot Instances
```bash
# Update ECS service to use Fargate Spot
aws ecs update-service \
  --cluster revcart-cluster \
  --service api-gateway-service \
  --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1
```

### 2. Reserved Instances
- Purchase RDS Reserved Instances (1-3 years)
- Purchase ElastiCache Reserved Nodes
- Save 30-60% on compute costs

### 3. Auto Scaling
- Scale down during off-peak hours
- Use scheduled scaling policies

### 4. S3 Lifecycle Policies
```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket revcart-logs \
  --lifecycle-configuration '{
    "Rules": [{
      "Id": "DeleteOldLogs",
      "Status": "Enabled",
      "Expiration": {"Days": 90}
    }]
  }'
```

---

## 🔐 Security Best Practices

1. **Enable VPC Flow Logs**
2. **Use AWS WAF** on ALB
3. **Enable GuardDuty** for threat detection
4. **Use AWS Config** for compliance
5. **Enable CloudTrail** for audit logs
6. **Rotate secrets** regularly
7. **Use IAM roles** instead of access keys
8. **Enable MFA** for root account
9. **Use Security Groups** properly
10. **Enable encryption** at rest and in transit

---

## 📈 Performance Optimization

1. **Enable CloudFront caching**
2. **Use ElastiCache** for frequently accessed data
3. **Optimize RDS** with read replicas
4. **Use connection pooling**
5. **Enable compression** on ALB
6. **Optimize Docker images** (multi-stage builds)
7. **Use CDN** for static assets
8. **Enable HTTP/2** on CloudFront

---

## ✅ Deployment Checklist

- [ ] VPC and subnets created
- [ ] Security groups configured
- [ ] RDS MySQL deployed and configured
- [ ] ElastiCache Redis deployed
- [ ] DocumentDB deployed
- [ ] Amazon MSK deployed
- [ ] ECR repositories created
- [ ] Docker images built and pushed
- [ ] ECS cluster created
- [ ] Task definitions registered
- [ ] ECS services created
- [ ] ALB configured with target groups
- [ ] Auto scaling configured
- [ ] CloudWatch alarms set up
- [ ] Secrets stored in Secrets Manager
- [ ] Frontend deployed to S3
- [ ] CloudFront distribution created
- [ ] Route 53 DNS configured
- [ ] SSL certificates configured
- [ ] Monitoring dashboards created
- [ ] Backup policies configured

---

## 🆘 Troubleshooting

### ECS Task Not Starting
```bash
# Check task logs
aws ecs describe-tasks \
  --cluster revcart-cluster \
  --tasks <task-id>

# Check CloudWatch logs
aws logs tail /ecs/revcart-api-gateway --follow
```

### Database Connection Issues
```bash
# Test connection from ECS task
aws ecs execute-command \
  --cluster revcart-cluster \
  --task <task-id> \
  --container api-gateway \
  --interactive \
  --command "/bin/bash"

# Inside container
mysql -h revcart-mysql.xxxxx.rds.amazonaws.com -u admin -p
```

### High Costs
```bash
# Check cost explorer
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

---

This AWS deployment guide provides a production-ready, scalable, and secure infrastructure for RevCart.
