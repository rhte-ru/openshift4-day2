#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

FILE=$1

[ -z "$FILE" ] && error "SYNTAX:\n  $BASH_SOURCE <FILE>"

[ -e "$FILE" ] || error "Certificate '$FILE' not found at CA '$CA'"

openssl x509 -text -noout -in $FILE
