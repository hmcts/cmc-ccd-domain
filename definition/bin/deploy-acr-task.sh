#!/bin/bash
set -e

az account set --subscription DCD-CNP-DEV
az acr task create \
    --registry hmcts \
    --name task-cmc-ccd-definition-importer \
    --file ./definition/acr-build-task.yaml \
    --context https://github.com/hmcts/cmc-ccd-domain.git \
    --branch master \
    --values ./definition/VERSION.yaml \
    --git-access-token $GITHUB_TOKEN