{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "confluence-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "confluence-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "confluence-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "confluence-server.labels" -}}
helm.sh/chart: {{ include "confluence-server.chart" . }}
{{ include "confluence-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "confluence-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "confluence-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "confluence-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "confluence-server.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create pvc for Confluence home.
*/}}
{{- define "confluence-server.pvcHome" -}}
{{- template "confluence-server.fullname" . -}}-home
{{- end -}}

{{/*
Create pvc for Confluence Attachments.
*/}}
{{- define "confluence-server.pvcAttachments" -}}
{{- template "confluence-server.fullname" . -}}-attachments
{{- end -}}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "confluence-server.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.fullname" $postgresContext }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "confluence-server.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "confluence-server.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Return postgres secret name used in NOTES
*/}}
{{- define "postgresql.secretNameNotes" -}}
{{- if .Values.postgresql.enabled -}}
  {{- if .Values.postgresql.fullnameOverride -}}
    {{- printf "%s" (tpl .Values.postgresql.fullnameOverride $) -}}
  {{- else -}}
    {{- printf "%s" (include "confluence-server.fullname" .) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "confluence-server.createSecret" -}}
{{- if .Values.databaseConnection.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if initContainers are needed
*/}}
{{- define "confluence-server.createInitContainer" -}}
{{- if .Values.postgresql.enabled -}}
    {{- true -}}
{{- else if .Values.caCerts }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret name
*/}}
{{- define "confluence-server.secretName" -}}
{{- if .Values.databaseConnection.existingSecret.name -}}
    {{- printf "%s" (tpl .Values.databaseConnection.existingSecret.name $) -}}
{{- else -}}
    {{- printf "%s" (include "confluence-server.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret key
*/}}
{{- define "confluence-server.secretKey" -}}
{{- if .Values.databaseConnection.existingSecret.key -}}
    {{- printf "%s" (tpl .Values.databaseConnection.existingSecret.key $) -}}
{{- else -}}
    {{- printf "ATL_JDBC_PASSWORD" -}}
{{- end -}}
{{- end -}}