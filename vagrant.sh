#!/bin/sh

set -e

if [ -x /usr/bin/apt-get ]; then
  regex='debian|generic'
fi

if [ -x /usr/bin/yum ]; then
  regex='centos|generic'
fi

run-parts --exit-on-error --regex="$regex" /vagrant/vagrant.d
