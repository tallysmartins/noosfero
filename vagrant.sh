#!/bin/sh

set -e
cd /vagrant

# colab
sh ./colab/vagrant/bootstrap.sh
sh ./colab/vagrant/provision.sh
