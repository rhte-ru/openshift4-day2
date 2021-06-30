#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

MANIFEST=${1:-${base}/manifest/operatorgroup-example.yaml}
NS=${NS:-namespace-example}
OPERATORGROUP=${OPERATORGROUP:-$OPERATOR_NAME}
TNS=${TARGET_NS:-$NS}

oc -n $NS get operatorgroup -o name | grep -q operatorgroup && cat << EOF

# 
# !!!! The namespace '$NS' already has opeartorgroups !!!!
#

EOF

sed "s/\([:-]\) namespace-example/\1 $NS/ ; s/: operatorgroup-example/: $OPERATORGROUP/" $MANIFEST

cat << EOF
#
# to apply manifest run with (permissions reured):
# $BASH_SOURCE | oc apply -f -
#
EOF
