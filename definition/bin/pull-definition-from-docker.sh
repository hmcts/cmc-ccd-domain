#!/bin/bash
set -e

VERSION="${1:-}"

[ "_${VERSION}" = "_" ] && echo "No VERSION (Docker tag) defined. Script terminated." && exit 1

echo "Logging into ACR..."
az acr login --name hmcts --subscription 1c4f0704-a29e-403d-b719-b90c34ef14c9

echo "Pulling definition version: ${VERSION}..."
docker pull hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:${VERSION}

echo "Generating definition file..."
docker run --rm --name json2xlsx \
  -v $(pwd)/definition/releases:/tmp \
  hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:${VERSION} \
  sh -c "cd /opt/ccd-definition-processor && yarn json2xlsx -D /data/sheets -o /tmp/cmc-ccd.xlsx && yarn cache clean"

echo "Versioning definition file..."
mv ./definition/releases/cmc-ccd.xlsx ./definition/releases/cmc-ccd-v${VERSION}.xlsx 

echo "Saved: ./definition/releases/cmc-ccd-v${VERSION}.xlsx"