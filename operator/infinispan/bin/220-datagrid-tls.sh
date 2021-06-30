#!/bin/bash

set -e

trap clean exit

function clean() {
  rm -f $TMP_FILE
}

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

DRY_RUN=${DRY_RUN:-true}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-datagrid-example}
NS=${NS:-example-datagrid-instance}
P12_KEY_ALIAS=${KEY_ALIAS:-datagrid}
P12_KEYSTORE=${1:-${base}/cert/datagrid.pfx}
P12_KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-changeme}

oc -n $NS create secret generic ${OPERATOR_INSTANCE}-tls --dry-run=$DRY_RUN \
	--from-literal=alias=${P12_KEY_ALIAS} \
	--from-literal=password=${P12_KEYSTORE_PASSWORD} \
	--from-file=keystore.p12=$P12_KEYSTORE
