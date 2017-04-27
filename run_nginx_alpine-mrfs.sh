#!/bin/bash

set -eou pipefil

CFGS=$(pwd)/cfgs
IMAGE_NAME=$(cat $CFGS/IMAGE)
CONTAINER_NAME=$(cat $CFGS/CONTAINER)

set +eou pipefail
printf "Stopping and deleting previous container...\n"
docker rm -f $CONTAINER_NAME


set -eou pipefil
printf "\nRunning new container off of latest build...\n"

docker run -d --name $CONTAINER_NAME -p 80:8080 -ti $IMAGE_NAME

printf "\n$IMAGE_NAME is now running as $CONTAINER_NAME\n"
