{{/*
My first time trying to use include's/template's in Helm, so I'm referencing
https://helm.sh/docs/chart_template_guide/named_templates/
*/}}

{{- define "example.fullname" }}
{{ default .Values.example.fullname }}
{{- end }}

{{- define "example.labels" }}
{{ default toYaml .Values.example.labels }}
{{- end }}

{{- define "example.selectorLabels" }}
{{ default toYaml .Values.example.selectorLabels }}
{{- end }}

{{- define "example.serviceAccountName" }}
{{ default .Values.example.serviceAccountName }}
{{- end }}