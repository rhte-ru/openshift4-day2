#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

NS=${NS:-namespace-example}
REALM_ID=${REALM_ID:-ldap-realm-example}

curl -kL $($base/bin/216-keycloak-admin-endpoint.sh)/auth/realms/$REALM_ID/.well-known/openid-configuration 2> /dev/null
