## Atlassian Crowd

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
 * [helm.mox.sh](https://helm.mox.sh)
 * [hub.helm.sh]( https://hub.helm.sh/charts/mox/crowd)
 * [artifacthub.io](https://artifacthub.io/packages/helm/mox/crowd)
 * [hub.kubeapps.com](https://hub.kubeapps.com/charts/mox/crowd)

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure (Only when persisting data)

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
$ helm uninstall my-release
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

## <a name="postgres-enabled"></a>PostgreSQL enabled

This chart deploys **by default** a [bitnami PostgreSQL](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) instance.

### <a name="install-with-postgres-enabled"></a>Install Crowd server with PostgreSQL enabled

PostgreSQL Chart from **bitnami** generates a random password if we do not specify one. Random or not, keep the password safe because it will be needed when upgrading Crowd.

To specify a password:
```console
$ helm install my-release \
     --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set postgresql.replication.password=[REPLICATION_PASSWORD] # in case Replication is enabled \
     mox/crowd
```

### <a name="uninstall-with-postgres-enabled"></a>Uninstall Crowd server with PostgreSQL enabled

The Persistent Volume Claim (PVC) of postgres will **NOT** be automatically deleted. It needs to be removed manually:

```console
$ kubectl delete pvc -l app.kubernetes.io/instance=my-release
```

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

### Global parameters

| Parameter                               | Description                                                             | Default |
|-----------------------------------------|-------------------------------------------------------------------------|---------|
| `global.postgresql.postgresqlPassword`  | PostgreSQL admin password (overrides `postgresql.postgresqlPassword`)   | `nil`   |
| `global.postgresql.replicationPassword` | Replication user password (overrides `postgresql.replication.password`) | `nil`   |

### Common parameters

| Parameter           | Description                                                                 | Default |
|---------------------|-----------------------------------------------------------------------------|---------|
| `nameOverride`      | String to partially override crowd.fullname (will prepend the release name) | `nil`   |
| `fullnameOverride`  | String to fully override crowd.fullname                                     | `nil`   |

## Crowd parameters

| Parameter                    | Description                                                                      | Default           |
|------------------------------|----------------------------------------------------------------------------------|-------------------|
| `image.registry`             | Crowd Server Image registry                                                      | `docker.io`       |
| `image.repository`           | Crowd Server Image name                                                          | `atlassian/crowd` |
| `image.tag`                  | Crowd Server Image tag                                                           | `{TAG_NAME}`      |
| `image.pullPolicy`           | Crowd Server Image pull policy                                                   | `IfNotPresent`    |
| `image.pullSecrets`          | Secrets to pull an image from a private Docker registry or repository            | `{}`              |
| `podSecurityContext.fsGroup` | All processes of the container are also part of this supplementary group ID      | `2004`            |
| `caCerts.secret`             | Secret that will be imported into the keystore using keytool                     | `nil`             |
| `caCerts.storepass`          | Keytool store password (storepass parameter)                                     | `nil`             |
| `caCertsEnv`                 | Any environment variable you would like to pass on to the OpenJDK init container | `nil`             |
| `envVars`                    | Crowd Server environment variables that will be injected in the ConfigMap        | `{}`              |
| `extraEnv`                   | Enable additional Crowd Server container environment variables, passed as string | `nil`             |

### Dependencies

Crowd requires a database. It can be either deployed as dependency using PostgreSQL subchart or configured a database connection to an external server.
By default a PostgreSQL will be deployed and a user and a database will be created using the `databaseConnection` values.

|  Parameter                           | Description                                                                                       | Default                      |
|--------------------------------------|---------------------------------------------------------------------------------------------------|------------------------------|
| `postgresql.enabled`                          | Whether to use the PostgreSQL chart                                                      | `true`                       |
| `postgresql.image.registry`                   | PostgreSQL image registry                                                                | `docker.io`                  |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                              | `bitnami/postgresql`         |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                                     | `11`                         |
| `postgresql.image.pullPolicy`                 | PostgreSQL image pull policy                                                             | `IfNotPresent`               |
| `postgresql.fullnameOverride`                 | String to fully override postgresql.fullname template with a string                      | `crowd-db`                   |
| `postgresql.persistence.size`                 | PVC Storage Request for PostgreSQL volume                                                | `8Gi`                        |
| `postgresql.postgresqlPassword`               | PostgreSQL user password                                                                 | _random 10 character string_ |
| `postgresql.initdbScriptsConfigMap`           | ConfigMap with the initdb scripts (Note: Overrides initdbScripts), evaluated as template | `.Release.Name.db-helper-cm` |
| `postgresql.initdbScriptsSecret`              | Secret with initdb scripts that contain sensitive information                            | `nil`                        |
| `databaseConnection.host`                     | Hostname of the database server. See [Database connection](#database-connection)         | `crowd-db`                   |
| `databaseConnection.user`                     | Crowd database user. See [Database connection](#database-connection)                     | `crowduser`                  |
| `databaseConnection.password`                 | Crowd database password.See [Database connection](#database-connection)                  | `"CHANGEME"`                 |
| `databaseConnection.existingSecret.name`      | Secret name that contains the database connection password                               | `nil`                        |
| `databaseConnection.existingSecret.key`       | Secret key of database connection password                                               | `nil`                        |
| `databaseConnection.database`                 | Crowd database name. See [Database connection](#database-connection)                     | `crowddb`                    |
| `databaseConnection.lang`                     | Encoding used for lc_ctype and lc_collate in case the database needs to be created       | `C`                          |
| `databaseDrop.enabled`                        | Enable database removal. See [remove existing database](#remove-existing-database)       | `false`                      |
| `databaseDrop.dropIt`                         | Confirm database removal if set to `yes`                                                 | `no`                         |

### Deployment parameters

| Parameter                            | Description                                                                               | Default                    |
|--------------------------------------|-------------------------------------------------------------------------------------------|----------------------------|
| `replicaCount`                       | Number of replicas for this deployment                                                    | `1`                        |
| `securityContext`                    | Container security context options                                                        | `{}`                       |
| `resources`                          | CPU/Memory resource requests/limits                                                       | Memory: `1Gi`, CPU: `500m` |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`                       |
| `tolerations`                        | List of node taints to tolerate                                                           | `[]`                       |
| `affinity`                           | Map of node/pod affinity labels                                                           | `{}`                       |
| `podAnnotations`                     | Map of annotations to add to the pods                                                     | `{}`                       |
| `extraVolumeMounts`                  | Additional volume mounts to add to the pods                                               | `[]`                       |
| `extraVolumes`                       | Additional volumes to add to the pods                                                     | `[]`                       |
| `schedulerName`                      | Use an alternate scheduler, eg. `stork`                                                   | `""`                       |
| `readinessProbe`                     | Readiness probe values                                                                    | `{}`                       |
| `readinessProbe.httpGet.path`        | Readiness probe HTTP GET request (Note: Crowd handler is `/status`)                       | `nil`                      |
| `readinessProbe.httpGet.port`        | Readiness probe port (Note: Crowd listens on internal port 8095)                          | `nil`                      |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                 | `nil`                      |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                            | `nil`                      |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded | `nil`                      |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                  | `nil`                      |
| `livenessProbe`                      | Liveness probe values                                                                     | `{}`                       |
| `livenessProbe.httpGet.path`         | Liveness probe HTTP GET request (Note: Crowd handler is `/status`)                        | `nil`                      |
| `livenessProbe.httpGet.port`         | Liveness probe port (Note: Crowd listens on internal port 8095)                           | `nil`                      |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                  | `nil`                      |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                            | `nil`                      |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded | `nil`                      |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                  | `nil`                      |

### Persistence parameters

| Parameter                   | Description                                                                    | Default         |
|-----------------------------|--------------------------------------------------------------------------------|-----------------|
| `persistence.enabled`       | Enable persistence using PVC                                                   | `true`          |
| `persistence.existingClaim` | Provide an existing `PersistentVolumeClaim` for Crowd, evaluated as a template | `""`            |
| `persistence.accessModes`   | PVC Access Mode for Crowd Server volume                                        | `ReadWriteOnce` |
| `persistence.size`          | PVC Storage Request for Crowd Server volume                                    | `10Gi`          |
| `persistence.storageClass`  | PVC Storage Class for Crowd Server volume                                      | `empty`         |

### RBAC parameters

| Parameter                    | Description                                           | Default |
|------------------------------|-------------------------------------------------------|---------|
| `serviceAccount.create`      | Specifies whether a service account should be created | `false` |
| `serviceAccount.annotations` | Map of service account annotations                    | `{}`    |
| `serviceAcccount.name`       | Name of existing service account                      | `""`    |

### Exposure parameters

| Parameter                   | Description                                                            | Default       |
|-----------------------------|------------------------------------------------------------------------|---------------|
| `service.type`              | Kubernetes Service type                                                | `ClusterIP`   |
| `service.port`              | Service HTTP port (Note: it must match with `envVars.ATL_TOMCAT_PORT`) | `8095`        |
| `service.httpsPort`         | Service HTTPS port  (Note: needs `envVars.ATL_TOMCAT_SCHEME: https`)   | `empty`       |
| `service.loadBalancer`      | Kubernetes LoadBalancerIP to request                                   | `empty`       |
| `service.nodePorts.http`    | Kubernetes http node port                                              | `""`          |
| `service.nodePorts.https`   | Kubernetes https node port                                             | `""`          |
| `ingress.enabled`           | Enable ingress controller resource                                     | `false`       |
| `ingress.annotations`       | Map of ingress annotations                                             | `{}`          |
| `ingress.hosts[0].host`     | Crowd Server installation hostname                                     | `crowd.local` |
| `ingress.hosts[0].paths`    | Path within the url structure                                          | `[]`          |
| `ingress.tls`               | TLS options                                                            | `[]`          |
| `ingress.tls[0].secretName` | TLS Secret (certificates)                                              | `nil`         |
| `ingress.tls[0].hosts[0]`   | TLS hosts                                                              | `nil`         |

Each parameter can be specified during the Chart installation as follow:

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

Alternatively, a YAML file can be provided to override the default `values.yaml`. For example:

```console
$ helm install my-release -f values-production.yaml mox/crowd
```

## <a name="use-existing-secrets"></a>Use existing secrets

The password of the database user needs to be specified two times. If an external database is used, only the second point is relevant.  
If the database is deployed along with the chart, then both passwords have to match.

### 1. Deploy database

This chart deploys [PostgreSQL](#postgres-enabled). It will create `databaseConnection.user` and `databaseConnection.database`, thus `databaseConnection.password` will be set.

In this case, PostgreSQL chart Bitnami flavor provides the parameter `initdbScriptsSecret`, which can be used to change the default `databaseConnection.password`.

Example with password: `test123`

SQL Query that changes the default password for `databaseConnection.user`:
```console
$ echo "ALTER USER crowduser WITH PASSWORD 'test123';" | base64 
QUxURVIgVVNFUiBjcm93ZHVzZXIgV0lUSCBQQVNTV09SRCAndGVzdDEyMyc7Cg==
```

Secret that uses the SQL Query:
```console
$ cat alter-user-passwd.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alter-user-passwd
data:
  alter-passwd.sql: QUxURVIgVVNFUiBjcm93ZHVzZXIgV0lUSCBQQVNTV09SRCAndGVzdDEyMyc7Cg==
```

Create the secret
```console
$ kubectl apply -f alter-user-passwd.yaml
```

### 2. Connect to the database

This chart sets the required environment variables to configure the database connection (`databaseConnection`). It is still necessary to enter the values during the installation of Crowd. See [Database connection](#database-connection).

The parameters `databaseConnection.existingSecret.name` and `databaseConnection.existingSecret.key` are required if an existing secret contains the password to connect to the database.  
In this case, `databaseConnection.password` will be then ignored.

Example with password: `test123`

Password:
```console
$ printf "test123" | base64
dGVzdDEyMw==
```

Secret that contains the password:
```console
$ cat db-pw.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
data:
  db-pw: "dGVzdDEyMw=="
```

Create the secret
```console
$ kubectl apply -f db-pw.yaml
```

### Install Chart using existing secrets

```console
$ helm install my-release \
   --set postgresql.initdbScriptsSecret=alter-user-passwd \
   --set databaseConnection.existingSecret.name=mysecret \
   --set databaseConnection.existingSecret.key=db-pw \
   mox/crowd
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

Chart Version 1.0.0
```diff
--- crowd/values.yaml
+++ crowd/values-production.yaml
@@ -201,7 +201,7 @@
   fullnameOverride: crowd-db
 
   persistence:
-    size: 8Gi
+    size: 10Gi
 
   ## postgres user password (needed when upgrading Chart)
   ## generate random 10 character alphanumeric string if left empty
@@ -270,11 +270,11 @@
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

## Changelog

**v1.0.0**
* Recent changes:
  - Crowd waits for postgres readiness (#42c246d)
  - Add support to existing secrets

## Links

* [Atlassian Crowd](https://confluence.atlassian.com/crowd)
* [Helm](https://helm.sh/)
* [mox](https://helm.mox.sh/)
