#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

IDP_CA_CHAIN_CM=${IDP_CA_CHAIN_CM:-idp-ca-example}

if [ -z "$1" ] ; then
    echo "SYNTAX: $BASH_SOURCE [path/to/]ca-bundle.pem"
    exit 1
fi

oc -n openshift-config create cm $IDP_CA_CHAIN_CM --from-file=ca.crt=$1
