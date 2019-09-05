# docker-gen ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/poma/docker-gen)

[jwilder/docker-gen](https://github.com/jwilder/docker-gen) with:

- embedded nginx.tmpl file
- support for environment variables
- docker socket by default located in /var/run/docker.sock, same as in letsencrypt companion
- nginx.tmpl updated to accept NGINX_CLIENT_MAX_BODY_SIZE env var per vhost (todo: enumerate `nginx_*` vars per vhost)

Environment variables starting with `nginx_*` are added as nginx config parameters to `/etc/nginx/conf.d/env.conf`, both upper and lower case are supported. Example: `nginx_client_max_body_size=30M`

This fork automatically pulls and rebuilds on Docker Hub on any changes in upstream repo

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
      NGINX_CLIENT_MAX_BODY_SIZE: 30M
    volumes_from:
      - nginx
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: letsencrypt
    restart: always
    environment:
      NGINX_DOCKER_GEN_CONTAINER: dockergen
    volumes_from:
      - nginx
      - dockergen

volumes:
  conf:
  vhost:
  html:
  certs:
```