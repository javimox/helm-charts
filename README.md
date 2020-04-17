# mox Helm repository

[![](https://github.com/javimox/helm-charts/workflows/Release%20Charts/badge.svg?branch=master)](https://github.com/javimox/helm-charts/actions)

## Actions

* [@helm/kind-action](https://github.com/helm/kind-action)
* [@helm/chart-testing-action](https://github.com/helm/chart-testing-action)
* [@helm/chart-releaser-action](https://github.com/helm/chart-releaser-action)

## Project Status

`master` supports Helm 3 only, i. e. both `v1` and `v2` [API version](https://helm.sh/docs/topics/charts/#the-apiversion-field) charts are installable.

## Chart Sources

* `charts/confluence-server`: Atlassian Confluence Server Helm Chart

### Prerequisites

* A GitHub project to use for your Charts repo (a clean project is most straightforward, as there won't be release cluttering or possible `gh-pages` conflicts)
* A branch to use for GitHub Pages (`gh-pages` is most straightforward, as it's the default and requires no configuration)
* A project [Secret](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets#creating-encrypted-secrets) named `CR_TOKEN` with the value of a GitHub [personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)
  * The token must have `repo` scope
  * The token's user must have write access to the project
  * To mitigate risk you may wish to limit the token to a single project by creating a [machine user](https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users)
  * Please note the personal access token is required because of an [Actions bug](https://github.community/t5/GitHub-Actions/Github-action-not-triggering-gh-pages-upon-push/m-p/31266/highlight/true#M743), and will hopefully be unnecessary in the future

### Results

* The [Lint and Test Charts](/.github/workflows/lint-test.yaml) workflow uses [@helm/kind-action](https://www.github.com/helm/kind-action) GitHub Action to spin up a [kind](https://kind.sigs.k8s.io/) Kubernetes cluster, and [@helm/chart-testing-action](https://www.github.com/helm/chart-testing-action) to lint and test the charts on every Pull Request and push
* The [Release Charts](/.github/workflows/release.yaml) workflow uses [@helm/chart-releaser-action](https://www.github.com/helm/chart-releaser-action) to turn this GitHub project into a self-hosted Helm chart repo. It does this – during every push to `master` – by checking each chart in this project, and whenever there's a new chart version, creates a corresponding [GitHub release](https://help.github.com/en/github/administering-a-repository/about-releases) named for the chart version, adds Helm chart artifacts to the release, and creates or updates an `index.yaml` file with metadata about those releases, which is then hosted on GitHub Pages

## Credits

* [Lint and Test Charts](https://github.com/helm/charts-repo-actions-demo.git
