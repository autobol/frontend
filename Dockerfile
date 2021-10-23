FROM alpine:latest AS build

ARG YARN_VERSION \
 GRADLE_VERSION \
 NODE_VERSION

ENV YARN_VERSION=$YARN_VERSION \
 GRADLE_VERSION=$GRADLE_VERSION \
 NVM_DIR=/app/nvm \
 NODE_VERSION=$NODE_VERSION

RUN apk --no-cache add openjdk8 &&\
 apk --no-cache add yarn &&\
 apk --no-cache add gradle &&\
 apk --no-cache add curl &&\
 apk --no-cache add bash &&\
 mkdir -p /app/nvm
WORKDIR /app
COPY . /app

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash &&\
 source $NVM_DIR/nvm.sh &&\
 nvm install $NODE_VERSION &&\
 nvm use $NODE_VERSION &&\
 yarn set version $YARN_VERSION &&\
 gradle wrapper --gradle-version $GRADLE_VERSION &&\
 chmod +x gradlew

RUN ["./gradlew", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/devschool-front-app-server/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
