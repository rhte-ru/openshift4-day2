```
export OPERATOR_NAME=local-storage
export NS=openshift-local-storage

export LABEL_KEY=operator.name
export LABEL_VALUE=$OPERATOR_NAME

bash ../../base/bin/002-namespace-create.sh | oc apply -f -

bash ../bin/110-operatorgroup-create.sh | oc apply -f -

export OPERATOR_CHANNEL=$(\
    oc version | awk -F: '/Server Version/ { print $2; }' | sed 's/^\W\+/"/ ; s/+\W\+$// ; s/\.[0-9]\+$/"/')
export OPERATOR_INSTANCE=$OPERATOR_NAME
export SUBSCRIPTION_NAME=${OPERATOR_NAME}-operator

bash ../bin/120-operator-subscription.sh | oc apply -f -


```
