{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "crowd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "crowd.fullname" -}}
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
{{- define "crowd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "crowd.labels" -}}
helm.sh/chart: {{ include "crowd.chart" . }}
{{ include "crowd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "crowd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crowd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "crowd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "crowd.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create pvc for Crowd home.
*/}}
{{- define "crowd.pvcHome" -}}
{{- template "crowd.fullname" . -}}-home
{{- end -}}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "crowd.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.fullname" $postgresContext }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "crowd.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "crowd.tplValue" -}}
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
    {{- printf "%s" (include "crowd.fullname" .) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "crowd.createSecret" -}}
{{- if .Values.databaseConnection.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if initContainers are needed
*/}}
{{- define "crowd.createInitContainer" -}}
{{- if .Values.postgresql.enabled -}}
    {{- true -}}
{{- else if .Values.caCerts }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret name
*/}}
{{- define "crowd.secretName" -}}
{{- if .Values.databaseConnection.existingSecret.name -}}
    {{- printf "%s" (tpl .Values.databaseConnection.existingSecret.name $) -}}
{{- else -}}
    {{- printf "%s" (include "crowd.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the secret key
*/}}
{{- define "crowd.secretKey" -}}
{{- if .Values.databaseConnection.existingSecret.key -}}
    {{- printf "%s" (tpl .Values.databaseConnection.existingSecret.key $) -}}
{{- else -}}
    {{- printf "ATL_JDBC_PASSWORD" -}}
{{- end -}}
{{- end -}}