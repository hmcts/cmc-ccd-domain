# CMC CCD Domain and Definitions

Contains:

* CMC CCD model
* CMC CCD JSON Definition (*note:* [definition/README.md](./definition/README.md) for how to handle definitions)
* Tooling to release/manage CCD Definition
* When merging into master:
    * Release the Docker CCD Definition image
    * Release new JAR
    * Exercise cmc-claim-store and cmc-claim-submit-api functional tests (and any other consumers)

## Release

Version number is defined in file [VERSION.yaml](./VERSION.yaml), both artefacts use same version number.

### Domain (Java Jar)

On any tagged commit Travis will build and push to bintray: http://dl.bintray.com/hmcts/hmcts-maven/uk/gov/hmcts/reform/cmc/ccd-domain/

#### To release:

1. Merge PR to master
1. Checkout master: `git checkout master`
1. Get last commit: `git log`
1. Tag last commit with VERSION.yaml: `git tag -a $(cat VERSION.yaml | sed 's/TAG: //') cb6fbbb2e20dbdd5eb3e07e58928358a6b0a52fd`
1. Push tag: `git push origin $(cat VERSION.yaml | sed 's/TAG: //')`

### Definitions (Docker image)

See definition [README.md](./definition/README.md#)


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
