#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

FILE=$1

[ -z "$CA" -o -z "$FILE" ] && error "SYNTAX:\n  <CA=CA_NAME> $BASH_SOURCE <FILE>"

[ -e "$FILE" ] || error "Certificate '$FILE' not found at CA '$CA'"

openssl verify \
    -CAfile $base/$CA/certs/ca-bundle.pem \
    -CRLfile $base/$CA/crl/${CA}.crl.pem \
    -crl_check \
    -show_chain \
    -verbose \
    $FILE
