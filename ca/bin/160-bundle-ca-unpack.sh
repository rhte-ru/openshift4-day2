#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

FILE=${1}

[ -z "$CA" -o -z "$FILE" ] && error "SYNTAX:\n    <CA=CA_NAME> $BASH_SOURCE <p12_bundle>"

openssl pkcs12 \
    -in $FILE \
    -cacerts \
    -out $base/$CA/certs/ca-bundle.pem
cp $base/$CA/certs/{ca-bundle,${CA}.crt}.pem
