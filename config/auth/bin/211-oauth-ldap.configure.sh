#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)
MANIFEST=${1:-${base}/manifest/oauth-ldap-example.yaml}

IDP_CA_BUNDLE_CM=${IDP_CA_BUNDLE_CM:-idp-ca-example}
IDP_CLIENT_SECRET=${IDP_CLIENT_SECRET:-idp-secret-example}
LDAP_BIND_DN=${LDAP_BIND_DN:-uid=ocp-bind,cn=users,dc=example,dc=com}
LDAP_IDP_NAME=${LDAP_IDP_NAME:-idp-openid-example}
LDAP_URL=${LDAP_URL:-ldap://ldap.example.com/dc=example,dc=com}
LDAP_USER_GROUP_FILTER_OPT=${LDAP_USER_GROUP_FILTER_OPT}

sed "
     s/bindDN:.*/bindDN: $LDAP_BIND_DN/ ; \
     s/clientID: idp-clientid-example/clientID: $CLIENT_NAME/ ; \
     s/name: idp-ldap-example/name: $LDAP_IDP_NAME/ ; \
     s/name: idp-ca-example/name: $IDP_CA_CHAIN_CM/ ; \
     s/name: idp-secret-example/name: $IDP_CLIENT_SECRET/ ; \
     s|url: ldap://ldap.example.com/dc=example,dc=com|url: ${LDAP_URL}| ; \
     s|(memberOf=cn=ocp-users,cn=groups,dc=example,dc=com)|$LDAP_USER_GROUP_FILTER_OPT| ; \
    " $MANIFEST

cat << EOF
#
# do NOT APPLY this configuration, just MERGE
#
EOF

