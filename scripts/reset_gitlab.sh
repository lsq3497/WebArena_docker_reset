#!/bin/bash
set -e
cd "$(dirname "$0")/../"

source config.env

echo "[GITLAB] Resetting GitLab container..."

docker stop gitlab || true
docker rm gitlab || true

docker run --name gitlab -d -p ${GITLAB_PORT}:${GITLAB_PORT} \
    ${GITLAB_IMAGE} /opt/gitlab/embedded/bin/runsvdir-start

echo "[GITLAB] Waiting 300 seconds for GitLab to start..."

sleep 300

echo "[GITLAB] Updating external_url..."

docker exec gitlab sed -i \
  "s|^external_url.*|external_url 'http://${HOSTNAME}:${GITLAB_PORT}'|" \
  /etc/gitlab/gitlab.rb

docker exec gitlab gitlab-ctl reconfigure

echo "[GITLAB] Checking 502 errors..."

docker exec gitlab bash -c "rm -f /var/opt/gitlab/postgresql/data/postmaster.pid || true"
docker exec gitlab bash -c "/opt/gitlab/embedded/bin/pg_resetwal -f /var/opt/gitlab/postgresql/data || true"

docker exec gitlab gitlab-ctl restart

echo "[GITLAB] Done."

