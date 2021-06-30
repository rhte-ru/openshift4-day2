#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

ADMIN_URL=$(bash $base/bin/216-keycloak-admin-endpoint.sh)

echo $ADMIN_URL | grep -q '^https://' || cat << EOF
#
# !!!!!!!!!!!! Looks like ADMIN_URL "$ADMIN_URL" does not have "https://" scheme configured
#
EOF

ENDPOINT_HOST=$(echo $ADMIN_URL | sed 's|http.*//||')
ENDPOINT_PORT=$(echo $ADMIN_URL | sed 's/.*:\([0-9]\+\)$/\1/')
[ "$ENDPOINT_PORT" = "" -o "$ENDPOINT_PORT" = "$ADMIN_URL" ] && ENDPOINT_PORT=443

openssl s_client -connect $ENDPOINT_HOST:$ENDPOINT_PORT -servername $ENDPOINT_HOST -showcerts < /dev/null 2> /dev/null \
    | sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p'
