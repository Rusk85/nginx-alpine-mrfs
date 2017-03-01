#build script for rusk85/nginx-alpine-mrfs

TAG=rusk85/nginx-alpine-mrfs

# block for creating proper version number
IMAGE_VERSION=$(date +%g%j)
MM_VERSION="0.3" # major.minor.
BUILD_TIME="$(date +%d/%m/%y %H:%M:%S%z)"
if [ "$#" -eq 1 ]; then
	IMAGE_REVD=$1 # counting all builds of the day
	IMAGE_VERSION=${IMAGE_VERSION}${IMAGE_REVD}
fi
VERSION=${MM_VERSION}.${IMAGE_VERSION}

printf "\nRemoving old containers and images ...\n"

# ref: https://linuxconfig.org/remove-all-containners-based-on-docker-image-name
docker ps -a | awk '{ print $1,$2 }' | grep ${TAG} | awk '{print $1 }' | xargs -I {} docker rm {}
docker rmi ${TAG}

printf "\nImage and dependant containers removed ...\n"

printf "\nBUILD_TIME set to ${BUILD_TIME} ...\n"
printf "\nVERSION set to ${VERSION} ...\n"
printf "\nRunning build ...\n"

docker build						\
		--no-cache				\
		-t ${TAG}:${MM_VERSION}			\
		-t ${TAG}:latest			\
		--build-arg BUILD_TIME="${BUILD_TIME}"	\
	       	--build-arg VERSION="${VERSION}"	\
		.
