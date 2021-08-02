#!/usr/bin/env bash

getNextReleaseVersion() {
  repoName=$1
  currentVersion=$(curl --silent "https://api.github.com/repos/hmcts/${repoName}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  IFS='.' read -a versionParts <<< "$currentVersion"
  patchVersion=$((versionParts[2] + 1))
  echo "${versionParts[0]}.${versionParts[1]}.${patchVersion}"
}

getToken() {
  az keyvault secret show --vault-name infra-vault-nonprod --name hmcts-github-apikey --query value -o tsv
}

createNewRelease() {
  repoName=$1
  token=$(getToken)
  nextReleaseVersion=$(getNextReleaseVersion $1)

  curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${token}" \
    https://api.github.com/repos/hmcts/${repoName}/releases \
    -d "{\"tag_name\":\"${nextReleaseVersion}\",\"name\":\"${repoName}-v${nextReleaseVersion}\",\"body\":\"${BUILD_URL}\"}" \
    | docker run --rm --interactive stedolan/jq '.id'
}

uploadReleaseAsset() {
  repoName=$1
  releaseId=$2
  assetName=$3
  token=$(getToken)

  curl \
    -X POST \
    -H "Authorization: token ${token}" \
    -H "Content-Type: application/zip" \
    --data-binary @$assetName \
    https://uploads.github.com/repos/hmcts/${repoName}/releases/${releaseId}/assets?name=${assetName}
}

if [ -z "$BUILD_URL" ]; then
  echo "Error: this script should only be run by Jenkins"
  exit 1
fi

zip -r cmc-ccd-definition.zip ccd-definition
zip -r cmc-screenshots.zip output
ls -lash
cp build/github-release/cmc-ccd-aat.xlsx cmc-ccd-aat.xlsx
cp build/github-release/cmc-ccd-prod.xlsx cmc-ccd-prod.xlsx
az login --identity
releaseId=$(createNewRelease cmc-ccd-definition)

uploadReleaseAsset cmc-ccd-definition $releaseId cmc-ccd-definition.zip
uploadReleaseAsset cmc-ccd-definition $releaseId cmc-e2e.zip
uploadReleaseAsset cmc-ccd-definition $releaseId cmc-ccd-aat.xlsx
uploadReleaseAsset cmc-ccd-definition $releaseId cmc-ccd-prod.xlsx
uploadReleaseAsset cmc-ccd-definition $releaseId cmc-screenshots.zip

rm cmc-ccd-definition.zip
rm cmc-e2e.zip
rm cmc-ccd-aat.xlsx