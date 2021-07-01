#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}
FILE=$1

function clean() {
    [ -e "$TMP_KEY" ] && rm -f $TMP_KEY
}

trap clean exit

[ -z "$CA" -o -z "$FILE" ] && error "SYNTAX:\n  <CA=CA_NAME> $BASH_SOURCE <FILE> [openssl_args...]"

[ -r "$FILE" ] || error "Request '$FILE' not found at '$CA'"

TMP_KEY=$(mktemp)

openssl req -text -noout -in $FILE -out $TMP_KEY
grep -q '\W\+CA:TRUE' $TMP_KEY && EXT="-extensions v3_intermediate_ca"

    # -days 3600 \
    # -md sha384 \
openssl ca \
    -config $base/$CA/openssl.cnf \
    $EXT \
    -in $FILE \
    -out $base/$CA/certs/$(basename $FILE | sed s'/\.csr$/.crt.pem/')
