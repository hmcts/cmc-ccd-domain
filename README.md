# CMC CCD Domain and Definitions

## Build status

- Docker Image: [![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/hmcts.cmc-ccd-domain?branchName=master)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=176&branchName=master)
- Java Jar: [![Build Status](https://travis-ci.com/hmcts/cmc-ccd-domain.svg?branch=master)](https://travis-ci.com/hmcts/cmc-ccd-domain) [![Download](https://api.bintray.com/packages/hmcts/hmcts-maven/cmc-ccd-domain/images/download.svg) ](https://bintray.com/hmcts/hmcts-maven/cmc-ccd-domain/_latestVersion)

## Contents

* CMC CCD model
* CMC CCD JSON Definition (*note:* [definition/README.md](./definition/README.md) for how to handle definitions)
* Tooling to release/manage CCD Definition
* ToDo:
    * Exercise cmc-claim-store and cmc-claim-submit-api functional tests (and any other consumers)

## Versioning

Version number is defined in file [VERSION.yaml](./VERSION.yaml), both artefacts use same version number.

*Important* do not change format of VERSION.yaml - sed is used in various scripts to extract the version number.

### Release

On any tagged commit Travis and Azure DevOps will release both artefacts. 

- Travis will build and push to bintray: http://dl.bintray.com/hmcts/hmcts-maven/uk/gov/hmcts/reform/cmc/ccd-domain/
- Azure DevOps will build and push to ACR: hmctspublic.azurecr.io/cmc/ccd-definition-importer

Both status's are refelected on README with build badges.

*NOTE:* Docker images are write and delete protected to stop overwriting tags. 
If you do need to delete an image then you will need to disable these flags, 
e.g.: `az acr repository update --name hmctspublic --image cmc/ccd-definition-importer:1.2.2 --delete-enabled true  --write-enabled true` 

##### To release:

You can either tag in command line or manually release through GitHub.

Command-line:

1. Merge PR to master
1. Checkout master: `git checkout master`
1. Get last commit: `git log`
1. Tag last commit with VERSION.yaml: `git tag -a $(cat VERSION.yaml | sed 's/TAG: //') COMMIT_HASH`
1. Push tag: `git push origin $(cat VERSION.yaml | sed 's/TAG: //')`

Please create a release in GitHub too.

#### Definitions

See definition [README](./definition/README.md#)

## Development (WIP)

1. Open PR here, bumping up /definitions/VERSION.yaml to 1.2.1 (no functional test running at this stage)
    * cmc-ccd-domain - master 1.2.0
    * cmc-claim-store - master 1.2.0
    * cmc-integration-tests - master 1.2.0
1. Merge PR
    * cmc-ccd-domain - master 1.2.1
    * cmc-claim-store - master 1.2.0
    * cmc-integration-tests - master 1.2.0
1. Open PR in cmc-claim-store and cmc-integration-tests, pinning version to new CCD definition 1.2.1 (this runs functional tests ensuring backward compatibility with current code base)
    * cmc-ccd-domain - master 1.2.1
    * cmc-claim-store - master 1.2.0
    * cmc-integration-tests - master 1.2.0
1. Merge PR in cmc-claim-store and cmc-integration-tests after green build (that brings the newer definition to all local dev environments)
    * cmc-ccd-domain - master 1.2.1
    * cmc-claim-store - master 1.2.1
    * cmc-integration-tests - master 1.2.1
1. Generate CCD Definition from the Docker image 1.2.1, attach to new Jira ticket, manually deploy to DEMO and AAT. 
1. Manually regression test CCD Definition 1.2.1 in AAT.
1. Manually deploy CCD Definition 1.2.1 to PROD.
1. Open code change PR in cmc-claim-store (that run all functional test again new code and version 1.2.1)
    * cmc-ccd-domain - master 1.2.1
    * cmc-claim-store - master 1.2.1
    * cmc-integration-tests - master 1.2.1
1. Merge code change in cmc-claim-store after green build (deployed into PROD)
