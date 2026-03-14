FROM amazoncorretto:8

EXPOSE 8080

WORKDIR /usr/app/spring-project

COPY . .

RUN ./mvnw package

CMD ["java", "-jar", "./target/docker-example-1.1.3.jar"]
