FROM autobol/image_for_build_front:latest AS build

ARG YARN_VERSION \
 GRADLE_VERSION

ENV YARN_VERSION=$YARN_VERSION \
 GRADLE_VERSION=$GRADLE_VERSION 

WORKDIR /app
COPY . /app
RUN yarn set version $YARN_VERSION &&\
 gradle wrapper --gradle-version $GRADLE_VERSION &&\
 chmod +x gradlew
RUN ["./gradlew", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/devschool-front-app-server/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
