#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

docker stop kiwix33 || true
docker rm kiwix33 || true

docker run -d --name=kiwix33 \
    -p ${KIWIX_PORT}:80 \
    -v /home/ubuntu/wiki:/data \
    ghcr.io/kiwix/kiwix-serve:3.3.0 \
    /data/wikipedia_en_all_maxi_2022-05.zim

sleep 2
docker ps | grep -q kiwix33 || { docker logs kiwix33; exit 1; }

echo "[KIWIX] Done."

