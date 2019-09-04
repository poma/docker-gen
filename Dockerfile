FROM jwilder/docker-gen

# Make the default docker sock location same as letsencrypt
ENV DOCKER_HOST unix:///var/run/docker.sock:ro

ENV DOWNLOAD_URL https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl
RUN mkdir -p /etc/docker-gen/templates
RUN wget -qO- $DOWNLOAD_URL > /etc/docker-gen/templates/nginx.tmpl
