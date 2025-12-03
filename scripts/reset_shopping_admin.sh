#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

echo "[SHOPPING ADMIN] Resetting shopping_admin container..."

docker stop shopping_admin || true
docker rm shopping_admin || true

docker run --name shopping_admin -p ${SHOPPING_ADMIN_PORT}:80 -d ${SHOPPING_ADMIN_IMAGE}

echo "[SHOPPING ADMIN] Waiting 60 seconds..."

sleep 60

docker exec shopping_admin /var/www/magento2/bin/magento setup:store-config:set \
    --base-url="http://${HOSTNAME}:${SHOPPING_ADMIN_PORT}"

docker exec shopping_admin mysql -u magentouser -pMyPassword magentodb -e \
    "UPDATE core_config_data SET value='http://${HOSTNAME}:${SHOPPING_ADMIN_PORT}/' WHERE path='web/secure/base_url';"

docker exec shopping_admin php /var/www/magento2/bin/magento config:set admin/security/password_is_forced 0
docker exec shopping_admin php /var/www/magento2/bin/magento config:set admin/security/password_lifetime 0

docker exec shopping_admin /var/www/magento2/bin/magento cache:flush

echo "[SHOPPING ADMIN] Done."

