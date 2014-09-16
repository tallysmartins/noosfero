#!/bin/sh

set -e

vagrant up
host=$(vagrant ssh-config | awk '{ if ($1 == "HostName") { print($2) }}')
port=$(vagrant ssh-config | awk '{ if ($1 == "Port") { print($2) }}')
key=$(vagrant ssh-config | awk '{ if ($1 == "IdentityFile") { print($2) }}')

cat > colab/environments.yml <<EOF
dev:
  hosts:
    - $host
  key_filename: $key
  port: $port
  is_vagrant: True
  superuser: 'vagrant'
EOF

sudo apt-get install -qy python-yaml fabric

(
  cd colab
  fab --disable-known-hosts bootstrap
  fab --disable-known-hosts deploy
)
