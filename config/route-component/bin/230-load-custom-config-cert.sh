#!/bin/bash

set -e

if [ -z "$1" -o -z "$2" ] ; then
    echo "SYNTAX: $BASH_SOURCE [path/to/]cert-chain.pem [path/to/]key.pem "
    exit 1
fi

NS=${NS:-openshift-config}
DRY_RUN=${DRY_RUN:-client}
CUSTOM_SECRET=${CUSTOM_SECRET:-custom-cert}

 oc -n $NS create --dry-run=$DRY_RUN secret tls $CUSTOM_SECRET \
     --cert=$1 --key=$2
