FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY cart-service/pom.xml ./cart-service/pom.xml
COPY cart-service/src ./cart-service/src
RUN mvn -f cart-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/cart-service/target/*.jar app.jar
EXPOSE 8084
ENTRYPOINT ["java", "-jar", "app.jar"]
