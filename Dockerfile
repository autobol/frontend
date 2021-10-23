FROM alpine:latest AS build

RUN apk --no-cache add openjdk8 &&\
 apk --no-cache add nodejs &&\
  apk --no-cache add yarn &&\
   apk --no-cache add gradle &&\
    apk --no-cache add curl &&\
     mkdir -p /app
WORKDIR /app
COPY . /app
RUN curl -L -O https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh &&\
 ls &&\
 install.sh
RUN nvm install v14.15.0 &&\
 gradle wrapper --gradle-version 6.7.1 &&\
  chmod +x gradlew
RUN ["./gradlew", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
