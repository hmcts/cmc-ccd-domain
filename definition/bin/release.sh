#!/bin/bash
set -e

BRANCH="${1:-}"
ACR_REGISTRY="hmcts"
ACR_TASKNAME="task-cmc-ccd-definition-importer"
IMAGE="hmcts/cmc-ccd-definition-importer"
TAG=$(cat VERSION.yaml | sed 's/TAG: //')

[ "_${BRANCH}" = "_" ] && echo "No BRANCH defined. Script terminated." && exit 0

az account set --subscription DCD-CNP-DEV

az acr task create \
    --registry ${ACR_REGISTRY} \
    --name ${ACR_TASKNAME} \
    --file ./definition/acr-build-task.yaml \
    --context https://github.com/hmcts/cmc-ccd-domain.git \
    --branch ${BRANCH} \
    --values VERSION.yaml \
    --git-access-token $GITHUB_TOKEN

az acr task run --registry ${ACR_REGISTRY} --name ${ACR_TASKNAME}

az acr task delete --registry ${ACR_REGISTRY} --name ${ACR_TASKNAME}

az acr repository update \
    --name ${ACR_REGISTRY} --image ${IMAGE}:${TAG} \
    --delete-enabled false --write-enabled false
