#!/bin/bash

set -e

DRY_RUN=${DRY_RUN:-client}

API_FQDN=${API_FQDN:-$(oc whoami --show-server | sed 's|[^/]\+//|| ; s|:[^:]\+$||')}
API_SECRET=${API_SECRET:-api-custom-cert}

oc patch apiserver cluster \
    --dry-run=${DRY_RUN} \
    --type=merge -p \
    "{ \"spec\":
	{ \"servingCerts\": {
	    \"namedCertificates\": [ {
		\"names\": [ \"$API_FQDN\" ],
		\"servingCertificate\": { \"name\": \"$API_SECRET\" }
	    } ]
	}}
    }"
