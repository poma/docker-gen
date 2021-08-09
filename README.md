# docker-gen [![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/poma/docker-gen.svg)](https://hub.docker.com/r/poma/docker-gen/builds)

[nginx-proxy/docker-gen](https://github.com/nginx-proxy/docker-gen) with:

- embedded `nginx.tmpl` file
- support for `NGINX_*` environment variables
- docker socket by default located in `/var/run/docker.sock`, same as in letsencrypt companion

Environment variables starting with `NGINX_*` are added as nginx config entries, for example: `NGINX_CLIENT_MAX_BODY_SIZE=30M`. Variables of docker-gen container are added to global config, and variables on others containers are added to the respective vhosts.

This fork automatically pulls and rebuilds Docker Hub image on any changes in the upstream repo

Example docker file:

```yaml
version: '2.1'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx
    restart: always
    ports:
      - 80:80
      - 443:443
    volumes:
      - conf:/etc/nginx/conf.d
      - vhost:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
      - certs:/etc/nginx/certs

  dockergen:
    image: poma/docker-gen
    container_name: dockergen
    restart: always
    command: -notify-sighup nginx -watch /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
    environment:
      NGINX_CLIENT_MAX_BODY_SIZE: 42M
    volumes_from:
      - nginx
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  acme:
    image: nginxproxy/acme-companion
    container_name: acme
    restart: always
    environment:
      NGINX_DOCKER_GEN_CONTAINER: dockergen
    volumes_from:
      - nginx
      - dockergen
    volumes:
      - acme:/etc/acme.sh

  app:
    image: app
    environment:
      VIRTUAL_HOST: example.com
      LETSENCRYPT_HOST: example.com
      NGINX_CLIENT_MAX_BODY_SIZE: 1337M
      NGINX_CLIENT_BODY_BUFFER_SIZE: 128k

volumes:
  conf:
  vhost:
  html:
  certs:
  acme:
```
