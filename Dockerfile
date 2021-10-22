FROM alpine:latest AS build

RUN --no-cache add openjdk8 &&\
 apk --no-cache add nodejs &&\
  apk --no-cache add yarn &&\
   apk --no-cache add gradle &&\
    mkdir -p /app
WORKDIR /app
COPY . /app
RUN ["gradle", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
