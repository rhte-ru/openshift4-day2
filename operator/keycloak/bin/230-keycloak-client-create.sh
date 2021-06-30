#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CLIENT_NAME=${CLIENT_NAME:-client-example}
CLIENT_BASE_URL=${CLIENT_BASE_URL:-https://example.com}
CLIENT_REDIRECT_URL=${CLIENT_REDIRECT_URL:-https://oauth.example.com/oauth2callback/keycloak-sso}

LABEL_KEY=${LABEL_KEY:-label.name}
LABEL_VALUE=${LABEL_VALUE:-label-value}

MANIFEST=${1:-${base}/manifest/keycloak-client-example.yaml}
NS=${NS:-namespace-example}

REALM_ID=${REALM_ID:-ldap-realm-example}

sed "s/namespace: namespace-example/namespace: $NS/ ; \
     s|- https://oauth.example.com/oauth2callback/keycloak-sso|- $CLIENT_REDIRECT_URL| ;\
     s|- https://example.com|- $CLIENT_BASE_URL| ; \
     s|baseUrl: https://example.com|baseUrl: $CLIENT_BASE_URL| ; \
     s/: realm-example/: $REALM_ID/ ; \
     s/: client-example/: $CLIENT_NAME/ ; \
     s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ; \
    " $MANIFEST

cat << EOF
#
# to apply manifest run with (permissions reured):
# $BASH_SOURCE | oc apply -f -
#
EOF
