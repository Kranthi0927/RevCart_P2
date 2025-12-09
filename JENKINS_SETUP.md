# Jenkins CI/CD Setup Guide

## Prerequisites

1. Jenkins installed (version 2.400+)
2. Docker installed on Jenkins server
3. Maven 3.9+
4. JDK 17
5. Node.js 18+

## Jenkins Configuration

### 1. Install Required Plugins

Go to **Manage Jenkins** → **Manage Plugins** → **Available** and install:

- Git Plugin
- Docker Pipeline Plugin
- Maven Integration Plugin
- NodeJS Plugin
- Email Extension Plugin
- SonarQube Scanner (optional)

### 2. Configure Tools

Go to **Manage Jenkins** → **Global Tool Configuration**:

#### Maven Configuration
- Name: `Maven-3.9`
- Install automatically: ✓
- Version: 3.9.x

#### JDK Configuration
- Name: `JDK-17`
- Install automatically: ✓
- Version: Java 17

#### NodeJS Configuration
- Name: `NodeJS-18`
- Install automatically: ✓
- Version: 18.x

### 3. Configure Credentials

Go to **Manage Jenkins** → **Manage Credentials** → **Global** → **Add Credentials**:

#### GitHub Credentials
- Kind: Username with password
- ID: `github-credentials`
- Username: Your GitHub username
- Password: Your GitHub Personal Access Token

#### DockerHub Credentials
- Kind: Username with password
- ID: `dockerhub-credentials`
- Username: Your DockerHub username
- Password: Your DockerHub password

### 4. Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter name: `RevCart-Pipeline`
3. Select **Pipeline**
4. Click **OK**

#### Pipeline Configuration

**General:**
- Description: `RevCart Microservices CI/CD Pipeline`
- ✓ GitHub project: `https://github.com/Kranthi0927/RevCart_P2`

**Build Triggers:**
- ✓ GitHub hook trigger for GITScm polling
- ✓ Poll SCM: `H/5 * * * *` (every 5 minutes)

**Pipeline:**
- Definition: `Pipeline script from SCM`
- SCM: `Git`
- Repository URL: `https://github.com/Kranthi0927/RevCart_P2.git`
- Credentials: Select `github-credentials`
- Branch: `*/master`
- Script Path: `Jenkinsfile` (or `Jenkinsfile.windows` for Windows)

### 5. Configure GitHub Webhook (Optional)

1. Go to your GitHub repository
2. Settings → Webhooks → Add webhook
3. Payload URL: `http://your-jenkins-url/github-webhook/`
4. Content type: `application/json`
5. Events: `Just the push event`
6. ✓ Active

## Environment Variables

Set these in Jenkins:
- **Manage Jenkins** → **Configure System** → **Global properties** → **Environment variables**

```
DOCKER_REGISTRY=docker.io
DEPLOY_ENV=production
```

## Running the Pipeline

### Manual Trigger
1. Go to your pipeline job
2. Click **Build Now**

### Automatic Trigger
- Push code to GitHub master branch
- Jenkins will automatically detect and build

## Pipeline Stages

1. **Checkout** - Clone repository
2. **Build Microservices** - Build all 11 microservices in parallel
3. **Run Tests** - Execute unit and integration tests
4. **Code Quality Analysis** - SonarQube scan (optional)
5. **Build Docker Images** - Create Docker images for all services
6. **Push to Docker Registry** - Push images to DockerHub
7. **Deploy** - Deploy to target environment

## Docker Compose Deployment

For local/dev deployment:

```bash
# Set environment variables
export MAIL_USERNAME=your-email@gmail.com
export MAIL_PASSWORD=your-app-password
export GOOGLE_CLIENT_ID=your-client-id
export GOOGLE_CLIENT_SECRET=your-client-secret

# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f
```

## Troubleshooting

### Build Fails on Maven
- Check Maven installation in Global Tool Configuration
- Verify pom.xml files are correct

### Docker Build Fails
- Ensure Docker is running on Jenkins server
- Check Dockerfile syntax
- Verify Docker credentials

### Tests Fail
- Check database connections
- Verify test configurations
- Review test logs in Jenkins console

### Deployment Issues
- Verify target environment is accessible
- Check deployment credentials
- Review deployment logs

## Monitoring

Access Jenkins at: `http://your-jenkins-url:8080`

View:
- Build history
- Console output
- Test results
- Build artifacts

## Email Notifications

Configure in **Manage Jenkins** → **Configure System** → **Extended E-mail Notification**:

- SMTP server: `smtp.gmail.com`
- SMTP port: `587`
- Use SSL: ✓
- Credentials: Add Gmail credentials

## Best Practices

1. Always run tests before deployment
2. Use semantic versioning for Docker images
3. Keep Jenkins plugins updated
4. Backup Jenkins configuration regularly
5. Use separate pipelines for dev/staging/prod
6. Monitor build times and optimize
7. Clean up old Docker images regularly

## Support

For issues, check:
- Jenkins console logs
- Docker logs: `docker logs <container-name>`
- Application logs in respective services
