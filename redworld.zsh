#!/usr/bin/env zsh

COMPOSEFILE=./redworld/docker-compose.yaml
CONTAINERID=$(docker ps -aqf "name=redworld_bungee")

if [ -z "$CONTAINERID" ]; then
	docker-compose -f $COMPOSEFILE up -d
	CONTAINERID=$(docker ps -aqf "name=redworld_bungee")
else
	docker-compose -f $COMPOSEFILE down
	# docker container prune -f
	# docker volume prune -f
	# docker network prune -f
fi
