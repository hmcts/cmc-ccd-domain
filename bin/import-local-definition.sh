#!/bin/sh
docker build -t hmctspublic.azurecr.io/cmc/ccd-definition-importer:dev -f definition/Dockerfile .
./bin/upload-ccd-definition-to-env.sh local dev