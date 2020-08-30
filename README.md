![Lint and Test Charts](https://github.com/javimox/helm-charts/workflows/Lint%20and%20Test%20Charts/badge.svg) [![](https://github.com/javimox/helm-charts/workflows/Release%20Charts/badge.svg?branch=master)](https://github.com/javimox/helm-charts/actions) ![Latest Stable Versions](https://github.com/javimox/helm-charts/workflows/Latest%20Stable%20Versions/badge.svg)

# mox helm repository

Applications ready to be launched on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add mox https://helm.mox.sh
$ helm search repo mox
$ helm install my-release mox/<chart>
```

## Project Status

`master` supports Helm 3 only, i. e. both `v1` and `v2` [API version](https://helm.sh/docs/topics/charts/#the-apiversion-field) charts are installable.

Helm Charts of `mox` repository are available on:
 * [helm.mox.sh](https://helm.mox.sh)
 * [hub.helm.sh](https://hub.helm.sh/charts/mox)
 * [artifacthub.io](https://artifacthub.io/packages/search?repo=mox)
 * [hub.kubeapps.com](https://hub.kubeapps.com/charts/mox)

## Chart Sources

* `[charts/confluence-server]`: Atlassian Confluence Server chart. [mox.sh](https://mox.sh/helm/charts/confluence-server/) [github.com](https://github.com/javimox/helm-charts/tree/master/charts/confluence-server)
* `[charts/crowd]`: Atlassian Crowd chart. [mox.sh](https://mox.sh/helm/charts/crowd/) [github.com](https://github.com/javimox/helm-charts/tree/master/charts/crowd)
* `[charts/jira-software]`: Jira Software chart. [mox.sh](https://mox.sh/helm/charts/jira-software/) [github.com](https://github.com/javimox/helm-charts/tree/master/charts/jira-software)

## Contribute

Contributions are welcome! If you have any issue deploying these charts or a enhancement feature, feel free to open an issue on [my GitHub](https://github.com/javimox/helm-charts/tree/master).

If you want to add your Charts to the **mox** repository or modify those that are available, you are welcome to:

* Fork this repository
* Create a branch off master named after your chart
* Create a PR

## About Helm

* [Quick Start guide](https://helm.sh/docs/intro/quickstart/)
* [Using Helm Guide](https://helm.sh/docs/intro/using_helm/)

## About this repository and its Actions

* [@helm/kind-action](https://github.com/helm/kind-action)
* [@helm/chart-testing-action](https://github.com/helm/chart-testing-action)
* [@helm/chart-releaser-action](https://github.com/helm/chart-releaser-action)

# License
Copyright © 2020 mox.sh

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
