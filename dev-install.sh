#!/bin/sh

set -e

vagrant up

if [ -z "$http_proxy" ]; then
  http_proxy=$(vagrant ssh -- sh -c '. /etc/profile.d/http_proxy.sh 2>/dev/null; echo $http_proxy')
fi

if [ -z "$http_proxy" ]; then
  printf "HTTP Proxy[none]: "
  read http_proxy
fi

if [ -n "$http_proxy" ]; then
  vagrant ssh -- sudo /vagrant/proxy.sh $http_proxy
  export http_proxy
fi

host=$(vagrant ssh-config | awk '{ if ($1 == "HostName") { print($2) }}')
port=$(vagrant ssh-config | awk '{ if ($1 == "Port") { print($2) }}')
key=$(vagrant ssh-config | awk '{ if ($1 == "IdentityFile") { print($2) }}')

cat > colab/environments.json <<EOF
{
  "dev": {
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
