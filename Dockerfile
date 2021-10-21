FROM alpine:latest AS build

RUN apk --no-cache add openjdk8 &&\
 apk --no-cache add gradle=6.7.1 &&\
  apk --no-cache add nodejs=14.15.0 &&\
   # apk --no-cache add yarn &&\
    mkdir -p /app
WORKDIR /app
COPY . /app
RUN ["gradle", "jar"]


FROM alpine:latest AS work

RUN mkdir /app
WORKDIR /app
COPY --from=build app/build/libs/*.jar app.jar
RUN apk --no-cache add openjdk8
ENTRYPOINT ["java", "-jar", "app.jar"]
