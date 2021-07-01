#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

FILE=${1}
shift

[ -z "$FILE" ] && error "SYNTAX:\n    $BASH_SOURCE <p12_bundle>"

openssl pkcs12 -info -in $FILE $*
