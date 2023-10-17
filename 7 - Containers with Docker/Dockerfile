FROM amazoncorretto:17-alpine

RUN mkdir -p /home/java-app

COPY build/libs/bootcamp-docker-java-mysql-project-1.0-SNAPSHOT.jar /home/java-app

WORKDIR /home/java-app

RUN addgroup -S app && adduser -S app -G app

RUN chown -R app:app /home/java-app

USER app

CMD ["java", "-jar", "bootcamp-docker-java-mysql-project-1.0-SNAPSHOT.jar"]
