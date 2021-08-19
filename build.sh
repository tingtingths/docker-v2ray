#!/usr/bin/env sh

if [ -z "$1" ]; then
	echo 'Missing version argument, e.g. build.sh v4.33.0'
    exit 1
fi

echo "Building version ${1}..."
sleep 3
docker build --no-cache -t registry.itdog.me/v2ray:$1 --build-arg VERSION=$1 . \
	&& docker tag registry.itdog.me/v2ray:$1 registry.itdog.me/v2ray:latest \
	&& docker push registry.itdog.me/v2ray:$1 \
	&& docker push registry.itdog.me/v2ray:latest
