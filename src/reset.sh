#!/usr/bin/env bash

set -e

VOLUME_NAME=nirvaidbcore

docker compose down
docker container prune

docker volume rm $VOLUME_NAME
docker volume create $VOLUME_NAME

docker compose build

docker compose up
