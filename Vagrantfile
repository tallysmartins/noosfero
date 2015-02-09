# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = ENV.fetch("VAGRANT_BOX", 'centos7')
  proxy = ENV['http_proxy'] || ENV['HTTP_PROXY']
  if proxy
    config.vm.provision 'shell', path: 'utils/proxy.sh', args: [proxy]
  end

  config.vm.define 'integration' do |integration|
    integration.vm.network 'private_network', ip: '10.1.1.1'
  end
  config.vm.define 'email' do |email|
    email.vm.network 'private_network', ip: '10.1.1.2'
  end
  config.vm.define 'social' do |social|
    social.vm.network 'private_network', ip: '10.1.1.3'
  end
  config.vm.define 'database' do |database|
    database.vm.network 'private_network', ip: '10.1.1.4'
  end
  config.vm.define 'reverseproxy' do |reverseproxy|
    reverseproxy.vm.network 'private_network', ip: '10.1.1.5'
    reverseproxy.vm.network 'forwarded_port', guest: 80, host: 8080
    reverseproxy.vm.network 'forwarded_port', guest: 443, host: 8443
  end
end
