#!/bin/bash
#build script for rusk85/nginx-alpine-mrfs

#set -eoxu pipefail

CFGS=$(pwd)/cfgs

TAG=$(cat $CFGS/IMAGE)

BUILD_TIME="$(date +%d/%m/%y-%H:%M:%S%z)"
VERSION=$(cat $CFGS/VERSION)

printf "\nRemoving old containers and images ...\n"

# ref: https://linuxconfig.org/remove-all-containners-based-on-docker-image-name
docker ps -a | awk '{ print $1,$2 }' | grep ${TAG} | awk '{print $1 }' | xargs -I {} docker rm --force {}
docker rmi ${TAG}

printf "\nImage and dependant containers removed ...\n"

printf "\nBUILD_TIME set to ${BUILD_TIME} ...\n"
printf "\nVERSION set to ${VERSION} ...\n"
printf "\nRunning build ...\n"

docker build						\
		--no-cache				\
		-t ${TAG}:${VERSION}			\
		-t ${TAG}:latest			\
		--build-arg BUILD_TIME="${BUILD_TIME}"	\
	       	--build-arg VERSION="${VERSION}"	\
		.

printf "\nFinished building\n"

sh push_script.sh
