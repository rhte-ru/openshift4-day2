#!/bin/bash

MASTERS=$(oc get nodes -l node-role.kubernetes.io/master -o jsonpath="{ ..metadata.name }")

for m in $MASTERS ; do
    oc debug node/$m -- bash -c '\
	set -e ; \
	export BACKUP_DIR=/home/core/assets/backup ; \
	chroot /host /usr/local/bin/cluster-backup.sh $BACKUP_DIR ; \
	find /host$BACKUP_DIR -name "*.db" -exec gzip {} \; ; \
	echo "-------- $BACKUP_DIR ----------" ; \
	ls -l /host$BACKUP_DIR ;
	' \
    && { echo "Cluster backup at $m node was successful, exiting..." ; exit 0 ; }
done
