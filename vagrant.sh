#!/bin/sh

set -e

# colab
sh /vagrant/colab/vagrant/bootstrap.sh
sudo -u vagrant -i sh /vagrant/colab/vagrant/provision.sh
