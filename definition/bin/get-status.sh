#!/bin/bash
set -e

az account set --subscription DCD-CNP-DEV
az acr task list-runs --registry hmcts --name task-cmc-ccd-definition-importer | jq '.[0] | {started: .startTime, registry: .outputImages[1].registry, repository: .outputImages[1].repository, tag: .outputImages[1].tag, status: .status}'