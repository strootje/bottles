#!/usr/bin/env bash

# login to docker
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

FILES=$(find . -type f -name "*.dockerfile")
for FILE in $FILES; do
	DIRNAME=$(dirname $FILE)
	BASEDIR=$(basename $DIRNAME)
	FILENAME=$(basename $FILE)
	BASENAME=${FILENAME%.*}

	docker push "$BASEDIR/$BASENAME"
done
