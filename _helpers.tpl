{{- define "mock-chart.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "mock-chart.fullname" -}}
{{ include "mock-chart.name" . }}-release
{{- end }}
