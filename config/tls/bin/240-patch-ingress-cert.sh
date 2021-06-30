#!/bin/bash

set -e

DRY_RUN=${DRY_RUN:-true}
INGRESS_SECRET=${INGRESS_SECRET:-ingress-custom-cert}

oc -n openshift-ingress-operator patch --dry-run=$DRY_RUN --type=merge ingresscontroller/default \
    -p "{ \"spec\": { \"defaultCertificate\": { \"name\": \"$INGRESS_SECRET\"} } }"
