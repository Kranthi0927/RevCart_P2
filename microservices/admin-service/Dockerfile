FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY admin-service/pom.xml ./admin-service/pom.xml
COPY admin-service/src ./admin-service/src
RUN mvn -f admin-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/admin-service/target/*.jar app.jar
EXPOSE 8089
ENTRYPOINT ["java", "-jar", "app.jar"]
