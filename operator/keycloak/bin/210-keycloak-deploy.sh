#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

LABEL_KEY=${LABEL_KEY:-label.name}
LABEL_VALUE=${LABEL_VALUE:-label-value}
MANIFEST=${1:-${base}/manifest/keycloak-example.yaml}
NS=${NS:-namespace-example}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-keycloak-instance-example}

sed "s/namespace: namespace-example/namespace: $NS/ ; \
     s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ; \
     s/name: keycloak-instance-example/name: $OPERATOR_INSTANCE/" $MANIFEST

cat << EOF
#
# to apply manifest run with (permissions reured):
# $BASH_SOURCE | oc apply -f -
#
EOF
