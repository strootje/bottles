#!/usr/bin/env bash

FILES=$(find . -type f -name "*.dockerfile")
for FILE in $FILES; do
	DIRNAME=$(dirname $FILE)
	BASEDIR=$(basename $DIRNAME)
	FILENAME=$(basename $FILE)
	BASENAME=${FILENAME%.*}

	docker build -f $FILE -t "$BASEDIR/$BASENAME" $DIRNAME
done
