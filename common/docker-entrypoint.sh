#!/bin/bash

# If /var/www/html is empty (fresh volume), copy codebase from /opt/mautic
if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
    echo "[Entrypoint] /var/www/html is empty, copying Mautic codebase..."
    cp -a /opt/mautic/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

chown -R www-data:www-data /var/www/html/config
chmod -R 777 /var/www/html/config

if [ "$DOCKER_MAUTIC_ROLE" = "mautic_worker" ]; then
	/entrypoint_mautic_worker.sh
elif [ "$DOCKER_MAUTIC_ROLE" = "mautic_cron" ]; then
	/entrypoint_mautic_cron.sh
elif [ "$DOCKER_MAUTIC_ROLE" = "mautic_web" ]; then
	/entrypoint_mautic_web.sh "$@"
else
	echo "no entrypoint specified, exiting"
	exit 1
fi
