pipeline {
    agent any
    
    tools {
        maven 'Maven-3.9'
        nodejs 'NodeJS-18'
        jdk 'JDK-17'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        GIT_CREDENTIALS_ID = 'github-credentials'
        SONARQUBE_SERVER = 'SonarQube'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: "${GIT_CREDENTIALS_ID}",
                    url: 'https://github.com/Kranthi0927/RevCart_P2.git'
            }
        }
        
        stage('Build Microservices') {
            parallel {
                stage('Auth Service') {
                    steps {
                        dir('microservices/auth-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('User Service') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Product Service') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Cart Service') {
                    steps {
                        dir('microservices/cart-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Order Service') {
                    steps {
                        dir('microservices/order-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Payment Service') {
                    steps {
                        dir('microservices/payment-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Notification Service') {
                    steps {
                        dir('microservices/notification-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Delivery Service') {
                    steps {
                        dir('microservices/delivery-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Admin Service') {
                    steps {
                        dir('microservices/admin-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Analytics Service') {
                    steps {
                        dir('microservices/analytics-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('API Gateway') {
                    steps {
                        dir('microservices/api-gateway') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('Backend Tests') {
                    steps {
                        dir('microservices') {
                            sh 'mvn test'
                        }
                    }
                }
                stage('Frontend Tests') {
                    steps {
                        dir('revcart-frontend') {
                            sh 'npm install'
                            sh 'npm run test -- --watch=false --browsers=ChromeHeadless'
                        }
                    }
                }
            }
        }
        
        stage('Code Quality Analysis') {
            steps {
                script {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        dir('microservices') {
                            sh 'mvn sonar:sonar'
                        }
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            parallel {
                stage('Auth Service Image') {
                    steps {
                        dir('microservices/auth-service') {
                            sh 'docker build -t revcart-auth-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('User Service Image') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'docker build -t revcart-user-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Product Service Image') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'docker build -t revcart-product-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Cart Service Image') {
                    steps {
                        dir('microservices/cart-service') {
                            sh 'docker build -t revcart-cart-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Order Service Image') {
                    steps {
                        dir('microservices/order-service') {
                            sh 'docker build -t revcart-order-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Payment Service Image') {
                    steps {
                        dir('microservices/payment-service') {
                            sh 'docker build -t revcart-payment-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Notification Service Image') {
                    steps {
                        dir('microservices/notification-service') {
                            sh 'docker build -t revcart-notification-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Delivery Service Image') {
                    steps {
                        dir('microservices/delivery-service') {
                            sh 'docker build -t revcart-delivery-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Admin Service Image') {
                    steps {
                        dir('microservices/admin-service') {
                            sh 'docker build -t revcart-admin-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Analytics Service Image') {
                    steps {
                        dir('microservices/analytics-service') {
                            sh 'docker build -t revcart-analytics-service:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('API Gateway Image') {
                    steps {
                        dir('microservices/api-gateway') {
                            sh 'docker build -t revcart-api-gateway:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Frontend Image') {
                    steps {
                        dir('revcart-frontend') {
                            sh 'docker build -t revcart-frontend:${BUILD_NUMBER} .'
                        }
                    }
                }
            }
        }
        
        stage('Push to Docker Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        sh '''
                            docker tag revcart-auth-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-auth-service:${BUILD_NUMBER}
                            docker tag revcart-user-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-user-service:${BUILD_NUMBER}
                            docker tag revcart-product-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-product-service:${BUILD_NUMBER}
                            docker tag revcart-cart-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-cart-service:${BUILD_NUMBER}
                            docker tag revcart-order-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-order-service:${BUILD_NUMBER}
                            docker tag revcart-payment-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-payment-service:${BUILD_NUMBER}
                            docker tag revcart-notification-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-notification-service:${BUILD_NUMBER}
                            docker tag revcart-delivery-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-delivery-service:${BUILD_NUMBER}
                            docker tag revcart-admin-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-admin-service:${BUILD_NUMBER}
                            docker tag revcart-analytics-service:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-analytics-service:${BUILD_NUMBER}
                            docker tag revcart-api-gateway:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-api-gateway:${BUILD_NUMBER}
                            docker tag revcart-frontend:${BUILD_NUMBER} ${DOCKER_REGISTRY}/revcart-frontend:${BUILD_NUMBER}
                            
                            docker push ${DOCKER_REGISTRY}/revcart-auth-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-user-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-product-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-cart-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-order-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-payment-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-notification-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-delivery-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-admin-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-analytics-service:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-api-gateway:${BUILD_NUMBER}
                            docker push ${DOCKER_REGISTRY}/revcart-frontend:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Environment') {
            steps {
                script {
                    echo "Deploying to ${env.DEPLOY_ENV} environment"
                    // Add your deployment logic here (Kubernetes, Docker Compose, etc.)
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build succeeded: ${env.BUILD_URL}",
                to: 'kranthikiran0927@gmail.com'
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build failed: ${env.BUILD_URL}",
                to: 'kranthikiran0927@gmail.com'
            )
        }
        always {
            cleanWs()
        }
    }
}
