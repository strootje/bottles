#!/usr/bin/env zsh

COMPOSEFILE=./firefly3/docker-compose.yaml
CONTAINERID=$(docker ps -aqf "name=firefly_app")
VOLUMEID=$(docker volume ls -f "name=firefly_dbdata" | grep firefly_dbdata)

if [ -z "$CONTAINERID" ]; then
	docker-compose -f $COMPOSEFILE up -d
	CONTAINERID=$(docker ps -aqf "name=firefly_app")

	if [ -z "$VOLUMEID" ]; then
		sleep 5s
		docker exec -it $CONTAINERID php artisan migrate --seed
		docker exec -it $CONTAINERID php artisan firefly:upgrade-database
		docker exec -it $CONTAINERID php artisan firefly:verify
		docker exec -it $CONTAINERID php artisan passport:install
		docker exec -it $CONTAINERID php artisan cache:clear
	fi
else
	docker-compose -f $COMPOSEFILE down
	# docker container prune -f
	# docker volume prune -f
	# docker network prune -f
fi
