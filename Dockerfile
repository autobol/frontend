FROM alpine:latest AS build

ENV YARN_VERSION 1.22.11 \
 GRADLE_VERSION 6.7.1

ENV NVM_DIR /app/nvm
ENV NODE_VERSION 14.15.0

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
 nvm install $NODE_VERSION
# nvm alias default $NODE_VERSION \
# nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules

RUN node -v
RUN npm -v

RUN yarn set version $YARN_VERSION &&\
 gradle wrapper --gradle-version $GRADLE_VERSION &&\
 chmod +x gradlew

RUN ["./gradlew", "jar"]


FROM openjdk:8 AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/devschool-front-app-server/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
