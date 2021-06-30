#!/bin/bash

set -e

if [ -z "$1" ] ; then
    echo "SYNTAX: $BASH_SOURCE [path/to/]ca-bundle.pem"
    exit 1
fi

TRUSTED_CA_CM=${TRUSTED_CA_CM:-user-ca-bundle}
oc -n openshift-config create cm $TRUSTED_CA_CM --from-file=ca-bundle.crt=${1}
