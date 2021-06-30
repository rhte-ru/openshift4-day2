#!/bin/bash

set -e

trap clean exit

function clean() {
  rm -f $TMP_FILE
}

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

DRY_RUN=${DRY_RUN:-true}
MANIFEST=${1:-${base}/manifest/identities.yaml}
NS=${NS:-example-datagrid-instance}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-datagrid-example}
USER_NAME=${USER_NAME:-developer}
USER_PASSWORD=${USER_PASSWORD:-$(openssl rand -base64 10)}

TMP_FILE=$(mktemp)

sed "s/- username:.*/- username: $USER_NAME/ ; s,  password:.*,  password: $USER_PASSWORD, ; /^#.*$/d" $MANIFEST > $TMP_FILE
cat $TMP_FILE
echo "###"

oc -n $NS create secret generic ${OPERATOR_INSTANCE}-identities --dry-run=$DRY_RUN \
	--from-file=identities.yaml=$TMP_FILE

