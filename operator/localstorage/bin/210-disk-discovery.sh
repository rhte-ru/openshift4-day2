#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

MANIFEST=${1:-${base}/manifest/local-volume-discovery.yaml}
NODE_FILTER=${NODE_FILTER:-node-role.kubernetes.io/worker=}
NS=${NS:-namespace-example}

NODES=$(oc get node -o jsonpath='{ ..metadata.labels.kubernetes\.io/hostname } {"\n"}' -l $NODE_FILTER | tr -d '[[:space:]]')

sed "s/namespace: namespace-example/namespace: $NS/ ; \
     s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ; \
     s/values:.*/values: [$(for n in $NODES ; do echo "\"${n}\"," ; done)]/ ; \
     /worker-0/d ;
     " $MANIFEST
#
# oc -n $NS get LocalVolumeDiscoveryResult discovery-result-sno-01 -o jsonpath='{ .spec.nodeName }{":"} { .status.discoveredDevices[?(@.status.state == "Available")].deviceID}'
#