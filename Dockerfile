FROM alpine:latest AS build

ARG NODE_VERSION=14.15.0
ENV NODE_VERSION=$NODE_VERSION
ARG YARN_VERSION=1.22.11
ENV YARN_VERSION=$YARN_VERSION
ARG GRADLE_VERSION=6.7.1
ENV GRADLE_VERSION=$GRADLE_VERSION

RUN apk --no-cache add openjdk8 &&\
 apk --no-cache add yarn &&\
  apk --no-cache add gradle &&\
   mkdir -p /app
WORKDIR /app
COPY . /app
RUN chmod +x nvm.sh &&\
 nvm.sh &&\
  nvm install $NODE_VERSION &&\
   yarn set version $YARN_VERSION &&\
    gradle wrapper --gradle-version $GRADLE_VERSION &&\
     chmod +x gradlew
RUN ["./gradlew", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/devschool-front-app-server/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
