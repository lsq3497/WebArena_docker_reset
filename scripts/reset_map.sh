#!/bin/bash
set -e

echo "[MAP] Resetting map frontend + backend..."

cd /home/ubuntu/openstreetmap-website/

docker compose stop || true
docker compose rm -f || true
docker compose up -d

echo "[MAP] Done."

