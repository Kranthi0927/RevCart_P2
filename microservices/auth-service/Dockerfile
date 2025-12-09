FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY ../pom.xml ./pom.xml
COPY auth-service/pom.xml ./auth-service/pom.xml
COPY auth-service/src ./auth-service/src
RUN mvn -f auth-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/auth-service/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
