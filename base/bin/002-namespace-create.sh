#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

LABEL_KEY=${LABEL_KEY:-label.name}
LABEL_VALUE=${LABEL_VALUE:-label-value}
MANIFEST=${1:-${base}/manifest/namespace-example.yaml}
NS=${NS:-namespace-example}

sed "s/name: namespace-example/name: $NS/ ; s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ;" $MANIFEST

cat << EOF
#
# to apply manifest run with (permissions required):
# $BASH_SOURCE | oc apply -f -
#
EOF