#!/bin/bash

set -e

NS=${NS:-namespace-example}
OPERATOR_NAME=${OPERATOR_NAME:-operator-example}

# ClusterServiceVersion
for s in $(oc -n $NS get csv -o jsonpath='{ ..metadata.name }') ; do 
    echo $s | grep -q ${OPERATOR_NAME} && { echo -n "$s status: " ; oc -n $NS get csv $s -o jsonpath='{ .status.phase }' ; }
done
