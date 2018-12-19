FROM openjdk:alpine

RUN apk add git

WORKDIR /usr/src/build
RUN wget -O BuildTool.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
	&& java -jar ./BuildTool.jar

WORKDIR /usr/src/server
RUN cp ./../build/spigot-1.13.2.jar ./spigot.jar

CMD java -jar ./spigot.jar
