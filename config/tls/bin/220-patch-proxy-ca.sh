#!/bin/bash

set -e

DRY_RUN=${DRY_RUN:-true}
TRUSTED_CA_CM=${TRUSTED_CA_CM:-user-ca-bundle}

oc patch --dry-run=$DRY_RUN --type merge proxy/cluster -p "{ \"spec\": { \"trustedCA\": { \"name\": \"$TRUSTED_CA_CM\" } } }" 
