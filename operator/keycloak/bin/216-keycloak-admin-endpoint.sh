#!/bin/bash

set -e

NS=${NS:-namespace-example}

oc -n $NS get route keycloak -o jsonpath='{ "https://" }{ .spec.host }{ "\n" }'