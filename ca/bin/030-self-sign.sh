#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

[ -z "$CA" ] && error "SYNTAX:\n  <CA=CA_NAME> $BASH_SOURCE"

CERT=$base/$CA/certs/${CA}.crt.pem

[ -r "$CERT" ] && {
    error "$CERT already exists at '$CA', use $base/bin/130-renew-cert.sh"
}

# since req ignores default_days it must be passed by args
days=$(awk -F= '/default_days/ { gsub(/\W+/, "", $2); print $2; }' $base/$CA/openssl.cnf)
openssl req -config $base/$CA/openssl.cnf \
    -days $days \
    -extensions v3_ca \
    -new \
    -sha384 \
    -x509 \
    -key $base/$CA/private/${CA}.key.pem \
    -out $CERT

cp $CERT $base/$CA/certs/ca-bundle.pem
