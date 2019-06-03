#!/bin/sh
## Import the given definition in CCD definition store.
##
## Usage: ./import-definition.sh path_to_definition [userToken] [env]
##
## Prerequisites:
##  - Microservice `ccd_gw` must be authorised to call service `ccd-definition-store-api`

if [ -z "$1" ]
  then
    echo "Usage: ./import-definition.sh path_to_definition [userToken] [env]"
    exit 1
elif [ ! -f "$1" ]
  then
    echo "File not found: $1"
    exit 1
fi

userToken=$2
env=$3

curl -vvv -k ${CURL_OPTS} \
  https://ccd-api-gateway-web-${env}.service.core-compute-${env}.internal/definition_import/import \
  -H "Authorization: Bearer ${userToken}" \
  -F file="@$1"
