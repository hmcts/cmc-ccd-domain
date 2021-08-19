#!/usr/bin/env bash

set -eu

pr=${1}

echo 'export ENVIRONMENT=preview'

# definition placeholders
echo "export CCD_DEF_CMC_SERVICE_BASE_URL=http://cmc-ccd-pr-${pr}.service.core-compute-preview.internal"
