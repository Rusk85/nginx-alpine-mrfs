#build script for rusk85/nginx-alpine-mrfs

TAG=rusk85/nginx-alpine-mrfs

# block for creating proper version number
IMAGE_VERSION=$(date +%g%j)
MM_VERSION="0.2." # major.minor.
if [ "$#" -eq 1 ]; then
	IMAGE_REVD=$1 # counting all builds of the day
	IMAGE_VERSION=${IMAGE_VERSION}${IMAGE_REVD}
fi
VERSION=${MM_VERSION}${IMAGE_VERSION}
# test version output
#echo ${VERSION}

docker build -t ${TAG} --build-arg BUILD_TIME="$(date)" --build-arg VERSION="${VERSION}" .
