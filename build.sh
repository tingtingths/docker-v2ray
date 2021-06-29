#!/usr/bin/env sh
docker build -t tingtingths/v2ray:$1 --build-arg VERSION=$1 .
