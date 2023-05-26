#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

NS=${NS:-namespace-example}

for r in $(oc -n $NS get LocalVolumeDiscoveryResult -o jsonpath='{..metadata.name}{"\n"}') ; do
    oc -n $NS get LocalVolumeDiscoveryResult $r \
	-o yaml
#	-o jsonpath='{ .status.discoveredDevices[?(@.status.state == "Available")] } {"\n"}'
done
