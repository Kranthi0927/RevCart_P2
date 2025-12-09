FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY analytics-service/pom.xml ./analytics-service/pom.xml
COPY analytics-service/src ./analytics-service/src
RUN mvn -f analytics-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/analytics-service/target/*.jar app.jar
EXPOSE 8090
ENTRYPOINT ["java", "-jar", "app.jar"]
