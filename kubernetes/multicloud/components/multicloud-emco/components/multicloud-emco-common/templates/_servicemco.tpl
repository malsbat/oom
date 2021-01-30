{{/*
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
*/}}
{{- define "multicloud-emco.servicemco" -}}
{{- $common := dict "Values" .Values.common -}}
{{- $noCommon := omit .Values "common" -}}
{{- $overrides := dict "Values" $noCommon -}}
{{- $noValues := omit . "Values" -}}
{{- with merge $noValues $overrides $common -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.servicename" . }}
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
  - name: {{ .Values.service.PortName }}
    {{if eq .Values.service.type "NodePort" -}}
    port: {{ .Values.service.internalPort }}
    nodePort: {{ .Values.global.nodePortPrefixExt | default "302" }}{{ .Values.service.nodePort }}
    {{- else -}}
    port: {{ .Values.service.externalPort }}
    targetPort: {{ .Values.service.internalPort }}
    {{- end}}
    protocol: TCP
  selector: {{ include "common.matchLabels" . | nindent 4 }}
{{- end -}}
{{- end -}}