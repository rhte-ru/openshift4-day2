#!/bin/bash

set -e

NS=${NS:-namespace-example}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-keycloak-instance-example}

oc -n $NS get secret credential-${OPERATOR_INSTANCE} \
    -o jsonpath='{ "USERNAME:" }{.data.ADMIN_USERNAME }{ "\nPASSWORD:" }{ .data.ADMIN_PASSWORD }{"\n"}'

cat << EOF
#
# use "$BASH_SOURCE | awk -F: '/<KEY>/ { print \$2; }' | base64 -d ; echo" to reveal value
#
EOF