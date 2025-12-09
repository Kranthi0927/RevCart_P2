FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml ./pom.xml
COPY delivery-service/pom.xml ./delivery-service/pom.xml
COPY delivery-service/src ./delivery-service/src
RUN mvn -f delivery-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/delivery-service/target/*.jar app.jar
EXPOSE 8088
ENTRYPOINT ["java", "-jar", "app.jar"]
