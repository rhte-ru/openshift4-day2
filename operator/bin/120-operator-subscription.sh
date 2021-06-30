#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

LABEL_KEY=${LABEL_KEY:-label.name}
LABEL_VALUE=${LABEL_VALUE:-label-value}
MANIFEST=${1:-${base}/manifest/operator-subscription.yaml}
NS=${NS:-namespace-example}

OPERAROR_APPROVAL=${OPERAROR_APPROVAL:-Automatic}
OPERATOR_CHANNEL=${OPERATOR_CHANNEL:-channel-name}
OPERATOR_INSTANCE=${OPERATOR_INSTANCE:-operator-example-instance}
OPERATOR_NAME=${OPERATOR_NAME:-operator-example}
OPERATOR_SOURCECATALOG=${OPERATOR_SOURCECATALOG:-redhat-operators}
SUBSCRIPTION_NAME=${SUBSCRIPTION_NAME:-name-operator}

sed "s/: namespace-example/: $NS/ ; \
     s/channel: channel-name/channel: ${OPERATOR_CHANNEL}/ ; \
     s/installPlanApproval: Automatic/installPlanApproval: $OPERAROR_APPROVAL/ ; \
     s/label.name: label-example/$LABEL_KEY: $LABEL_VALUE/ ; \
     s/name: operator-example/name: $SUBSCRIPTION_NAME/ ; \
     s/name: name-operator/name: $SUBSCRIPTION_NAME/ ; \
     s/source: redhat-operators/source: ${OPERATOR_SOURCECATALOG}/ ; \
     " $MANIFEST

cat << EOF
#
# to apply manifest run with:
# $BASH_SOURCE | oc apply -f -
#
EOF
