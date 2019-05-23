#!/bin/sh
## Add user role in ccd
##
## Usage: ./add-ccd-role.sh role [classification] [userToken] [env]
##
## Options:
##    - role: Name of the role. Must be an existing IDAM role.
##    - classification: Classification granted to the role; one of `PUBLIC`,
##        `PRIVATE` or `RESTRICTED`. Default to `PUBLIC`.
##
## Add support for an IDAM role in CCD.

role=$1
classification=$2
userToken=$3
env=$4

if [ -z "$role" ]
  then
    echo "Usage: ./add-ccd-role.sh role [classification] [userToken] [env]"
    exit 1
fi

case $classification in
  PUBLIC|PRIVATE|RESTRICTED)
    ;;
  *)
    echo "Classification must be one of: PUBLIC, PRIVATE or RESTRICTED"
    exit 1 ;;
esac

curl -k ${CURL_OPTS} -XPUT \
  https://ccd-api-gateway-web-${env}.service.core-compute-${env}.internal/definition_import/api/user-role \
  -H "Authorization: Bearer ${userToken}" \
  -H "Content-Type: application/json" \
  -d '{"role":"'${role}'","security_classification":"'${classification}'"}'
