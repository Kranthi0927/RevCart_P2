FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY notification-service/pom.xml ./notification-service/pom.xml
COPY notification-service/src ./notification-service/src
RUN mvn -f notification-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/notification-service/target/*.jar app.jar
EXPOSE 8087
ENTRYPOINT ["java", "-jar", "app.jar"]
