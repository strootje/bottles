FROM openjdk:alpine

RUN apk add git

WORKDIR /usr/src/server
RUN wget -O BungeeCord.jar https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar

CMD java -jar BungeeCord.jar
