# CMC CCD Definitions

## Runtime Defintions

The JSON will contain templated values like `CCD_DEF_BASE_URL`. An example is for callback URLs - these will be different per environment. It means the actual Excel definition file will be created at runtime and make use of definition processor templating feature: https://github.com/hmcts/ccd-definition-processor#variable-substitution. The build process contains a test phase to test if the Excel generation task is successful so we should always have a usable image.

# Release Process

Currently the release process is two phases. Automated definition generation in a Docker image and then the release. Releasing to PROD is a manual process that requires a Jira ticket to be raised with CCD team. Generation happens with a PR here, then approval and merge to master, this creates a new `hmctspublic.azurecr.io/cmc/ccd-definition-importer` Docker image. This image has JSON definition data baked in and will be responsible for loading defintions into AKS and local development environments.

## Step by Step Release:

1. Make definition changes in a new PR (note: bump VERSION.yaml), get approval and merge to master
1. Tag release - manually or with GitHub release (this will trigger Travis for domain Jar and Azure DevOps Pipeline for Docker image with definitions)
1. Wait a few mins for pipeline to run and complete, check GitHub page for build status badges.
1. Run `./definition/bin/pull-definition-from-docker.sh aat 1.2.2` to pull a local copy of the definitions for version 1.2.2 in Excel format. Will save to current directory in: `./definition/releases/`.
1. Run `./definition/bin/pull-definition-from-docker.sh prod 1.2.2` as above for PROD.
1. Clone previous release Jira ticket for CCD team and attach definitions for uploading (AAT & PROD). Add to parent confluence doc: https://tools.hmcts.net/confluence/display/ROC/CCD+Reference+Material

# Developing 

If you need to work with local definitions:

1. Build a new cmc-ccd-definition-importer, tagged with `dev`. In root directory:
```bash
$ docker build -t hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:dev -f definition/Dockerfile .
```

2. Upload to local environment:
```bash
$ ./definition/bin/upload-ccd-definition-to-env.sh local dev
```

Note: if you want to make this semi-permanent also update docker-compose.yaml in cmc-integration-tests project to pin to your dev version:
```
    ccd-importer:
      image: hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:dev
```

## Upload to an environment

Note: uploading to an environment requires `azure-cli`, `jq` and `python3` to be installed.

```bash
$ ./definition/bin/upload-ccd-definition-to-env.sh aat 1.2.3
```

This will run the Docker image specified with version in command. So above will upload defintions released in: `hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer:1.2.3` in AAT.

## Debugging

If an error occurs try running the script with a `-v` flag after the script name:
```bash
$ ./definition/bin/upload-ccd-definition-to-env.sh -v aat 1.2.3
```

# Running Excel to Json

Sometimes you may need to convert the Excel definitions back to JSON. To do this run:

```
docker build -f xlsx2json.Dockerfile -t xlsx2json .
docker run -v `pwd`/definition/xls:/data xlsx2json
```
