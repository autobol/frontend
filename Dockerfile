FROM java:8-jdk AS build

RUN apk --no-cache add gradle &&\
  apk --no-cache add nodejs &&\
   apk --no-cache add yarn &&\
    mkdir -p /app
WORKDIR /app
COPY . /app
RUN ["gradle", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/build/libs/*.jar app.jar
RUN apk --no-cache add openjdk8
ENTRYPOINT ["java", "-jar", "app.jar"]
