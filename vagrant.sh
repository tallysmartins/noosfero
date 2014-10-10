#!/bin/sh

set -e
cd /vagrant

# colab
sh ./colab/vagrant/bootstrap.sh
sudo -u vagrant sh ./colab/vagrant/provision.sh
