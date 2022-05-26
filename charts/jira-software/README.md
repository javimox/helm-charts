## Atlassian Jira Software

[Jira](https://www.atlassian.com/software/jira) is a tool used for bug tracking, issue tracking, and project management. It is developed and published by the australian software company **Atlassian**.

## TL;DR;

All commands below are Helm v3

```console
$ helm repo add mox https://helm.mox.sh
$ helm repo update
$ helm install my-release mox/jira-software
```

## Introduction

This chart bootstraps a [Jira Software](https://hub.docker.com/r/atlassian/jira-software/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It is available on:
 * [helm.mox.sh](https://helm.mox.sh)
 * [hub.helm.sh](https://hub.helm.sh/charts/mox/jira-software)
 * [artifacthub.io](https://artifacthub.io/packages/helm/mox/jira-software)
 * [hub.kubeapps.com](https://hub.kubeapps.com/charts/mox/jira-software)

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure (Only when persisting data)
- At least 1GB Memory

## Installing the Chart

To install the chart first you need to add this Helm repository:

```console
$ helm repo add mox https://helm.mox.sh
$ helm repo update
```

To deploy it with the release name `my-release` run:

```console
$ helm install my-release mox/jira-software
```

The command deploys **Jira software** on the Kubernetes cluster in the default configuration. The [configuration parameters](#parameters) section lists the parameters that can be configured during installation.

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

Otherwise, see [Upgrade Jira software with PostgreSQL enabled](#upgrade-with-postgres-enabled) for more details.

## <a name="postgres-enabled"></a>PostgreSQL enabled

This chart deploys **by default** a [bitnami PostgreSQL](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) instance.

### <a name="install-with-postgres-enabled"></a>Install Jira software with PostgreSQL enabled

PostgreSQL Chart from **bitnami** generates a random password if we do not specify one. Random or not, keep the password safe because it will be needed when upgrading Jira.

To specify a password:
```console
$ helm install my-release \
     --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set postgresql.replication.password=[REPLICATION_PASSWORD] # in case Replication is enabled \
     mox/jira-software
```

### <a name="uninstall-with-postgres-enabled"></a>Uninstall Jira software with PostgreSQL enabled

The Persistent Volume Claim (PVC) of postgres will **NOT** be automatically deleted. It needs to be removed manually:

```console
$ kubectl delete pvc -l app.kubernetes.io/instance=my-release
```

### <a name="upgrade-with-postgres-enabled"></a>Upgrade Jira software with PostgreSQL enabled

From [bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrade):
> It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords.

We upgrade the `my-release` deployment by running:

```console
$ helm upgrade my-release \
     --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set postgresql.replication.password=[REPLICATION_PASSWORD] # in case Replication is enabled
```

## Parameters

The following tables lists the configurable parameters of the Jira Software chart and their default values.

### Global parameters

| Parameter                               | Description                                                             | Default |
|-----------------------------------------|-------------------------------------------------------------------------|---------|
| `global.postgresql.postgresqlPassword`  | PostgreSQL admin password (overrides `postgresql.postgresqlPassword`)   | `nil`   |
| `global.postgresql.replicationPassword` | Replication user password (overrides `postgresql.replication.password`) | `nil`   |

### Common parameters

| Parameter           | Description                                                                         | Default |
|---------------------|-------------------------------------------------------------------------------------|---------|
| `nameOverride`      | String to partially override jira-software.fullname (will prepend the release name) | `nil`   |
| `fullnameOverride`  | String to fully override jira-software.fullname                                     | `nil`   |

## Jira parameters

| Parameter                    | Description                                                                      | Default                    |
|------------------------------|----------------------------------------------------------------------------------|----------------------------|
| `image.registry`             | Jira Software Image registry                                                     | `docker.io`                |
| `image.repository`           | Jira Software Image name                                                         | `atlassian/jira-softwarer` |
| `image.tag`                  | Jira Software Image tag                                                          | `{TAG_NAME}`               |
| `image.pullPolicy`           | Jira Software Image pull policy                                                  | `IfNotPresent`             |
| `image.pullSecrets`          | Secrets to pull an image from a private Docker registry or repository            | `{}`                       |
| `podSecurityContext.fsGroup` | All processes of the container are also part of this supplementary group ID      | `2001`                     |
| `caCerts.secret`             | Secret that will be imported into the keystore using keytool                     | `nil`                      |
| `caCerts.storepass`          | Keytool store password (storepass parameter)                                     | `nil`                      |
| `caCertsEnv`                 | Any environment variable you would like to pass on to the OpenJDK init container | `nil`                      |
| `envVars`                    | Jira Software environment variables that will be injected in the ConfigMap       | `{}`                       |
| `extraEnv`                   | Enable additional Jira container environment variables, passed as string         | `nil`                      |

### Dependencies

Jira Software requires a database. It can be either deployed as dependency using PostgreSQL subchart or configured a database connection to an external server.
By default a PostgreSQL will be deployed and a user and a database will be created using the `databaseConnection` values.

|  Parameter                           | Description                                                                                       | Default                      |
|--------------------------------------|---------------------------------------------------------------------------------------------------|------------------------------|
| `postgresql.enabled`                          | Whether to use the PostgreSQL chart                                                      | `true`                       |
| `postgresql.image.registry`                   | PostgreSQL image registry                                                                | `docker.io`                  |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                              | `bitnami/postgresql`         |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                                     | `11`                         |
| `postgresql.image.pullPolicy`                 | PostgreSQL image pull policy                                                             | `IfNotPresent`               |
| `postgresql.fullnameOverride`                 | String to fully override postgresql.fullname template with a string                      | `jira-software-db`           |
| `postgresql.persistence.size`                 | PVC Storage Request for PostgreSQL volume                                                | `8Gi`                        |
| `postgresql.postgresqlPassword`               | PostgreSQL user password                                                                 | _random 10 character string_ |
| `postgresql.initdbScriptsConfigMap`           | ConfigMap with the initdb scripts (Note: Overrides initdbScripts), evaluated as template | `.Release.Name.db-helper-cm` |
| `postgresql.initdbScriptsSecret`              | Secret with initdb scripts that contain sensitive information                            | `nil`                        |
| `databaseConnection.host`                     | Hostname of the database server                                                          | `jira-software-db`           |
| `databaseConnection.user`                     | Jira database user                                                                       | `jirauser`                   |
| `databaseConnection.password`                 | Jira database password                                                                   | `"CHANGEME"`                 |
| `databaseConnection.existingSecret.name`      | Secret name that contains the database connection password                               | `nil`                        |
| `databaseConnection.existingSecret.key`       | Secret key of database connection password                                               | `nil`                        |
| `databaseConnection.database`                 | Jira database name                                                                       | `jiradb`                     |
| `databaseConnection.lang`                     | Encoding used for lc_ctype and lc_collate in case the database needs to be created       | `C`                          |
| `databaseConnection.port`                     | Jira database server port                                                                | `5432`                       |
| `databaseConnection.urlPrefix`                | Jira JDBC Prefix URL                                                                     | `jdbc:postgresql`            |
| `databaseConnection.databaseDriver`           | Jira Database driver                                                                     | `org.postgresql.Driver`      |
| `databaseConnection.type`                     | Jira database server type                                                                | `postgres72`                 |
| `databaseConnection.schemaName`               | Database schema name (Note: it depends on the `databaseConnection.type` used)            | `public`                     |
| `databaseDrop.enabled`                        | Enable database removal. See [remove existing database](#remove-existing-database)       | `false`                      |
| `databaseDrop.dropIt`                         | Confirm database removal if set to `yes`                                                 | `no`                         |

### Deployment parameters

| Parameter                            | Description                                                                               | Default                       |
|--------------------------------------|-------------------------------------------------------------------------------------------|-------------------------------|
| `replicaCount`                       | Number of replicas for this deployment                                                    | `1`                           |
| `securityContext`                    | Container security context options                                                        | `{}`                          |
| `resources`                          | CPU/Memory resource requests/limits                                                       | Memory: `1Gi`, CPU: `500m`    |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`                          |
| `tolerations`                        | List of node taints to tolerate                                                           | `[]`                          |
| `affinity`                           | Map of node/pod affinity labels                                                           | `{}`                          |
| `podAnnotations`                     | Map of annotations to add to the pods                                                     | `{}`                          |
| `extraVolumeMounts`                  | Additional volume mounts to add to the pods                                               | `[]`                          |
| `extraVolumes`                       | Additional volumes to add to the pods                                                     | `[]`                          |
| `schedulerName`                      | Use an alternate scheduler, eg. `stork`                                                   | `""`                          |
| `readinessProbe`                     | Readiness probe values                                                                    | `{}`                          |
| `readinessProbe.httpGet.path`        | Readiness probe HTTP GET request (Note: Jira handler is `/status`)                        | `nil`                         |
| `readinessProbe.httpGet.port`        | Readiness probe port (Note: Jira listens on internal port 8080)                           | `nil`                         |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                 | `nil`                         |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                            | `nil`                         |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded | `nil`                         |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                  | `nil`                         |
| `livenessProbe`                      | Liveness probe values                                                                     | `{}`                          |
| `livenessProbe.httpGet.path`         | Liveness probe HTTP GET request (Note: Jira handler is `/status`)                         | `nil`                         |
| `livenessProbe.httpGet.port`         | Liveness probe port (Note: Jira listens on internal port 8080)                            | `nil`                         |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                  | `nil`                         |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                            | `nil`                         |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded | `nil`                         |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                  | `nil`                         |
| `initContainerImages.jdk`            | Image used in the init container when `caCerts` is enabled. Requires `keytool`            | `adoptopenjdk:11-jdk-hotspot` |
| `initContainerImages.postgres`       | Image used in the init container when `postgresql` is enabled. Requires `pg_isready`      | `postgres:9.6.11-alpine`      |

### Persistence parameters

| Parameter                   | Description                                                                   | Default         |
|-----------------------------|-------------------------------------------------------------------------------|-----------------|
| `persistence.enabled`       | Enable persistence using PVC                                                  | `true`          |
| `persistence.existingClaim` | Provide an existing `PersistentVolumeClaim` for Jira, evaluated as a template | `""`            |
| `persistence.accessModes`   | PVC Access Mode for Jira Software volume                                      | `ReadWriteOnce` |
| `persistence.size`          | PVC Storage Request for Jira Software volume                                  | `10Gi`          |
| `persistence.storageClass`  | PVC Storage Class for Jira Software volume                                    | `empty`         |

### RBAC parameters

| Parameter                    | Description                                           | Default |
|------------------------------|-------------------------------------------------------|---------|
| `serviceAccount.create`      | Specifies whether a service account should be created | `false` |
| `serviceAccount.annotations` | Map of service account annotations                    | `{}`    |
| `serviceAcccount.name`       | Name of existing service account                      | `""`    |

### Exposure parameters

| Parameter                   | Description                                                            | Default             |
|-----------------------------|------------------------------------------------------------------------|---------------------|
| `service.type`              | Kubernetes Service type                                                | `ClusterIP`         |
| `service.port`              | Service HTTP port (Note: it must match with `envVars.ATL_TOMCAT_PORT`) | `8080`              |
| `service.httpsPort`         | Service HTTPS port  (Note: needs `envVars.ATL_TOMCAT_SCHEME: https`)   | `empty`             |
| `service.loadBalancer`      | Kubernetes LoadBalancerIP to request                                   | `empty`             |
| `service.nodePorts.http`    | Kubernetes http node port                                              | `""`                |
| `service.nodePorts.https`   | Kubernetes https node port                                             | `""`                |
| `ingress.enabled`           | Enable ingress controller resource                                     | `false`             |
| `ingress.annotations`       | Map of ingress annotations                                             | `{}`                |
| `ingress.hosts[0].host`     | JIra Software installation hostname                                    | `jira-server.local` |
| `ingress.hosts[0].paths`    | Path within the url structure                                          | `[]`                |
| `ingress.tls`               | TLS options                                                            | `[]`                |
| `ingress.tls[0].secretName` | TLS Secret (certificates)                                              | `nil`               |
| `ingress.tls[0].hosts[0]`   | TLS hosts                                                              | `nil`               |


Each parameter can be specified during the Chart installation as follow:

```console
$ helm install my-release \
      --set databaseConnection.host="mydb.example.com" \
      --set databaseConnection.user="test" \
      --set databaseConnection.password="testpass" \
      --set databaseConnection.database="jiradb" \
      --set databaseConnection.port="5432" \
      --set databaseConnection.urlPrefix="jdbc:postgresql" \
      --set databaseConnection.databaseDriver="org.postgresql.Driver" \
      --set databaseConnection.type="postgres72" \
      --set databaseConnection.schemaName="public" \
      mox/jira-software
```

The above command sets the different parameters of the database connection.

Alternatively, a YAML file can be provided to override the default `values.yaml`. For example:

```console
$ helm install my-release -f values-production.yaml mox/jira-software
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
$ echo "ALTER USER jirauser WITH PASSWORD 'test123';" | base64 
QUxURVIgVVNFUiBqaXJhdXNlciBXSVRIIFBBU1NXT1JEICd0ZXN0MTIzJzsK
```

Secret that uses the SQL Query:
```console
$ cat alter-user-passwd.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alter-user-passwd
data:
  alter-passwd.sql: QUxURVIgVVNFUiBqaXJhdXNlciBXSVRIIFBBU1NXT1JEICd0ZXN0MTIzJzsK
```

Create the secret
```console
$ kubectl apply -f alter-user-passwd.yaml
```

### 2. Connect to the database

This chart sets the required environment variables to configure the database connection (`databaseConnection`), avoiding the need to do so through the Jira installation.

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
   mox/jira-software
```

## <a name="remove-existing-database"></a>Remove existing database

It is possible to remove an existing Jira database while deploying. Useful if, e.g. we are installing this Chart in a CI environment.

**Use with caution:**

If `databaseDrop.enabled` is set to `true` and `databaseDrop.dropIt` is set to `yes`, then removes the database specified on `databaseConnection.database`, if it exists.

## <a name="values_values-prod-diff"></a>Difference between values and values-production

Chart Version 2.3.1
```diff
--- jira-software/values.yaml
+++ jira-software/values-production.yaml
@@ -60,7 +60,7 @@
 ## Kubernetes svc configuration
 service:
   ## For minikube, set this to NodePort, elsewhere use LoadBalancer
-  type: ClusterIP
+  type: NodePort
   ## Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank
   ##
   ## Avoid removing the http connector, as the Synchrony proxy health check, still requires HTTP
@@ -100,10 +100,10 @@
 ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
 resources:
   requests:
-    memory: 1Gi
+    memory: 2Gi
     cpu: 500m
-#  limits:
-#    memory: 1Gi
+  limits:
+    memory: 2Gi
 
 ## Replication (without ReplicaSet)
 ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
@@ -211,7 +211,7 @@
   fullnameOverride: jira-software-db
 
   persistence:
-    size: 8Gi
+    size: 20Gi
 
   ## postgres user password (needed when upgrading Chart)
   ## generate random 10 character alphanumeric string if left empty
@@ -301,12 +301,14 @@
 #
 ## Environment Variables that will be injected in the ConfigMap
 ## Default values unless otherwise stated
-envVars: {}
+envVars:
   #
   ## Memory / Heap Size (JVM_MINIMUM_MEMORY) Mandatory, see @Notes above
-  # JVM_MINIMUM_MEMORY: 1024m
+  ## default: 1024m
+  JVM_MINIMUM_MEMORY: 2048m
   ## Memory / Heap Size (JVM_MAXIMUM_MEMORY) Mandatory, see @Notes above
-  # JVM_MAXIMUM_MEMORY: 1024m
+  ## default: 1024m
+  JVM_MAXIMUM_MEMORY: 2048m
   ## The reserved code cache size of the JVM
   # JVM_RESERVED_CODE_CACHE_SIZE: 512m
   #
```

## Changelog

**v1.0.0**
* After 17 releases of the Jira Software Chart it became stable enough to jump to v1.0
* Recent changes:
  - Jira waits for postgres readiness (#e5a0861)
  - Add support to existing secrets

**v2.0.0**
* Support to change init container images in values

## Links

* [Atlassian Jira](https://atlassian.com/software/jira)
* [Helm](https://helm.sh/)
* [mox](https://helm.mox.sh/)
