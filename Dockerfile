FROM jwilder/docker-gen
# https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl
COPY nginx.tmpl /etc/docker-gen/templates/nginx.tmpl