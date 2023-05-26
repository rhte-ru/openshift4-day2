#!/bin/bash

set -e

if [ -z "$1" ] ; then
    echo "SYNTAX: $BASH_SOURCE <htpasswd_file_name>"
    exit 1
fi

IDP_CLIENT_SECRET=${IDP_CLIENT_SECRET:-idp-secret-example}

oc -n openshift-config create secret generic \
    $IDP_CLIENT_SECRET \
    --from-file=htpasswd="$1"
