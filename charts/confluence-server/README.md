# Atlassian Confluence Server

[Confluence](https://www.atlassian.com/software/confluence) is a collaboration software program developed and published by the australian software company **Atlassian**.

## TL;DR;

All commands below are Helm v3

```console
$ helm repo add mox https://helm.mox.sh
$ helm repo update
$ helm install my-release mox/confluence-server
```

## Introduction

This chart bootstraps a [Confluence server](https://hub.docker.com/r/atlassian/confluence-server/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It is available on:
 * https://helm.mox.sh
 * https://hub.helm.sh/charts/mox/confluence-server
 * https://artifacthub.io/package/chart/mox/confluence-server

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
$ helm install my-release mox/confluence-server
```

The command deploys **Confluence server** on the Kubernetes cluster in the default configuration. The [configuration parameters](#parameters) section lists the parameters that can be configured during installation.

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

Otherwise, see [Upgrade Confluence server with PostgreSQL enabled](#upgrade-with-postgres-enabled) for more details.

## PostgreSQL enabled

This chart deploys **by default** a [bitnami PostgreSQL](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) instance.

### <a name="install-with-postgres-enabled"></a>Install Confluence server with PostgreSQL enabled

PostgreSQL Chart from **bitnami** generates a random password if we do not specify one. Random or not, keep the password safe because it will be needed when upgrading Confluence.

To specify a password:
```console
$ helm install my-release \
     --set global.postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set global.postgresql.replicationPassword=[REPLICATION_PASSWORD] # in case Replication is enabled \
     mox/confluence-server
```

### <a name="uninstall-with-postgres-enabled"></a>Uninstall Confluence server with PostgreSQL enabled

The Persistent Volume Claim (PVC) of postgres will **NOT** be automatically deleted. It needs to be removed manually.

### <a name="upgrade-with-postgres-enabled"></a>Upgrade Confluence server with PostgreSQL enabled

From [bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#upgrade):
> It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords.

We upgrade the `my-release` deployment by running:

```console
$ helm upgrade my-release \
     --set postgresql.postgresqlPassword=[POSTGRESQL_PASSWORD] \
     --set postgresql.replication.password=[REPLICATION_PASSWORD] # in case Replication is enabled
```

## Parameters

The following tables lists the configurable parameters of the Confluence Server chart and their default values.

|                   Parameter                   |                                                                                Description                                                                                |                            Default                            |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| `image.registry`                              | Confluence Server Image registry                                                                                                                                          | `docker.io`                                                   |
| `image.repository`                            | Confluence Server Image name                                                                                                                                              | `atlassian/confluence-server`                                 |
| `image.tag`                                   | Confluence Server Image tag                                                                                                                                               | `{TAG_NAME}`                                                  |
| `image.pullPolicy`                            | Confluence Server Image pull policy                                                                                                                                       | `IfNotPresent`                                                |
| `image.pullSecrets`                           | Secrets to pull an image from a private Docker registry or repository                                                                                                     | `{}`                                                          |
| `nameOverride`                                | String to partially override confluence-server.fullname template with a string (will prepend the release name)                                                            | `""`                                                          |
| `fullnameOverride`                            | String to fully override confluence-server.fullname template with a string                                                                                                | `""`                                                          |
| `serviceAccount.create`                       | Specifies whether a service account should be created                                                                                                                     | `false`                                                       |
| `serviceAccount.annotations`                  | Map of service account annotations                                                                                                                                        | `{}`                                                          |
| `serviceAcccount.name`                        | Name of existing service account                                                                                                                                          | `""`                                                          |
| `podSecurityContext.fsGroup`                  | All processes of the container are also part of this supplementary group ID                                                                                               | `2002`                                                        |
| `securityContext`                             | Container security context options                                                                                                                                        | `{}`                                                          |
| `service.type`                                | Kubernetes Service type                                                                                                                                                   | `nodePort`                                                    |
| `service.port`                                | Service HTTP port (Note: it must match with `envVars.ATL_TOMCAT_PORT`)                                                                                                    | `8090`                                                        |
| `service.httpsPort`                           | Service HTTPS port  (Note: needs `envVars.ATL_TOMCAT_SCHEME: https`)                                                                                                      | `empty`                                                       |
| `service.loadBalancer`                        | Kubernetes LoadBalancerIP to request                                                                                                                                      | `empty`                                                       |
| `service.nodePorts.http`                      | Kubernetes http node port                                                                                                                                                 | `""`                                                          |
| `service.nodePorts.https`                     | Kubernetes https node port                                                                                                                                                | `""`                                                          |
| `ingress.enabled`                             | Enable ingress controller resource                                                                                                                                        | `false`                                                       |
| `ingress.annotations`                         | Map of ingress annotations                                                                                                                                                | `{}`                                                          |
| `ingress.hosts[0].host`                       | Confluence Server installation hostname                                                                                                                                   | `confluence-server.local`                                     |
| `ingress.hosts[0].paths`                      | Path within the url structure                                                                                                                                             | `[]`                                                          |
| `ingress.tls`                                 | TLS options                                                                                                                                                               | `[]`                                                          |
| `ingress.tls[0].secretName`                   | TLS Secret (certificates)                                                                                                                                                 | `nil`                                                         |
| `ingress.tls[0].hosts[0]`                     | TLS hosts                                                                                                                                                                 | `nil`                                                         |
| `resources`                                   | CPU/Memory resource requests/limits                                                                                                                                       | Memory: `1Gi`, CPU: `500m`                                    |
| `replicaCount`                                | Number of replicas for this deployment                                                                                                                                    | `1`                                                           |
| `nodeSelector`                                | Node labels for pod assignment                                                                                                                                            | `{}`                                                          |
| `tolerations`                                 | List of node taints to tolerate                                                                                                                                           | `[]`                                                          |
| `affinity`                                    | Map of node/pod affinity labels                                                                                                                                           | `{}`                                                          |
| `podAnnotations`                              | Map of annotations to add to the pods                                                                                                                                     | `{}`                                                          |
| `persistence.enabled`                         | Enable persistence using PVC                                                                                                                                              | `true`                                                        |
| `persistence.existingClaim`                   | Provide an existing `PersistentVolumeClaim` for the Confluence Server, the value is evaluated as a template                                                               | `""`                                                          |
| `persistence.accessModes`                     | PVC Access Mode for Confluence Server volume                                                                                                                              | `ReadWriteOnce`                                               |
| `persistence.size`                            | PVC Storage Request for Confluence Server volume                                                                                                                          | `10Gi`                                                        |
| `persistence.storageClass`                    | PVC Storage Class for Confluence Server volume                                                                                                                            | `empty` (uses alpha storage annotation)                       |
| `mountAttachments.enabled`                    | Enable persistence using PVC for the attachments directory. By default, the Attachments are stored with Confluence Server PVC if `persistence.enabled` is set to true     | `false`                                                       |
| `mountAttachments.existingClaim`              | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template                                                                                         | `""`                                                          |
| `mountAttachments.accessModes`                | PVC Access Mode for Confluence Server Attachments volume                                                                                                                  | `ReadWriteOnce`                                               |
| `mountAttachments.size`                       | PVC Storage Request for Confluence Server Attachments volume                                                                                                              | `20Gi`                                                        |
| `mountAttachments.storageClass`               | PVC Storage Class for Confluence Server Attachments volume                                                                                                                | `empty` (uses alpha storage annotation)                       |
| `extraVolumeMounts`                           | Additional volume mounts to add to the pods                                                                                                                               | `[]`                                                          |
| `extraVolumes`                                | Additional volumes to add to the pods                                                                                                                                     | `[]`                                                          |
| `vaultSecrets.enabled`                        | Enable pulling secrets for the database connection from Vault                                                                                                             | `false`                                                       |
| `vaultSecrets.secret`                         | Vault secret name                                                                                                                                                         | `""`                                                          |
| `vaultSecrets.host`                           | Vault secret Hostname of the database server (Note: anchor used by `databaseConnection.host`)                                                                             | &host `""`                                                    |
| `vaultSecrets.db`                             | Vault secret Confluence database name (Note: anchor used by `databaseConnection.database`)                                                                                | &db `""`                                                      |
| `vaultSecrets.user`                           | Vault secret Confluence database user (Note: anchor used by `databaseConnection.user`)                                                                                    | &db-user `""`                                                 |
| `vaultSecrets.pw`                             | Vault secret Confluence database password (Note: anchor used by `databaseConnection.password`)                                                                            | &db-pw `""`                                                   |
| `schedulerName`                               | Use an alternate scheduler, eg. `stork`                                                                                                                                   | `""`                                                          |
| `readinessProbe`                              | Readiness probe values                                                                                                                                                    | `{}`                                                          |
| `readinessProbe.httpGet.path`                 | Readiness probe HTTP GET request (Note: Confluence handler is `/status`)                                                                                                  | `nil`                                                         |
| `readinessProbe.httpGet.port`                 | Readiness probe port (Note: Confluence listens on internal port 8090)                                                                                                     | `nil`                                                         |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated                                                                                                                                 | `nil`                                                         |
| `readinessProbe.periodSeconds`                | How often to perform the probe                                                                                                                                            | `nil`                                                         |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                | `nil`                                                         |
| `readinessProbe.timeoutSeconds`               | When the probe times out                                                                                                                                                  | `nil`                                                         |
| `livenessProbe`                               | Liveness probe values                                                                                                                                                     | `{}`                                                          |
| `livenessProbe.httpGet.path`                  | Liveness probe HTTP GET request (Note: Confluence handler is `/status`)                                                                                                   | `nil`                                                         |
| `livenessProbe.httpGet.port`                  | Liveness probe port (Note: Confluence listens on internal port 8090)                                                                                                      | `nil`                                                         |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated                                                                                                                                  | `nil`                                                         |
| `livenessProbe.periodSeconds`                 | How often to perform the probe                                                                                                                                            | `nil`                                                         |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                | `nil`                                                         |
| `livenessProbe.timeoutSeconds`                | When the probe times out                                                                                                                                                  | `nil`                                                         |
| `postgresql.enabled`                          | Whether to use the PostgreSQL chart                                                                                                                                       | `true`                                                        |
| `postgresql.image.registry`                   | PostgreSQL image registry                                                                                                                                                 | `docker.io`                                                   |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                                                                                                               | `bitnami/postgresql`                                          |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                                                                                                                      | `10`                                                          |
| `postgresql.image.pullPolicy`                 | PostgreSQL image pull policy                                                                                                                                              | `IfNotPresent`                                                |
| `postgresql.fullnameOverride`                 | String to fully override postgresql.fullname template with a string                                                                                                       | `confluence-server-db`                                        |
| `postgresql.persistence.size`                 | PVC Storage Request for PostgreSQL volume                                                                                                                                 | `nil`                                                         |
| `postgresql.initdbScriptsConfigMap`           | ConfigMap with the initdb scripts (Note: Overrides initdbScripts). The value is evaluated as a template.                                                                  | `{{ .Release.Name }}-db-helper-cm`                            |
| `databaseConnection.host`                     | Hostname of the database server (Note: values-production uses the anchor of `vaultSecrets.host`.                                                                          | `confluence-server-db`                                        |
| `databaseConnection.user`                     | Confluence database user (Note: values-production uses the anchor of `vaultSecrets.user`)                                                                                 | `confluence-user`                                             |
| `databaseConnection.password`                 | Confluence database password (Note: values-production uses the anchor of `vaultSecrets.pw`)                                                                               | `""`                                                          |
| `databaseConnection.database`                 | Confluence database name (Note: values-production uses the anchor of `vaultSecrets.db`)                                                                                   | `confluence-db`                                               |
| `databaseConnection.lang`                     | Encoding used for lc_ctype and lc_collate in case the database needs to be created (See: `postgresql.initdbScriptsConfigMap`)                                             | `C`                                                           |
| `databaseConnection.port`                     | Confluence database server port                                                                                                                                           | `5432`                                                        |
| `databaseConnection.type`                     | Confluence database server type                                                                                                                                           | `postgresql`                                                  |
| `databaseDrop.enabled`                        | Enable database removal. See [remove existing database](#remove-existing-database)                                                                                        | `false`                                                       |
| `databaseDrop.dropIt`                         | Confirm database removal if set to `yes`                                                                                                                                  | `no`                                                          |
| `caCerts.secret`                              | Secret that will be imported into the keystore using keytool                                                                                                              | `nil`                                                         |
| `caCerts.storepass`                           | Keytool store password (storepass parameter)                                                                                                                              | `nil`                                                         |
| `caCertsEnv`                                  | Any environment variable you would like to pass on to the OpenJDK init container. The value is evaluated as a template                                                    | `nil`                                                         |
| `envVars`                                     | Confluence Server environment variables that will be injected in the ConfigMap. The value is evaluated as a template                                                      | `{}`                                                          |
| `extraEnv`                                    | Enable additional Confluence Server container environment variables. The value is passed as string                                                                        | `nil`                                                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
      --set databaseConnection.host="mydb.example.com" \
      --set databaseConnection.user="test" \
      --set databaseConnection.password="testpass" \
      --set databaseConnection.database="confluence" \
      --set databaseConnection.port="5432" \
      --set databaseConnection.type="postgresql"
      mox/confluence-server
```

The above command sets the different parameters of the database connection.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```console
$ helm install my-release -f values-production.yaml mox/confluence-server
```

## <a name="remove-existing-database"></a>Remove existing database

It is possible to remove an existing Confluence database while deploying. Useful if, e.g. we are installing this Chart in a CI environment.

**Use with caution:**

If `databaseDrop.enabled` is set to `true` and `databaseDrop.dropIt` is set to `yes`, then removes the database specified on `databaseConnection.database`, if it exists.

```console
$ helm upgrade --install my-release \
      --set databaseDrop.enabled=true \
      --set databaseDrop.dropIt="yes" \
      mox/confluence-server
```

## <a name="values_values-prod-diff"></a>Difference between values and values-production

```console
--- confluence-server/values.yaml
+++ confluence-server/values-production.yaml
@@ -58,7 +58,7 @@
 ## Kubernetes svc configuration
 service:
   ## For minikube, set this to NodePort, elsewhere use LoadBalancer
-  type: ClusterIP
+  type: NodePort
   ## Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank
   ##
   ## Avoid removing the http connector, as the Synchrony proxy health check, still requires HTTP
@@ -98,10 +98,10 @@
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
@@ -145,11 +145,11 @@
 ## Persistent Volume CLaim
 ## Confluence Attachments directory
 mountAttachments:
-  enabled: false
+  enabled: true
   ## existingClaim needs the existing PVC name
   existingClaim: ""
   accessMode: ReadWriteOnce
-  size: 20Gi
+  size: 50Gi
 
   ## If defined, storageClassName: <storageClass>
   ## If set to "-", storageClassName: "", which disables dynamic provisioning
@@ -179,8 +179,8 @@
 ## Pull ecrets for the DB connection from Vault  (here we use anchors, see databaseConnection)
 ## Change double-quoted values if enabled is set to 'true'
 vaultSecrets:
-  enabled: false
-  secret: ""
+  enabled: true
+  secret: "mysecret-confluence-server"
   host: &host "${myvault.secrets.confluence-server-db-host}"
   db: &db "${myvault.secrets.confluence-server-db}"
   user: &db-user "${myvault.secrets.confluence-server-db-user}"
@@ -238,8 +238,8 @@
 
   fullnameOverride: confluence-server-db
 
-  persistence:
-    size: 8Gi
+  # persistence:
+  #   size: 8Gi
 
   initdbScriptsConfigMap: |-
     {{ .Release.Name }}-db-helper-cm
@@ -250,23 +250,23 @@
 ## If vaultSecrets.enabled is false, replace values below in plaintext,
 ## password will be send to externaldb-secrets
 ##
-## Aliases disabled, not using vaultSecrets anchors.
+## Aliases enabled, using vaultSecrets anchors.
 databaseConnection:
   ## Database host
-  # host: *host
-  host: confluence-server-db
+  # host: confluence-server-db
+  host: *host
 
   ## non-root Username for Confluence Database
-  # user: *db-user
-  user: confluenceuser
+  # user: confluenceuser
+  user: *db-user
 
   ## Database password
-  # password: *db-pw
-  password: ""
+  # password: ""
+  password: *db-pw
 
   ## Database name
-  # database: *db
-  database: confluencedb
+  # database: confluencedb
+  database: *db
 
   ## lc_collate and lc_ctype, only in case database needs to be created
   lang: C
@@ -299,13 +299,13 @@
 #
 ## Environment Variables that will be injected in the ConfigMap
 ## Default values unless otherwise stated
-envVars: {}
+envVars:
   ## Memory / Heap Size (JVM_MINIMUM_MEMORY) Mandatory, see @Notes above
   ## default: 1024m
-  # JVM_MINIMUM_MEMORY: 2048m
+  JVM_MINIMUM_MEMORY: 2048m
   ## Memory / Heap Size (JVM_MAXIMUM_MEMORY) Mandatory, see @Notes above
   ## default: 1024m
-  # JVM_MAXIMUM_MEMORY: 2048m
+  JVM_MAXIMUM_MEMORY: 2048m
   #
   ## Tomcat and Reverse Proxy Settings
   ## Confluence running behind a reverse proxy server options
```

## Links

* [Atlassian Confluence](https://confluence.atlassian.com/confeval/confluence-evaluator-resources/confluence-features-functions)
* [Helm](https://helm.sh/)
* [mox](https://helm.mox.sh/)
