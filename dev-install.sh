#!/bin/sh

set -e

vagrant up
host=$(vagrant ssh-config | awk '{ if ($1 == "HostName") { print($2) }}')
port=$(vagrant ssh-config | awk '{ if ($1 == "Port") { print($2) }}')
key=$(vagrant ssh-config | awk '{ if ($1 == "IdentityFile") { print($2) }}')

if [ -n "$http_proxy" ]; then
  proxy="\"command_prefixes\": [\"http_proxy='$http_proxy'\"],"
else
  proxy=
fi

cat > colab/environments.json <<EOF
{
  "dev": {
    $proxy
    "hosts": ["$host"],
    "key_filename": "$key",
    "port": "$port",
    "is_vagrant": true,
    "superuser": "vagrant"
  }
}
EOF

dpkg-query --show fabric >/dev/null || sudo apt-get install -qy fabric

(
  cd colab
  fab --disable-known-hosts bootstrap
  fab --disable-known-hosts deploy
)
