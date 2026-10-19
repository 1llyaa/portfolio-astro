#!/bin/sh
# Picks the nginx site config at container start, so MAINTENANCE can be
# flipped with a restart instead of a rebuild. Both branches overwrite
# default.conf, so turning maintenance off also works on a restarted
# (not recreated) container. Runs before the image's
# 10-listen-on-ipv6-by-default.sh, which then patches the normal config as usual.
set -e

mode=$(printf '%s' "${MAINTENANCE:-}" | tr '[:upper:]' '[:lower:]')

if [ "$mode" = "true" ]; then
    cp /etc/nginx/maintenance.conf /etc/nginx/conf.d/default.conf
    echo "$0: maintenance mode ON"
else
    cp /etc/nginx/site.conf /etc/nginx/conf.d/default.conf
fi
