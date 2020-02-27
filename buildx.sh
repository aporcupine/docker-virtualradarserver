#!/bin/sh

IMAGE=mikenye/virtualradarserver

# Build the image using buildx
docker buildx build -t ${IMAGE}:latest --compress --push --platform linux/amd64,linux/arm/v7,linux/arm64 .

# Starting container to pull version from container logs
VERSION=`timeout 5 docker run --rm -i --name get_vrs_version --entrypoint cat ${IMAGE}:latest /VERSION`
# Tag the freshly built image
echo ""
echo VirtualRadarServer version ${VERSION} found
echo ""
docker buildx build -t ${IMAGE}:${VERSION} --compress --push --platform linux/amd64,linux/arm/v7,linux/arm64 .

# Kill the temporary container if its still running (timeout will kill it automatically after 5 seconds in case this script dies)
docker kill get_vrs_version > /dev/null 2>&1
