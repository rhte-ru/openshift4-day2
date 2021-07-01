#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

CN=${1}

[ -z "$CA" -o -z "$CN" ] && error "SYNTAX:\n    <CA=CA_NAME> $BASH_SOURCE <CN> [openssl_args...]"

[ -r "$base/$CA/certs/${CN}.crt.pem" ] || error "Certificate for '$CN'"

KEY_FILE=$base/$CA/private/${CN}.key.pem
[ -r "$KEY_FILE" ] && KEY="-inkey $KEY_FILE" || KEY="-nokeys"

shift
ARGS=$*

openssl pkcs12 \
    -export \
    -certfile $base/$CA/certs/${CA}.crt.pem \
    -name $CN \
    -in $base/$CA/certs/${CN}.crt.pem \
    $KEY \
    $ARGS \
    -out $base/${CN}.p12
