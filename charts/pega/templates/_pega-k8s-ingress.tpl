{{- define "pega.k8s.ingress" -}}
# Ingress to be used for {{ .name }}
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: {{ .name }}
  namespace: {{ .root.Release.Namespace }}
  annotations:
{{- if .node.ingress.annotations }}
    # Custom annotations
{{ toYaml .node.ingress.annotations | indent 4 }}
{{- else }}
    # Ingress class used is 'traefik'
    kubernetes.io/ingress.class: traefik
{{- end }}
spec:
{{ if ( include "ingressTlsEnabled" . ) }}
{{- if .node.ingress.tls.secretName }}
{{ include "tlssecretsnippet" . }}
{{ end }}
{{ end }}
  rules:
  # The calls will be redirected from {{ .node.domain }} to below mentioned backend serviceName and servicePort.
  # To access the below service, along with {{ .node.domain }}, traefik http port also has to be provided in the URL.
  - host: {{ template "domainName" dict "node" .node }}
    http:
      paths:
      - backend:
          serviceName: {{ .name }}
          servicePort: {{ .node.service.port }}
---     
{{- end }}
