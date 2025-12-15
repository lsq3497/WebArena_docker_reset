#!/bin/bash
set -e

echo "[MAP] Resetting map frontend + backend..."

cd /home/ubuntu/openstreetmap-website/

MAP_CONTAINERS=$(docker ps -aq --filter "name=openstreetmap")
if [ ! -z "$MAP_CONTAINERS" ]; then
    echo "[MAP] Stopping and removing existing containers..."
    docker stop $MAP_CONTAINERS || true
    docker rm $MAP_CONTAINERS || true
fi

docker compose stop || true
docker compose rm -f || true
docker compose up -d

echo "[MAP] Done."

