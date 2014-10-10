# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos6"

  proxy = ENV['http_proxy'] || ENV['HTTP_PROXY']
  if proxy
    config.vm.provision 'shell', path: 'proxy.sh', args: [proxy]
  end

  config.vm.provision 'shell', path: 'vagrant.sh'
end
