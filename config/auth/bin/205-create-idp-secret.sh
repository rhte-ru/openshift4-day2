#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

IDP_CLIENT_SECRET=${IDP_CLIENT_SECRET:-idp-secret-example}
IDP_CLIENT_PASSWORD=${IDP_CLIENT_PASSWORD:-$1}

oc -n openshift-config create secret generic \
    $IDP_CLIENT_SECRET \
    --from-literal=bindPassword="$IDP_CLIENT_PASSWORD" \
    --from-literal=clientSecret="$IDP_CLIENT_PASSWORD"
