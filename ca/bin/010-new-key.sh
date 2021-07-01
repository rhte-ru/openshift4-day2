#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}
CN=$1

function clean() {
    [ -e "$TMP_KEY" ] && rm -f $TMP_KEY
}

trap clean exit

[ -z "$CA" ] && error "SYNTAX:\n  <CA=CA_NAME> $BASH_SOURCE <CN> [openssl_args...]"
[ -z "$CN" ] && CN=$CA

KEY_FILE=private/${CN}.key.pem

[ -e "$base/$CA/$KEY_FILE" ] && error "Key '$KEY_FILE' already exists at CA '$CA'\nRun $base/bin/020-info-key.sh $KEY_FILE"

if [ "$1" != "" ] ; then
    shift
    ARGS=$*
fi

SUITE_B_EP=${SUITE_B_EP:-secp384r1}
TMP_KEY=$(mktemp)
openssl ecparam -genkey -name $SUITE_B_EP -out $TMP_KEY ; openssl ec -aes256 $ARGS -out $base/$CA/$KEY_FILE -in $TMP_KEY
# openssl ecparam -genkey -name $SUITE_B_EP | openssl ec -aes256 -out $base/$CA/$KEY_FILE
