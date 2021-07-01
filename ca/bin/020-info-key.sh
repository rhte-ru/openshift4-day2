#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

ALG=$1
FILE=$2

[ -z "$ALG" -o -z "$FILE" ] && error "SYNTAX:\n  $BASH_SOURCE <ALG> <FILE>"

[ -e "$FILE" ] || error "KEY '$FILE' not found at CA '$CA'"

openssl $ALG -text -noout -in $FILE
