# Atlassian Crowd

[Crowd](https://www.atlassian.com/software/crowd) is the directory service solution from **Atlassian** that provides Single sign-on (SSO) and OpenID compatibility.

## TL;DR;

All commands below are Helm v3

```console
$ helm repo add mox https://helm.mox.sh
$ helm repo update
$ helm install my-release mox/crowd
```

## Introduction

This chart bootstraps a [Crowd server](https://hub.docker.com/r/atlassian/crowd/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It is available on:
 * https://helm.mox.sh
 * https://hub.helm.sh/charts/mox/crowd
 * https://artifacthub.io/package/chart/mox/crowd
 * https://hub.kubeapps.com/charts/mox/crowd

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure (Only when persisting data)
- At least 1GB Memory

## Installing the Chart

This chart is not available in the Helm repositories. To install the chart first you need to add this Helm repository:

```console
$ helm repo add mox https://helm.mox.sh
$ helm repo update
```

To deploy it with the release name `my-release` run:

```console
$ helm install my-release mox/crowd
```

The command deploys **Crowd server** on the Kubernetes cluster in the default configuration. The [configuration parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes (almost) all the Kubernetes components associated with the chart and deletes the release. See [PostgreSQL enabled](#uninstall-with-postgres-enabled) for more details.

## Upgrading the Chart

To upgrade the `my-release` deployment when there was **no** PostgreSQL deployed just run:

```console
$ helm upgrade my-release
```

Otherwise, see [Upgrade Crowd server with PostgreSQL enabled](#upgrade-with-postgres-enabled) for more details.

## <a name="database-connection"></a>Database connection

The values `databaseConnection.*` are **only** used to create a user and a database for Crowd if PostgreSQL is enabled.
During the Setup Wizard is still necessary to configure the database connection, as no connection URL is documented [here](https://hub.docker.com/r/atlassian/crowd).

## PostgreSQL enabled

This chart deploys **by default** a [bitnami PostgreSQL](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) instance.

### <a name="install-with-postgres-enabled"></a>Install Crowd server with PostgreSQL enabled

PostgreSQL Chart from **bitnami** generates a random password if we do not specify one. Random or not, keep the password safe because it will be needed when upgrading Crowd.

To specify a password:
```console
$ helm install my-release \
     --set global.postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set global.postgresql.replicationPassword=[REPLICATION_PASSWORD] # in case Replication is enabled \
     mox/crowd
```

### <a name="uninstall-with-postgres-enabled"></a>Uninstall Crowd server with PostgreSQL enabled

The Persistent Volume Claim (PVC) of postgres will **NOT** be automatically deleted. It needs to be removed manually.

### <a name="upgrade-with-postgres-enabled"></a>Upgrade Crowd server with PostgreSQL enabled

From [bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrade):
> It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords.

We upgrade the `my-release` deployment by running:

```console
$ helm upgrade my-release \
     --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set postgresql.replication.password=[REPLICATION_PASSWORD] # in case Replication is enabled
```

## Parameters

The following tables lists the configurable parameters of the Crowd Server chart and their default values.

|                   Parameter                   |                                                           Description                                                          |                  Default                     |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `image.registry`                              | Crowd Server Image registry                                                                                                    | `docker.io`                                  |
| `image.repository`                            | Crowd Server Image name                                                                                                        | `atlassian/crowd`                            |
| `image.tag`                                   | Crowd Server Image tag                                                                                                         | `{TAG_NAME}`                                 |
| `image.pullPolicy`                            | Crowd Server Image pull policy                                                                                                 | `IfNotPresent`                               |
| `image.pullSecrets`                           | Secrets to pull an image from a private Docker registry or repository                                                          | `{}`                                         |
| `nameOverride`                                | String to partially override crowd.fullname template with a string (will prepend the release name)                             | `""`                                         |
| `fullnameOverride`                            | String to fully override crowd.fullname template with a string                                                                 | `""`                                         |
| `serviceAccount.create`                       | Specifies whether a service account should be created                                                                          | `false`                                      |
| `serviceAccount.annotations`                  | Map of service account annotations                                                                                             | `{}`                                         |
| `serviceAcccount.name`                        | Name of existing service account                                                                                               | `""`                                         |
| `podSecurityContext.fsGroup`                  | All processes of the container are also part of this supplementary group ID                                                    | `2002`                                       |
| `securityContext`                             | Container security context options                                                                                             | `{}`                                         |
| `service.type`                                | Kubernetes Service type                                                                                                        | `nodePort`                                   |
| `service.port`                                | Service HTTP port (Note: it must match with `envVars.ATL_TOMCAT_PORT`)                                                         | `8095`                                       |
| `service.httpsPort`                           | Service HTTPS port  (Note: needs `envVars.ATL_TOMCAT_SCHEME: https`)                                                           | `empty`                                      |
| `service.loadBalancer`                        | Kubernetes LoadBalancerIP to request                                                                                           | `empty`                                      |
| `service.nodePorts.http`                      | Kubernetes http node port                                                                                                      | `""`                                         |
| `service.nodePorts.https`                     | Kubernetes https node port                                                                                                     | `""`                                         |
| `ingress.enabled`                             | Enable ingress controller resource                                                                                             | `false`                                      |
| `ingress.annotations`                         | Map of ingress annotations                                                                                                     | `{}`                                         |
| `ingress.hosts[0].host`                       | Crowd Server installation hostname                                                                                             | `crowd.local`                                |
| `ingress.hosts[0].paths`                      | Path within the url structure                                                                                                  | `[]`                                         |
| `ingress.tls`                                 | TLS options                                                                                                                    | `[]`                                         |
| `ingress.tls[0].secretName`                   | TLS Secret (certificates)                                                                                                      | `nil`                                        |
| `ingress.tls[0].hosts[0]`                     | TLS hosts                                                                                                                      | `nil`                                        |
| `resources`                                   | CPU/Memory resource requests/limits                                                                                            | Memory: `1Gi`, CPU: `500m`                   |
| `replicaCount`                                | Number of replicas for this deployment                                                                                         | `1`                                          |
| `nodeSelector`                                | Node labels for pod assignment                                                                                                 | `{}`                                         |
| `tolerations`                                 | List of node taints to tolerate                                                                                                | `[]`                                         |
| `affinity`                                    | Map of node/pod affinity labels                                                                                                | `{}`                                         |
| `podAnnotations`                              | Map of annotations to add to the pods                                                                                          | `{}`                                         |
| `persistence.enabled`                         | Enable persistence using PVC                                                                                                   | `true`                                       |
| `persistence.existingClaim`                   | Provide an existing `PersistentVolumeClaim` for the Crowd Server, the value is evaluated as a template                         | `""`                                         |
| `persistence.accessModes`                     | PVC Access Mode for Crowd Server volume                                                                                        | `ReadWriteOnce`                              |
| `persistence.size`                            | PVC Storage Request for Crowd Server volume                                                                                    | `10Gi`                                       |
| `persistence.storageClass`                    | PVC Storage Class for Crowd Server volume                                                                                      | `empty` (uses alpha storage annotation)      |
| `extraVolumeMounts`                           | Additional volume mounts to add to the pods                                                                                    | `[]`                                         |
| `extraVolumes`                                | Additional volumes to add to the pods                                                                                          | `[]`                                         |
| `schedulerName`                               | Use an alternate scheduler, eg. `stork`                                                                                        | `""`                                         |
| `readinessProbe`                              | Readiness probe values                                                                                                         | `{}`                                         |
| `readinessProbe.httpGet.path`                 | Readiness probe HTTP GET request (Note: Crowd handler is `/status`)                                                            | `nil`                                        |
| `readinessProbe.httpGet.port`                 | Readiness probe port (Note: Crowd listens on internal port 8095)                                                               | `nil`                                        |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated                                                                                      | `nil`                                        |
| `readinessProbe.periodSeconds`                | How often to perform the probe                                                                                                 | `nil`                                        |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                     | `nil`                                        |
| `readinessProbe.timeoutSeconds`               | When the probe times out                                                                                                       | `nil`                                        |
| `livenessProbe`                               | Liveness probe values                                                                                                          | `{}`                                         |
| `livenessProbe.httpGet.path`                  | Liveness probe HTTP GET request (Note: Crowd handler is `/status`)                                                             | `nil`                                        |
| `livenessProbe.httpGet.port`                  | Liveness probe port (Note: Crowd listens on internal port 8095)                                                                | `nil`                                        |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated                                                                                       | `nil`                                        |
| `livenessProbe.periodSeconds`                 | How often to perform the probe                                                                                                 | `nil`                                        |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                     | `nil`                                        |
| `livenessProbe.timeoutSeconds`                | When the probe times out                                                                                                       | `nil`                                        |
| `postgresql.enabled`                          | Whether to use the PostgreSQL chart                                                                                            | `true`                                       |
| `postgresql.image.registry`                   | PostgreSQL image registry                                                                                                      | `docker.io`                                  |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                                                                    | `bitnami/postgresql`                         |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                                                                           | `11`                                         |
| `postgresql.image.pullPolicy`                 | PostgreSQL image pull policy                                                                                                   | `IfNotPresent`                               |
| `postgresql.fullnameOverride`                 | String to fully override postgresql.fullname template with a string                                                            | `crowd-db`                                   |
| `postgresql.persistence.size`                 | PVC Storage Request for PostgreSQL volume                                                                                      | `nil`                                        |
| `postgresql.initdbScriptsConfigMap`           | ConfigMap with the initdb scripts (Note: Overrides initdbScripts). The value is evaluated as a template.                       | `{{ .Release.Name }}-db-helper-cm`           |
| `databaseConnection.host`                     | Hostname of the database server. See [Database connection](#database-connection).                                              | `crowd-db`                                   |
| `databaseConnection.user`                     | Crowd database user. See [Database connection](#database-connection).                                                          | `crowduser`                                  |
| `databaseConnection.password`                 | Crowd database password.See [Database connection](#database-connection).                                                       | `"CHANGEME"`                                 |
| `databaseConnection.database`                 | Crowd database name. See [Database connection](#database-connection).                                                          | `crowddb`                                    |
| `databaseConnection.lang`                     | Encoding used for lc_ctype and lc_collate in case the database needs to be created (See: `postgresql.initdbScriptsConfigMap`)  | `C`                                          |
| `databaseDrop.enabled`                        | Enable database removal. See [remove existing database](#remove-existing-database)                                             | `false`                                      |
| `databaseDrop.dropIt`                         | Confirm database removal if set to `yes`                                                                                       | `no`                                         |
| `caCerts.secret`                              | Secret that will be imported into the keystore using keytool                                                                   | `nil`                                        |
| `caCerts.storepass`                           | Keytool store password (storepass parameter)                                                                                   | `nil`                                        |
| `caCertsEnv`                                  | Any environment variable you would like to pass on to the OpenJDK init container. The value is evaluated as a template         | `nil`                                        |
| `envVars`                                     | Crowd Server environment variables that will be injected in the ConfigMap. The value is evaluated as a template                | `{}`                                         |
| `extraEnv`                                    | Enable additional Crowd Server container environment variables. The value is passed as string                                  | `nil`                                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
      --set databaseConnection.host="mydb.example.com" \
      --set databaseConnection.user="test" \
      --set databaseConnection.password="testpass" \
      --set databaseConnection.database="crowd" \
      --set databaseConnection.port="5432" \
      --set databaseConnection.type="postgresql"
      mox/crowd
```

The above command sets the different parameters of the database connection.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```console
$ helm install my-release -f values-production.yaml mox/crowd
```

## <a name="remove-existing-database"></a>Remove existing database

It is possible to remove an existing Crowd database while deploying. Useful if, e.g. we are installing this Chart in a CI environment.

**Use with caution:**

If `databaseDrop.enabled` is set to `true` and `databaseDrop.dropIt` is set to `yes`, then removes the database specified on `databaseConnection.database`, if it exists.

```console
$ helm upgrade --install my-release \
      --set databaseDrop.enabled=true \
      --set databaseDrop.dropIt="yes" \
      mox/crowd
```

## <a name="values_values-prod-diff"></a>Difference between values and values-production

Chart Version 0.1.1
```console
--- crowd/values.yaml
+++ crowd/values-production.yaml
@@ -252,11 +252,11 @@
 #
 ## Environment Variables that will be injected in the ConfigMap
 ## Default values unless otherwise stated
-envVars: {}
+envVars:
   ## Memory / Heap Size (JVM_MINIMUM_MEMORY) Mandatory, see @Notes above
-  # JVM_MINIMUM_MEMORY: 384m
+  JVM_MINIMUM_MEMORY: 1024m
   ## Memory / Heap Size (JVM_MAXIMUM_MEMORY) Mandatory, see @Notes above
-  # JVM_MAXIMUM_MEMORY: 768m
+  JVM_MAXIMUM_MEMORY: 1024m
   #
   ## Tomcat and Reverse Proxy Settings
   ## Crowd running behind a reverse proxy server options
```

## Links

* [Atlassian Crowd](https://confluence.atlassian.com/crowd)
* [Helm](https://helm.sh/)
* [mox](https://helm.mox.sh/)
