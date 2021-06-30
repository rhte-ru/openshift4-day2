#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

BIND_DN=${BIND_DN:-USERNAME}
BIND_PASSWORD=${BIND_PASSWORD:-plain-text-password}

LABEL_KEY=${LABEL_KEY:-label.name}
LABEL_VALUE=${LABEL_VALUE:-label-value}
LDAP_BASE=${LDAP_BASE:-dc=example,dc=com}
LDAP_FILTER=${LDAP_FILTER:-"''"}
LDAP_URI=${LDAP_URI:-ldap://idm.example.com}

MANIFEST=${1:-${base}/manifest/keycloak-realm-example.yaml}
NS=${NS:-namespace-example}

OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-keycloak-instance-example}

REALM_ID=${REALM_ID:-ldap-realm-example}
REALM_NAME=${REALM_NAME:-LDAPRealm}

USERS_DN=${USERS_DN:-cn=users,cn=accounts,dc=example,dc=com}

#    s/keycloak: keycloak-example/keycloak: $KEYCLOAK_NAME/ ;
sed "s/namespace: namespace-example/namespace: $NS/ ; \
     s/: realm-example/: $REALM_ID/ ; s/: LDAPRealm/: $REALM_NAME/ ;
     s/bindDn: USERNAME/bindDn: $BIND_DN/ ; s/bindCredential: plain-text-password/bindCredential: $BIND_PASSWORD/ ;
     s|connectionUrl: ldap://idm.example.com|connectionUrl: $LDAP_URI| ;
     s/customUserSearchFilter: (memberOf=cn=ocp-users,cn=groups,cn=accounts,dc=example,dc=com)/customUserSearchFilter: $LDAP_FILTER/;
     s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ; \
     s/name: operator-instance-example/name: $OPERATOR_INSTANCE/ ; \
     s/usersDn: cn=groups,cn=accounts,dc=example,dc=com/usersDn: $USERS_DN/ ;
     /^\W*#/d ;
     s/dc=example,\W*dc=com/$LDAP_BASE/ \
    " $MANIFEST

cat << EOF
#
# to apply manifest run with (permissions reured):
# $BASH_SOURCE | oc apply -f -
#
EOF
