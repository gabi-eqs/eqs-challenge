{{/* Define the main NGINX configuration */}}
{{- define "nginx.nginxMainConf" -}}

user  nginx;
worker_processes  {{ .Values.nginx.numWorkerProcesses }};

error_log stderr {{ .Values.nginx.logLevel }};

pid /var/run/nginx.pid;

events {
    worker_connections  {{ .Values.nginx.numWorkerConnections }};
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile      on;

    keepalive_timeout {{ .Values.nginx.timeouts.keepaliveTimeout }};
    {{ if .Values.nginx.gzip }}
       gzip {{ .Values.nginx.gzip }};
    {{ else }}
       gzip off;
    {{ end }}
    server_tokens off;
    tcp_nodelay on;
    include /etc/nginx/conf.d/*.conf;
}
   
{{- end -}}
