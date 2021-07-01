#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

CN=${1}

[ -z "$CA" -o -z "$CN" ] && error "SYNTAX:\n    <CA=CA_NAME> $BASH_SOURCE <CN>"

[ -r "$base/$CA/certs/${CN}.crt.pem" ] || error "Certificate for '$CN'"

KEY_FILE=$base/$CA/private/${CN}.key.pem
[ -r "$KEY_FILE" ] && KEY="-keyin $KEY_FILE" || KEY="-nokeys"

openssl pkcs12 \
    -export \
    -certfile $base/$CA/certs/${CA}.crt.pem \
    -name $CN \
    -in $base/$CA/certs/${CN}.crt.pem \
    $KEY \
    -out $base/${CN}.p12