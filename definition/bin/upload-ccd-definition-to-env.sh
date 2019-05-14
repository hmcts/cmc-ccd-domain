#!/bin/sh
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

function require () {
  local command=${1}
  local installMessage=${2}
  hash ${command} 2>/dev/null || {
    logError "${command} is not installed. ${installMessage}. Aborting."
    exit 1
  }
}

function keyVaultRead() {
  az keyvault secret show --vault-name cmc-vault --name ${1} --query value -o tsv
}

if [[ ${1} = "-v" ]]; then
  export CURL_OPTS='-v'
  shift
else
  export CURL_OPTS='--fail --silent'
fi

if [ -z "${1}" ]
  then
    echo "Usage: ./upload-definition-to-env.docker.sh [env] [version]\n"
    exit 1
fi

require az "On mac run \`brew install azure-cli\`"
require python3 "On mac run \`brew install python3\`"
require jq "On mac run \`brew install jq\`"

echo "Reading importer credentials from vault for idam env: ${IDAM_ENV}"

az account show &> /dev/null || {
    echo "Please run \`az login\` and follow the instructions first"
    exit 1
}

ENV=${1}
VERSION=${2}

IDAM_URI="http://idam-api-idam-${ENV}.service.core-compute-idam-${ENV}.internal"
AUTH_PROVIDER_BASE_URL="http://rpe-service-auth-provider-${ENV}.service.core-compute-idam-${ENV}.internal"
CCD_DEF_BASE_URL="http://ccd-data-store-api-${ENV}.service.core-compute-idam-${ENV}.internal"
CCD_STORE_BASE_URL="http://ccd-data-store-api-${ENV}.service.core-compute-idam-${ENV}.internal"

case ${ENV} in
  local)
    IDAM_URI=http://host.docker.internal:5000
    IMPORTER_USERNAME=ccd-importer@server.net
    IMPORTER_PASSWORD=Password12
    CLIENT_SECRET=12345678
    REDIRECT_URI=https://localhost:3000/receiver
    CCD_STORE_BASE_URL=http://localhost:4451
    AUTH_PROVIDER_BASE_URL=http://host.docker.internal:4552
    CCD_DEF_BASE_URL=http://ccd-data-store-api:4452 # docker-compose service
  ;;
  saat)
  sprod)
    IMPORTER_USERNAME=$(keyVaultRead "ccd-importer-username-test")
    IMPORTER_PASSWORD=$(keyVaultRead "ccd-importer-password-test")
    CLIENT_SECRET=$(keyVaultRead "oauth-client-secret-test")
    REDIRECT_URI=$(keyVaultRead "oauth-redirect-uri-test")
  ;;
  aat)
    IDAM_URI="https://idam-api.aat.platform.hmcts.net"
    IMPORTER_USERNAME=$(keyVaultRead "ccd-importer-username-preprod")
    IMPORTER_PASSWORD=$(keyVaultRead "ccd-importer-password-preprod")
    CLIENT_SECRET=$(keyVaultRead "oauth-client-secret-preprod")
    REDIRECT_URI=$(keyVaultRead "oauth-redirect-uri-preprod")
  ;;
  demo)
    IDAM_URI="https://idam-api.demo.platform.hmcts.net"
    IMPORTER_USERNAME=$(keyVaultRead "ccd-importer-username-demo")
    IMPORTER_PASSWORD=$(keyVaultRead "ccd-importer-password-demo")
    CLIENT_SECRET=$(keyVaultRead "oauth-client-secret-demo")
    REDIRECT_URI=$(keyVaultRead "oauth-redirect-uri-demo")
  ;;
  prod)
    IDAM_URI="https://prod-idamapi.reform.hmcts.net:3511"
    IMPORTER_USERNAME=$(keyVaultRead "ccd-importer-username-prod")
    IMPORTER_PASSWORD=$(keyVaultRead "ccd-importer-password-prod")
    CLIENT_SECRET=$(keyVaultRead "oauth-client-secret-prod")
    REDIRECT_URI=$(keyVaultRead "oauth-redirect-uri-prod")
  ;;
  *)
    echo "$env not recognised"
    exit 1 ;;
esac

# proxy=http://proxyout.reform.hmcts.net:8080
# export http_proxy=${proxy}
# export https_proxy=${proxy}

echo "Importing: ${VERSION}"

docker run \
  --name ccd-importer-to-env \
  --rm `# cleanup after` \
  -e "VERBOSE=${VERBOSE:-false}" \
  -e "IMPORTER_USERNAME=${IMPORTER_USERNAME}" \
  -e "IMPORTER_PASSWORD=${IMPORTER_PASSWORD}" \
  -e "CCD_STORE_BASE_URL=${CCD_STORE_BASE_URL}" \
  -e "IDAM_URI=${IDAM_URI}" \
  -e "AUTH_PROVIDER_BASE_URL=${AUTH_PROVIDER_BASE_URL}" \
  -e "MICROSERVICE=ccd_gateway" \
  -e "REDIRECT_URI=${REDIRECT_URI}" \
  -e "CLIENT_ID=cmc_citizen" \
  -e "CLIENT_SECRET=12345678" \
  -e "CCD_DEF_FILENAME=cmc-ccd.xlsx" \
  -e "CCD_DEF_BASE_URL=${CCD_DEF_BASE_URL}" `# templated in definitions excel` \
  -e "USER_ROLES=citizen, caseworker-cmc, caseworker-cmc-solicitor, caseworker-cmc-systemupdate, letter-holder" \
  hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:${VERSION}

echo Finished
