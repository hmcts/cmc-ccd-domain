#!/bin/sh
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

if [[ ${1} = "-v" ]]; then
  export CURL_OPTS='-v'
  shift
else
  export CURL_OPTS='--fail --silent'
fi

if [ -z "${1}" ]
  then
    echo "Usage: ./upload-definition.sh [env]\n${ENV_MESSAGE}"
    exit 1
fi

require az "On mac run \`brew install azure-cli\`"
require python3 "On mac run \`brew install python3\`"
require jq "On mac run \`brew install jq\`"

env=${1}

case ${env} in
  saat)
    IDAM_URI="http://idam-api-idam-saat.service.core-compute-idam-saat.internal"
    IDAM_ENV="test"
  ;;
  sprod)
    IDAM_URI="http://idam-api-idam-sprod.service.core-compute-idam-sprod.internal"
    IDAM_ENV="test"
  ;;
  aat)
    IDAM_URI="https://idam-api.aat.platform.hmcts.net"
    IDAM_ENV="preprod"
  ;;
  demo)
    IDAM_URI="https://idam-api.demo.platform.hmcts.net"
    IDAM_ENV="demo"
  ;;
  prod)
    IDAM_URI="https://prod-idamapi.reform.hmcts.net:3511"
    IDAM_ENV="prod"
  ;;
  *)
    echo ${ENV_MESSAGE}
    exit 1 ;;
esac

export CLAIM_STORE_BASE_URL=http://cmc-claim-store-${env}.service.core-compute-${env}.internal

function keyVaultRead() {
  az keyvault secret show --vault-name cmc-vault --name ${1} --query value -o tsv
}

echo "Reading importer credentials from vault for idam env: ${IDAM_ENV}"

az account show &> /dev/null || {
    logError "Please run \`az login\` and follow the instructions first"
    exit 1
}

IMPORTER_USERNAME=$(keyVaultRead "ccd-importer-username-${IDAM_ENV}")
IMPORTER_PASSWORD=$(keyVaultRead "ccd-importer-password-${IDAM_ENV}")
CLIENT_SECRET=$(keyVaultRead "oauth-client-secret-${IDAM_ENV}")
REDIRECT_URI=$(keyVaultRead "oauth-redirect-uri-${IDAM_ENV}")

proxy=http://proxyout.reform.hmcts.net:8080
export http_proxy=${proxy}
export https_proxy=${proxy}

echo "Authenticating to idam"
userToken=$(./bin/idam-authenticate.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD} ${IDAM_URI} ${REDIRECT_URI} ${CLIENT_SECRET})

echo "Adding CMC required roles to CCD"

# add ccd role
./bin/add-ccd-role.sh "caseworker-cmc" "RESTRICTED" "${userToken}" "${env}"
./bin/add-ccd-role.sh "caseworker-cmc-solicitor" "RESTRICTED" "${userToken}" "${env}"
./bin/add-ccd-role.sh "citizen" "PUBLIC" "${userToken}" "${env}"
./bin/add-ccd-role.sh "letter-holder" "PUBLIC" "${userToken}" "${env}"
./bin/add-ccd-role.sh "caseworker-cmc-systemupdate" "RESTRICTED" "${userToken}" "${env}"

echo "Uploading CMC definition to CCD"
# upload definition file
./bin/import-definition.sh "./data/ccd-definition.xlsx" "${userToken}" "${env}"

# Add blank line to end
echo
