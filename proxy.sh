#!/bin/sh

set -e

if [ -n "$1" ]; then
  http_proxy="$1"
fi

if [ -z "$http_proxy" ]; then
  echo "No http_proxy in command line or environment!"
  echo
  echo "usage: $0 [HTTP_PROXY]"
  exit 1
fi

cat > /etc/profile.d/http_proxy.sh<<EOF
export http_proxy='$http_proxy'
export HTTP_PROXY='$http_proxy'
EOF

if test -f /etc/yum.conf; then
  sed -i -e '/proxy=/d; /http_caching=/ d' /etc/yum.conf
  sed -i -s '/\[main\]/ a http_caching=packages' /etc/yum.conf
  sed -i -s '/\[main\]/ a proxy='$http_proxy /etc/yum.conf

  sed -i -e 's/^enabled=.*/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf

  if [ ! -f /var/tmp/yum-clean.stamp ]; then
    pgrep -f yum || yum clean all || true
    touch /var/tmp/yum-clean.stamp
  fi
fi
