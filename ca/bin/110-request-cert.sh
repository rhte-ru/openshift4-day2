#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

CA=${CA}

CN=${1:-$CA}

[ -z "$CA" ] && error "SYNTAX:\n    <CA=CA_NAME> $BASH_SOURCE <CN> [alt_names...]"

function clean() {
    [ -e "$TMP_KEY" ] && rm -f $TMP_KEY
}

trap clean exit

function parse_subj() {
    country=$(awk -F= '/^countryName_default/ { print $2 ;}' $base/$CA/openssl.cnf | sed 's/\W*// ; s/ /\\ /g')
    state=$(awk -F= '/^stateOrProvinceName_default/ { print $2 ;}' $base/$CA/openssl.cnf | sed 's/\W*// ; s/ /\\ /g')
    loc=$(awk -F= '/^localityName_default/ { print $2 ;}' $base/$CA/openssl.cnf | sed 's/\W*// ; s/ /\\ /g')
    org=$(awk -F= '/^organizationName_default/ { print $2 ;}' $base/$CA/openssl.cnf | sed 's/\W*// ; s/ //g')
    org_unit=$(awk -F= '/^organizationalUnitName_default/ { print $2 ;}' $base/$CA/openssl.cnf | sed 's/\W*// ; s/ //g')
    echo "/C=$country/ST=$state/L=$loc/O=$org/OU=$org_unit/CN=$CN/"
}

if [ -z "$1" ] ; then
    EXT="-reqexts v3_req"
else
    set +e
    for e in $* ; do
        echo $e | grep -q '\([0-9\+\.]\)\{3\}'
        if [ "$?" = "0" ] ; then
            ALT_NAMES="${ALT_NAMES} IP:${e}"
        else
            echo $e | grep -q @
            if [ "$?" = "0" ] ; then
                ALT_NAMES="${ALT_NAMES} email:${e}"
            else
                ALT_NAMES="${ALT_NAMES} DNS:${e}"
            fi
        fi
    done
    set -e
    export SAN=$(echo $ALT_NAMES | sed 's/ /,/g' | sed 's/^,//')
    # SUBJ="-subj '$(parse_subj)'"
    EXT="-reqexts SAN"
fi

KEY_FILE=$base/$CA/private/${CN}.key.pem
[ -r "$KEY_FILE" ] || error "$KEY_FILE does not exist, run $bas/bin/010-new-key.sh first"

TMP_KEY=$(mktemp)
cat $base/$CA/openssl.cnf >> $TMP_KEY
[ -z "$SAN" ] || printf "[SAN]\nsubjectAltName=$SAN" >> $TMP_KEY

    # -config <(cat $base/$CA/openssl.cnf $( [ -z "$SAN" ] || <(printf "[SAN]\nsubjectAltName=$SAN"))) \
    # -config $base/$CA/openssl.cnf \

openssl req \
    -config $TMP_KEY \
    -new \
    $EXT \
    $SUBJ \
    -key $KEY_FILE \
    -out $base/$CA/csr/${CN}.csr
