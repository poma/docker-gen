#!/bin/bash
shopt -s nocasematch
config=""
newline=$'\n'
while IFS='=' read -r name value; do
  if [[ $name == 'nginx_'* ]]; then
    lowercase=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    identifier=${lowercase#nginx_}
    config+="$identifier ${!name};$newline"
  fi
done < <(env)
mkdir -p /etc/nginx/conf.d
echo "Generated config:"
echo "$config"
echo "$config" > /etc/nginx/conf.d/env.conf

exec "/usr/local/bin/docker-gen $@"