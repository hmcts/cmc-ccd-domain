#!/bin/bash
set -e

az account set --subscription DCD-CNP-DEV
az acr task delete -r hmcts -n task-cmc-ccd-definition-importer