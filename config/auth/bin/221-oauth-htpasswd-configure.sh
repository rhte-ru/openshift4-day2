#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)
MANIFEST=${1:-${base}/manifest/oauth-htpasswd-example.yaml}

CLIENT_NAME=${CLIENT_NAME:-idp-clientid-example}
IDP_CLIENT_SECRET=${IDP_CLIENT_SECRET:-idp-secret-example}

sed "
    s/- name: idp-hatpasswd-example/- name: $CLIENT_NAME/ ;
    s/name: idp-secret-example/name: $IDP_CLIENT_SECRET/ ;
    " $MANIFEST

cat << EOF
#
# do NOT APPLY this configuration, just MERGE
#
EOF

