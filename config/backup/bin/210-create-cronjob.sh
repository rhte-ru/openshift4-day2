#!/bin/bash

set -e

base=$(realpath -e $(dirname $BASH_SOURCE)/..)

BASE_IMAGE=${BASE_IMAGE}
BACKUP_DIR=${BACKUP_DIR:-/home/core/assets/backup}
JOB_NAME=${JOB_NAME:-cluster-backup}
SA=${SERVICE_ACCOUNT:-cluster-backup}
SCHEDULE=${SHEDULE:-"00 15 * * *"}

export LABEL_KEY=${LABEL_KEY:-openshift.day2}
export LABEL_VALUE=${LABEL_VALUE:-admin-tasks}
export NS=${NS:-openshift-day2}

oc get ns $NS > /dev/null ||
    bash $(realpath -e $base/../../base/bin/002-namespace-create.sh) | oc apply -f -

if [ -z "$BASE_IMAGE" ] ; then
    OC_VERSION=$(oc version | awk -F: '/Server Version/ { print $2; }' | tr -d '[[:space:]]')
    BASE_IMAGE=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OC_VERSION/release.txt | \
	awk '/cli\W+quay/ { print $2; }')
fi

oc -n $NS get sa $SA > /dev/null || \
    oc -n $NS create sa $SA

R=$(oc -n $NS get rolebinding -o jsonpath="\
    {.items[?(@.roleRef.name == 'system:openshift:scc:privileged')].subjects[?(@.name == '$SA')].name}\
    ")
[ -z "$R" ] && oc adm policy add-scc-to-user privileged -n $NS -z $SA

exit

oc -n $NS delete cronjob $JOB_NAME || true
oc -n $NS create cronjob $JOB_NAME --image=$BASE_IMAGE --schedule="$SCHEDULE" \
    -- \
	/bin/bash \
	    -c \
		'set -e ; \
		chroot /host /usr/local/bin/cluster-backup.sh $BACKUP_DIR ; \
		find /host$BACKUP_DIR -name "*.db" -exec gzip {} \; ; \
		echo "-------- $BACKUP_DIR ----------" ; \
		ls -l /host$BACKUP_DIR ; \
		'

oc -n $NS set env cronjob/$JOB_NAME BACKUP_DIR=$BACKUP_DIR
oc -n $NS set volume cronjob/$JOB_NAME --name=host-root --add -m /host --path=/ -t hostPath
oc -n $NS patch cronjob/$JOB_NAME -p '{
    "spec": {
	"jobTemplate": {
	    "spec": {
		"template": {
		    "spec": {
			"serviceAccountName": "cluster-backup",
			"containers": [{
			    "name": "cluster-backup",
			    "securityContext": {
				"privileged": true
			    }
			}]
		    }
		}
	    }
	}
    }
}'

