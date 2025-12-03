#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "[RESET ALL] Resetting all WebArena containers..."

./reset_shopping.sh
./reset_shopping_admin.sh
./reset_forum.sh
./reset_gitlab.sh
./reset_kiwix.sh
./reset_map.sh

echo "[RESET ALL] COMPLETE."

