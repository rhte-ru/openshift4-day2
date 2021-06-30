#!/bin/bash

set -e

NS=${NS:-namespace-example}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-keycloak-instance-example}

echo -n "Keycloak ${OPERATOR_INSTANCE} ready: " ; oc -n $NS get keycloak ${OPERATOR_INSTANCE} -o jsonpath='{ .status.ready } {"\n"}'