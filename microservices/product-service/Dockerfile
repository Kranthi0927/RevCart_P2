FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY product-service/pom.xml ./product-service/pom.xml
COPY product-service/src ./product-service/src
RUN mvn -f product-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/product-service/target/*.jar app.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]
