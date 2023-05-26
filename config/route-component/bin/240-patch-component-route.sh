#!/bin/bash

set -e

DRY_RUN=${DRY_RUN:-client}
COMPONENT_NAME=${COMPONENT_NAME:-$1}
#COMPONENT_NAMESPACE=${COMPONENT_NAMESPACE:-openshift-${COMPONENT_NAME}}
COMPONENT_HOSTNAME=${COMPONENT_HOSTNAME:-$2}
COMPONENT_SECRET_NAME=${CUSTOM_SECRET:-custom-cert}

case $COMPONENT_NAME in
    oauth-openshift)
	COMPONENT_NAMESPACE=openshift-authentication
	;;
    console)
	COMPONENT_NAMESPACE=openshift-${COMPONENT_NAME}
	;;
    *)
	echo "SYNTAX: $BASH_SOURCE <oauth-openshift|console> <hostname>"
	exit 1
	;;
esac

OP_COMPONENT_ROUTES_ELEMENT="
	\"op\": \"add\",
	\"path\": \"/spec\",
	\"value\": { \"componentRoutes\": [] }
	},{"
cre=$(oc get ingress.config cluster -o jsonpath={.spec.componentRoutes})

shift 2

oc patch --dry-run=$DRY_RUN --type=json ingress.config/cluster \
    -p "[{ $( [ -z "$cre" ] && echo $OP_COMPONENT_ROUTES_ELEMENT )
	\"op\": \"add\",
	\"path\": \"/spec/componentRoutes/-\",
	\"value\": { 
	    \"name\": \"${COMPONENT_NAME}\", 
	    \"namespace\": \"${COMPONENT_NAMESPACE}\", 
	    \"hostname\": \"${COMPONENT_HOSTNAME}\", 
	    \"servingCertKeyPairSecret\": {
		\"name\": \"$COMPONENT_SECRET_NAME\" 
	    } 
	}
    }]" \
    $*
