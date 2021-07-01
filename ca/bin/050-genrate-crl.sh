#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

[ -z "$CA" ] && error "SYNTAX:\n  <CA=CA_NAME> $BASH_SOURCE"

openssl ca \
    -config $base/$CA/openssl.cnf \
    -gencrl \
    -out $base/$CA/crl/${CA}.crl.pem
