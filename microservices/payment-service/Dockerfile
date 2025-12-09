FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY payment-service/pom.xml ./payment-service/pom.xml
COPY payment-service/src ./payment-service/src
RUN mvn -f payment-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/payment-service/target/*.jar app.jar
EXPOSE 8086
ENTRYPOINT ["java", "-jar", "app.jar"]
