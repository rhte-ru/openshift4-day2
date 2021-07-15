#!/bin/bash

export NS=openshift-config
export INGRESS_SECRET=${API_SECRET:-api-custom-cert}

exec bash $(dirname $BASH_SOURCE)/230-load-custom-ingress-cert.sh $*
