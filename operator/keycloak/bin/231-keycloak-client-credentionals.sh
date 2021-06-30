#!/bin/bash

set -e

CLIENT_NAME=${CLIENT_NAME:-client-example}
NS=${NS:-namespace-example}
REALM_ID=${REALM_ID:-ldap-realm-example}

oc -n $NS get secret keycloak-client-secret-${CLIENT_NAME} \
    -o jsonpath='{ "CLIENT_ID:" }{.data.CLIENT_ID }{ "\nCLIENT_SECRET:" }{ .data.CLIENT_SECRET }{"\n"}'

cat << EOF
#
# use "$BASH_SOURCE | awk -F: '/<KEY>/ { print \$2; }' | base64 -d ; echo" to reveal value
#
EOF