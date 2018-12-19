#!/usr/bin/env zsh

COMPOSEFILE=./owncloud/docker-compose.yaml
CONTAINERID=$(docker ps -aqf "name=owncloud_app")

if [ -z "$CONTAINERID" ]; then
	docker-compose -f $COMPOSEFILE up -d
	CONTAINERID=$(docker ps -aqf "name=owncloud_app")
else
	docker-compose -f $COMPOSEFILE down
	# docker container prune -f
	# docker volume prune -f
	# docker network prune -f
fi
