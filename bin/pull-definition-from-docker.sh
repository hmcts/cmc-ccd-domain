#!/bin/bash
set -e

ENV="${1:-local}"
VERSION="${2:-latest}"

case ${ENV} in
  local)
    CLAIM_STORE_URL="http://claim-store-api:4400" # docker-compose service
  ;;
  saat|sprod|aat|ithc|prod|demo)
    CLAIM_STORE_URL="http://cmc-claim-store-${ENV}.service.core-compute-${ENV}.internal"
  ;;
  *)
    echo "$ENV not recognised"
    exit 1 ;;
esac

root_dir=$(realpath $(dirname ${0})/..)/definition
echo ${root_dir}
config_dir=${root_dir}/data/sheets
definition_output_file=${root_dir}/xlsx/cmc-ccd-${ENV}.xlsx

if [[ ! -e ${definition_output_file} ]]; then
   touch ${definition_output_file}
fi

echo "Generating definition file..."
docker run --rm --name json2xlsx \
  -v ${config_dir}:/tmp/definition \
  -v ${definition_output_file}:/tmp/definition.xlsx \
  -e "CCD_DEF_CLAIM_STORE_BASE_URL=${CLAIM_STORE_URL}" \
  hmctspublic.azurecr.io/ccd/definition-processor:${VERSION} \
  json2xlsx -D /tmp/definition -o /tmp/definition.xlsx
