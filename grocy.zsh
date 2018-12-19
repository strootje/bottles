#!/usr/bin/env zsh

COMPOSEFILE=./grocy/docker-compose.yml
CONTAINERID=$(docker ps -aqf "name=grocy")

if [ -z "$CONTAINERID" ]; then
	docker-compose -f $COMPOSEFILE up -d
	CONTAINERID=$(docker ps -aqf "name=grocy")
else
	docker-compose -f $COMPOSEFILE down
	# docker container prune -f
	# docker volume prune -f
	# docker network prune -f
fi
