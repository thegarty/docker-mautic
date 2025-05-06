#!/bin/bash

set -e

# If /var/www/html is empty (fresh volume), copy codebase from /opt/mautic
if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
    echo "[Entrypoint] /var/www/html is empty, copying Mautic codebase..."
    cp -a /opt/mautic/. /var/www/html/ && \
    chown -R www-data:www-data /var/www/html
fi

echo "[Entrypoint] Fixing permissions for config directory..."
chown -R www-data:www-data /var/www/html/config
chmod -R 775 /var/www/html/config

# Run role-specific entrypoint
case "$DOCKER_MAUTIC_ROLE" in
    mautic_worker)
        /entrypoint_mautic_worker.sh
        ;;
    mautic_cron)
        /entrypoint_mautic_cron.sh
        ;;
    mautic_web)
        /entrypoint_mautic_web.sh "$@"
        ;;
    *)
        echo "[Entrypoint] ERROR: No valid DOCKER_MAUTIC_ROLE specified."
        exit 1
        ;;
esac
