FROM alpine:latest AS build

RUN apk --no-cache add openjdk8 &&\
 apk --no-cache add nodejs &&\
  apk --no-cache add yarn &&\
   apk --no-cache add gradle &&\
     mkdir -p /app
WORKDIR /app
COPY . /app
RUN gradle wrapper --gradle-version 6.7.1 &&\
  chmod +x gradlew
RUN ["./gradlew", "jar"]
RUN ["ls", "./devschool-front-app-server/"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/devschool-front-app-server/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
