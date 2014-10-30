#!/bin/sh

set -e

if [ -x /usr/bin/apt-get ]; then
  os='debian'
fi

if [ -x /usr/bin/yum ]; then
  os='centos'
fi

for script in $(find /vagrant/vagrant.d -name '*-generic' -or -name "*-$os" | sort); do
  (
    set -x
    $script
  )
done
