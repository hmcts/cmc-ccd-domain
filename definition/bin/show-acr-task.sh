#!/bin/bash
set -e

az account set --subscription DCD-CNP-DEV
az acr task show --registry hmcts --name task-cmc-ccd-definition-importer