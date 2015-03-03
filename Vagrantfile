# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = ENV.fetch("VAGRANT_BOX", 'centos7')
  proxy = ENV['http_proxy'] || ENV['HTTP_PROXY']
  if proxy
    config.vm.provision 'shell', path: 'utils/proxy.sh', args: [proxy]
  end

  ips = YAML.load_file('ips.development.yaml')

  config.vm.define 'database' do |database|
    database.vm.network 'private_network', ip: ips['database']
  end
  config.vm.define 'integration' do |integration|
    integration.vm.network 'private_network', ip: ips['integration']
  end
  config.vm.define 'email' do |email|
    email.vm.network 'private_network', ip: ips['email']
  end
  config.vm.define 'social' do |social|
    social.vm.network 'private_network', ip: ips['social']
  end
  config.vm.define 'reverseproxy' do |reverseproxy|
    reverseproxy.vm.network 'private_network', ip: ips['reverseproxy']
  end
end
