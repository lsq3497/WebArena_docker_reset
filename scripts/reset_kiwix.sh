#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

docker stop kiwix33 || true
docker rm kiwix33 || true

docker run -d --name=kiwix33 \
    -p ${KIWIX_PORT}:80 \
    -v /data:/data \
    ghcr.io/kiwix/kiwix-serve:3.3.0 wikipedia_en_all_maxi_2022-05.zim

echo "[KIWIX] Done."

