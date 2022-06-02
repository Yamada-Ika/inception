#!/bin/sh

NGINX_HOST=${DOMAIN_NAME}
NGINX_PORT=${NGINX_PORT}

exec /usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf
