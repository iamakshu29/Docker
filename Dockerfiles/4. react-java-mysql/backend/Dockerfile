FROM maven:3.8.5-eclipse-temurin-17 AS builder
LABEL Author="Akshat Verma"

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /src/awesome-compose/react-java-mysql/backend
RUN mvn dependency:go-offline -B

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=builder /src/awesome-compose/react-java-mysql/backend/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]