FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY order-service/pom.xml ./order-service/pom.xml
COPY order-service/src ./order-service/src
RUN mvn -f order-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/order-service/target/*.jar app.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]
