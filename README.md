# docker-gen ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/poma/docker-gen)

[jwilder/docker-gen](https://github.com/jwilder/docker-gen) with:

- embedded nginx.tmpl file
- support for environment variables
- docker socket by default located in /var/run/docker.sock, same as in letsencrypt companion

Environment variables starting with `nginx_*` are added as nginx config parameters to `/etc/nginx/conf.d/env.conf`, both upper and lower case are supported. Example: `nginx_client_max_body_size=30M`