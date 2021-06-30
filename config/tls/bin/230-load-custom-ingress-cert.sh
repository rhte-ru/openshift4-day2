#!/bin/bash

set -e

if [ -z "$1" -o -z "$2" ] ; then
    echo "SYNTAX: $BASH_SOURCE [path/to/]cert-chain.pem [path/to/]key.pem "
    exit 1
fi

DRY_RUN=${DRY_RUN:-true}
INGRESS_SECRET=${INGRESS_SECRET:-ingress-custom-cert}

 oc -n openshift-ingress create --dry-run=$DRY_RUN secret tls $INGRESS_SECRET \
     --cert=$1 --key=$2
