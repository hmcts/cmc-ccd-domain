# Renovate automerge

## Current configuration

`cmc-ccd-domain` uses `.github/renovate.json`. It extends only the shared HMCTS preset (`local>hmcts/.github:renovate-config`). It does not extend `local>hmcts/.github//renovate/automerge-all`, unlike `civil-service`, `cmc-claim-store` and the other civil repositories.

Settings, with where each comes from:

- `timezone`: `Europe/London` (preset).
- `schedule`: after 7am and before 11am every weekday (preset).
- `automergeSchedule`: not set, so Renovate can automerge at any time.
- `platformAutomerge`: not set. Renovate's default is `true`, so Renovate enables GitHub auto-merge on a PR and GitHub merges it as soon as the required checks and reviews pass.
- `rebaseWhen`: not set. Renovate's default, `auto`, rebases automerge PRs when they fall behind `master`.
- `automergeStrategy`: not set, so the repository's default merge method is used.
- `prConcurrentLimit`: `10`.

Package rules, in order. Preset rules come first, then this repository's:

| Rule | Source | Matches | Automerge |
|---|---|---|---|
| flyway | preset | `flyway` | no |
| Jenkins library (minor and patch) | preset | `hmcts/cnp-jenkins-library` | yes |
| Jenkins library (major) | preset | `hmcts/cnp-jenkins-library` | no |
| Node.js | preset | Node major updates (Docker image, `.nvmrc`, `@types/node`), grouped into one PR | no |
| all non-major dependencies | repository | every minor and patch update | yes |

Major updates have no automerge rule, so they open as separate PRs and need a manual merge.

Because the repository's catch-all comes last, it also takes the Jenkins library minor and patch updates into "all non-major dependencies", which automerges anyway. If named groups are added later, put them after the catch-all: later rules win, so a group placed before it would lose its packages to it. `cmc-claim-store`, `cmc-citizen-frontend` and `civil-wa-task-configuration` had exactly that bug.

### Deprecated options

The config still uses `regexManagers`, `fileMatch` and `matchPackagePatterns`, which Renovate has replaced with `customManagers`, `managerFilePatterns` and `matchPackageNames`. Renovate's own config migration PR (#699) makes those changes and should be merged.

The repository's Dockerfile regex manager duplicates `regexManagers:dockerfileVersions`, which the shared preset already includes. It can be removed.

## Why Renovate PRs are not merging

The last Renovate PR to automerge was #690, on 2026-02-26. Since then:

| PR | Opened | State |
|---|---|---|
| #692 Update all non-major dependencies | 2026-06-24 | approved; GitHub Actions checks pass; Jenkins `error` |
| #693, #694, #696, #697 (majors) | 2026-08 | review required; Jenkins `error` |
| #699 Migrate Renovate config | 2026-11-26 | review required; Jenkins `error` |
| #665, #670, #675, #681, #684 (older majors) | 2025 | review required; Jenkins `error` |

`continuous-integration/jenkins/pr-head` ends in `error` with "This commit cannot be built" within two minutes on every open PR, including PRs that don't touch dependencies. The build fails before it runs anything, so the cause is in the Jenkins job or pipeline setup rather than in any dependency update. The Jenkins log needs checking at `https://build.hmcts.net/job/HMCTS_a_to_c/job/cmc-ccd-domain/`. Until that is fixed no PR in this repository can pass Jenkins, and #692 stays blocked even though it is approved.

The repository has no `CODEOWNERS` file, so Renovate PRs need a normal approval but not a code-owner review. The branch protection settings are not visible with a non-admin token. The pattern above (#692 approved but `BLOCKED`) suggests the Jenkins check and one approval are both required.

## Merge window and Jenkins availability

PTL Jenkins runs on `cft-ptl-00-aks`, which [`hmcts/auto-shutdown`](https://github.com/hmcts/auto-shutdown) normally stops from 20:00 to 06:30 daily. There is no scheduled weekend startup.

This repository sets no merge window, and GitHub auto-merge is on (the `platformAutomerge` default). A Renovate PR therefore merges as soon as its checks and reviews pass, which can be during the working day. To match the other civil repositories, set:

```json
"automergeSchedule": [
  "after 7am and before 9am every weekday",
  "after 5pm and before 8pm every weekday"
],
"platformAutomerge": false
```

`platformAutomerge` must be `false` for the schedule to take effect; otherwise GitHub merges whenever checks pass, regardless of `automergeSchedule`.

## Holds

None. When a Renovate PR fails the build on every rebase, find the cause and add a package rule with a `description` giving the reason, rather than leaving the PR open.

## Stalled-queue alert

`civil-service`'s `.github/workflows/renovate-stalled-alert.yml` checks the open Renovate PRs of the other civil and cmc repositories each weekday morning. `cmc-ccd-domain` is not in its list, which is why PRs here have been open for months without an alert. Add `hmcts/cmc-ccd-domain` to that workflow to cover it.

## Release freeze

Use a Renovate package rule for a planned release freeze, so the freeze is reviewable and recorded in the repository. Add it as the final item under `packageRules` in `.github/renovate.json`:

```json
{
  "description": "Release freeze: disable Renovate automerge",
  "matchPackageNames": ["*"],
  "automerge": false
}
```

It must stay last: later rules win, and the rules above set `automerge: true`. The rule stops automerge but leaves Renovate opening and rebasing PRs.

### Start a freeze

1. Add the freeze rule in a pull request, with the release or change reference and the intended end date in the description.
2. Merge it before the freeze starts, then run Renovate manually or wait for its next scheduled run.
3. While `platformAutomerge` is on, turn off GitHub auto-merge on any open Renovate PR that already has it. The new rule stops Renovate enabling auto-merge, but it does not cancel a request GitHub already holds.
4. Confirm in the Mend job log that the rule resolves to `automerge: false`, and record that in the release ticket.

### End a freeze

1. Remove the freeze rule through a pull request once the release is approved.
2. Merge it, then run Renovate manually or wait for its next scheduled run.
3. Check that a clean Renovate PR automerges only after all required checks pass.

## Pausing Renovate

Pausing is broader than a release freeze: it also stops new PRs, rebases and PR maintenance.

| | Release freeze (`automerge: false` rule) | Pause |
|---|---|---|
| New PRs and rebases | continue | stop |
| Automerge | stops | stops |
| Renovate's PR queue | stays current; merges are manual | builds up until turned back on |

There are two ways to pause:

- **In the repository:** set `"enabled": false` at the top level of `.github/renovate.json` in a pull request, with the reason and expected end. It takes effect once merged and Renovate next runs. Revert the pull request to turn Renovate back on.
- **In the Mend Developer Portal:** an organisation admin can pause the repository at `https://developer.mend.io/github/hmcts/cmc-ccd-domain/-/settings`. This takes effect without a merge, so it suits a freeze that has to start straight away. Turn it back on in the portal.

Changing branch protection is not recommended as a routine toggle: it affects all contributors and makes intentional freezes look like authorisation failures.
