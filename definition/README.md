# CMC CCD Definitions

## Runtime Defintions

The JSON will contain templated values like `CCD_DEF_BASE_URL`. An example is for callback URLs - these will be different per environment. It means the actual Excel definition file will be created at runtime and make use of definition processor templating feature: https://github.com/hmcts/ccd-definition-processor#variable-substitution. The build process contains a test phase to test if the Excel generation task is successful so we should always have a usable image.

## Building

Any commit or merge into master will automatically trigger an Azure ACR task. This task has been manually
created using `./bin/deploy-acr-task.sh`. The task is defined in `acr-build-task.yaml`. 

Note: you will need a GitHub personal token defined in `GITHUB_TOKEN` environment variable to run deploy script (https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line). The token is for setting up a webhook so Azure will be notified when a merge or commit happens. Make sure you are a repo admin and select token scope of: `admin:repo_hook  Full control of repository hooks`

More info on ACR tasks can be read here: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview

## Testing the ACR Task

I don't think we will be doing this very often so it's not the prettiest way but we have a helper script to test the ACR task. To run:

1. Create a branch from master
2. Run: `./bin/test-acr-task.sh [your-new-branch]`

You will see streamed output to help. It will push images tagged with `runid` and `test`.

## Managing the ACR task

Several helper scripts for checking the ACR task:

`./bin/get-status.sh` - will show status of last build
`./bin/show-acr-task` - gets the ACR task details (if deployed)
`./bin/delete-acr-task.sh` - delete the ACR task

More info on ACR tasks can be read here: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview

# Release Process

Currently the release process is two phases. Defintion generation and release. Release is a manual process that requires Jira tickets to be raised with CCD team. Generation happens with a PR here, then approval and merge to master, this creates a new hmcts.azurecr.io/hmcts/cmc-ccd-definition-importer Docker image. This image will be responsible for loading defintions into AKS and local development environments.

Step by Step Release Actions:

1. Make defintion changes in a new PR, get approval and merge to master
2. Run `./bin/pull-definition-from-docker.sh 1.2.2` to pull a local copy of the definitions for version 1.2.2 in Excel format. Will save to current directory in: `./xls-definitions/`.
3. Create Jira ticket for CCD team and attach definitions for uploading. 

# Running Excel to Json

Sometimes you may need to convert the Excel definitions back to JSON. To do this run:

```
docker build -f xlsx2json.Dockerfile -t xlsx2json .
docker run -v `pwd`/xls-definitions:/data xlsx2json
```