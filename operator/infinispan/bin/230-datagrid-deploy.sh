#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

DATAGRID_EXPOSE=${DATAGRID_EXPOSE:-LoadBalancer}
DATAGRID_EXPOSE_HOST=${DATAGRID_EXPOSE_HOST}
DATAGRID_KIND=${DATAGRID_KIND:-Cache}
MANIFEST=${1:-${base}/manifest/datagrid-minimal.yaml}
NS=${NS:-example-datagrid-instance}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-datagrid-example}
REPLICAS=${REPLICAS:-1}

function update_route() {
  if [ "$DATAGRID_EXPOSE_HOST" != "" -a "$DATAGRID_EXPOSE" = "Route" ] ; then
	  sed "s/#\W\+host: .*/    host: $DATAGRID_EXPOSE_HOST/ ; "
  else 
	  cat
  fi
}

sed "s/: example-datagrid-instance/: $NS/ ; \
     s/: example-infinispan/: $OPERATOR_INSTANCE/ ; \
     s/replicas: 1/replicas: $REPLICAS/i ; \
     s/type: Cache/type: $DATAGRID_KIND/ ; \
     s/type: LoadBalancer/type: $DATAGRID_EXPOSE/ ;
    " $MANIFEST | update_route

cat << EOF
#
# to apply manifest run with:
# $BASH_SOURCE | oc apply -f -
#
EOF

