#!/bin/bash

function error() {
    echo -e $*
    exit 1
}

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)
TEMPLATES=_templates

CA=${1}

[ -z "$CA" ] && error "SYNTAX:\n  $BASH_SOURCE <CA>"

[ -e "$CA" ] && error "Directory '$CA' already exists" 

mkdir -p $base/$CA/{certs,crl,csr,newcerts,private}

touch $base/$CA/index.txt
echo 1000 > $base/$CA/serial
echo 1000 > $base/$CA/crlnumber

# It can be set to several values default which is also the 'default' option uses
# PrintableStrings, T61Strings and BMPStrings if the pkix value is used then only
# PrintableStrings and BMPStrings will be used. This follows the PKIX recommendation
# in RFC2459. If the utf8only option is used then only UTF8Strings will be used:
# this is the PKIX recommendation in RFC2459 after 2003. Finally the nombstr option
# just uses PrintableStrings and T61Strings: certain software has problems with
# BMPStrings and UTF8Strings: in particular Netscape.
STRING_MASK=${STRING_MASK:-default}

if [ "$CA" = "ROOT" ] ; then
    CA_HOSTNAME=${CA_HOSTNAME:-antarctica-post.aq}
    COPY_EXT=${COPY_EXTENSIONS:-none}
    DEFAULT_DAYS=${DEFAULT_DAYS:-3650}
    # can have up to 3 subordinates
    PATHLEN=${PATHLEN:-3}
    POLICY=${POLICY:-policy_strict}
    V3_EXT = "v3_ca"
else
    CA_HOSTNAME=${CA_HOSTNAME:-$CA}
    COPY_EXT=${COPY_EXTENSIONS:-copy}
    DEFAULT_DAYS=${DEFAULT_DAYS:-1095}
    # sing node certificates only
    PATHLEN=${PATHLEN:-0}
    POLICY=${POLICY:-policy_loose}
    V3_EXT = "v3_intermediate_ca"
fi

COUNTRY=${COUNTRY:-AQ}
EMAIL=${EMAIL:-ca@$CA_HOSTNAME}
LOCALITY=${LOCALITY:-Akademiya}
ORG=${ORGANIZATION:-"International Post"}
ORG_UNIT=${ORGANIZATIONAL_UNIT:-"Antarctica Post"}
STATE=${STATE:-Livingston}

sed "\
    s/__CA__/$CA/ ; \
    s/__COUNTRY__/$COUNTRY/ ; \
    s/__EMAIL__/$EMAIL/ ; \
    s/__LOCALITY__/$LOCALITY/ ; \
    s/__ORG_UNIT__/$ORG_UNIT/ ; \
    s/__ORGANIZATION__/$ORG/ ; \
    s/__STATE__/$STATE/ ;\
    s/example\.com/$CA_HOSTNAME/g ; \
    s/pathlen:[^,]\+/pathlen:$PATHLEN/ ;\
    s|\(dir_openssl_conf\W*=\).*|\1 $base/$CA| ; \
    s/\(default_days\W*=\).*/\1 $DEFAULT_DAYS/ ; \
    s/\(copy_extensions\W*=\).*/\1 $COPY_EXT/ ; \
    s/\(policy\W*=\).*/\1 $POLICY/ ; \
    s/\(string_mask\W*=\).*/\1 $STRING_MASK/ ; \
    s/\(x509_extensions\W*=\).*/\1 $V3_EXT/ ; \
    " $base/$TEMPLATES/openssl-template.cnf \
    > $base/$CA/openssl.cnf

echo "New CA '$CA' directory initialized:"
echo
echo "            Country: $COUNTRY"
echo "              State: $STATE"
echo "           Locality: $LOCALITY"
echo "       Organization: $ORG"
echo "Organizational Unit: $ORG_UNIT"
echo "        CA hostname: $CA_HOSTNAME"
echo "             E-Mail: $EMAIL"
echo
echo "And other parameters:"
echo "Default_days: $DEFAULT_DAYS"
echo "Policy: $POLICY"
echo "Copy_excensions: $COPY_EXT"
echo "Pathlen: $PATHLEN"
