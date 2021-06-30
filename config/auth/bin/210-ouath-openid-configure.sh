#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)
MANIFEST=${1:-${base}/manifest/oauth-openid-example.yaml}

IDP_CA_CHAIN_CM=${IDP_CA_CHAIN_CM:-idp-ca-example}
IDP_CLIENT_SECRET=${IDP_CLIENT_SECRET:-idp-secret-example}
OPENID_IDP_NAME=${OPENID_IDP_NAME:-idp-openid-example}
# OPENID_DEFAULT_ISSUER=https://www.idp-issuer.com
OPENID_ISSUER=${OPENID_ISSUER}

oc get OAuth/cluster -o yaml > ${CLIENT_NAME}-oauth-config.yaml.backup

function get_openid_issuer() {
    if [ "$OPENID_ISSUER" = "" ] ; then
        OPENID_ISSUER=$(bash $base/../../operator/keycloak/bin/221-keycloak-realm-endpoints.sh | tr ',' '\n' | awk -F: '/"issuer":/ { print $2":"$3; }' | sed 's/,.*//')
    fi
    export OPENID_ISSUER
}

get_openid_issuer

sed "
     s/clientID: idp-clientid-example/clientID: $CLIENT_NAME/ ; \
     s|issuer: https://www.idp-issuer.com|issuer: $OPENID_ISSUER| ; \
     s/name: idp-openid-example/name: $OPENID_IDP_NAME/ ; \
     s/name: idp-ca-example/name: $IDP_CA_CHAIN_CM/ ; \
     s/name: idp-secret-example/name: $IDP_CLIENT_SECRET/ ; \
    " $MANIFEST

cat << EOF
#
# do NOT APPLY this configuration, just MERGE
#
EOF

