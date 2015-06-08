# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

load './local.rake' if File.exists?('local.rake')

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = ENV.fetch("VAGRANT_BOX", 'chef/centos-7.0')
  proxy = ENV['http_proxy'] || ENV['HTTP_PROXY']
  if proxy
    config.vm.provision 'shell', path: 'utils/proxy.sh', args: [proxy]
  end

  env = ENV.fetch('SPB_ENV', 'local')

  if File.exist?("config/#{env}/ips.yaml")
    ips = YAML.load_file("config/#{env}/ips.yaml")
  else
    ips = nil
  end

  config.vm.define 'database' do |database|
    database.vm.provider "virtualbox" do |vm|
      database.vm.network 'private_network', ip: ips['database'] if ips
    end
  end
  config.vm.define 'integration' do |integration|
    integration.vm.provider "virtualbox" do |vm|
      integration.vm.network 'private_network', ip: ips['integration'] if ips
      vm.memory = 1024
      vm.cpus = 2
    end
  end
  config.vm.define 'email' do |email|
    email.vm.provider "virtualbox" do |vm|
      email.vm.network 'private_network', ip: ips['email'] if ips
    end
  end
  config.vm.define 'social' do |social|
    social.vm.provider "virtualbox" do |vm|
      social.vm.network 'private_network', ip: ips['social'] if ips
    end
  end
  config.vm.define 'reverseproxy' do |reverseproxy|
    reverseproxy.vm.provider "virtualbox" do |vm|
      reverseproxy.vm.network 'private_network', ip: ips['reverseproxy'] if ips
    end
    if File.exist?("tmp/preconfig.#{env}.stamp")
      reverseproxy.ssh.port =  File.read("tmp/preconfig.#{env}.stamp").strip.to_i
      reverseproxy.ssh.host = ips['reverseproxy']
    end
  end
end
