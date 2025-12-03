#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

docker stop forum || true
docker rm forum || true

docker run --name forum -p ${FORUM_PORT}:80 -d ${FORUM_IMAGE}

echo "[FORUM] Done."

