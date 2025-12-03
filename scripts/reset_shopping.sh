#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

echo "[SHOPPING] Resetting shopping container..."

docker stop shopping || true
docker rm shopping || true

docker run --name shopping -p ${SHOPPING_PORT}:80 -d ${SHOPPING_IMAGE}

echo "[SHOPPING] Waiting 60 seconds for Magento services..."

sleep 60

echo "[SHOPPING] Updating Magento base URLs..."

docker exec shopping /var/www/magento2/bin/magento setup:store-config:set \
    --base-url="http://${HOSTNAME}:${SHOPPING_PORT}"

docker exec shopping mysql -u magentouser -pMyPassword magentodb -e \
    "UPDATE core_config_data SET value='http://${HOSTNAME}:${SHOPPING_PORT}/' WHERE path='web/secure/base_url';"

docker exec shopping /var/www/magento2/bin/magento cache:flush

echo "[SHOPPING] Done."

