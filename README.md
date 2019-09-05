# docker-gen ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/poma/docker-gen)

[jwilder/docker-gen](https://github.com/jwilder/docker-gen) with:

- embedded nginx.tmpl file
- support for environment variables
- docker socket by default located in /var/run/docker.sock, same as in letsencrypt companion

Environment variables starting with `nginx_*` are added as nginx config, for example: `nginx_client_max_body_size=30M`. Variables of docker-gen container are added to global config, and variables on others containers area added to the respective vhosts. Currently only lower case variables are supported.

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
      nginx_client_max_body_size: 42M
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

  app:
    image: app
    environment:
      VIRTUAL_HOST: example.com
      LETSENCRYPT_HOST: example.com
      nginx_client_max_body_size: 1337M

volumes:
  conf:
  vhost:
  html:
  certs:
```