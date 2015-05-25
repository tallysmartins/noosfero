# enable EPEL repository by default
package 'epel-release'

# replicate production security setup
package 'selinux-policy'
package 'policycoreutils-python'
cookbook_file '/etc/selinux/config' do
  source  'selinux_config'
  owner   'root'
  group   'root'
  mode    0644
end
execute 'setenforce Enforcing'
execute 'setsebool httpd_can_network_connect 1'
# directory for local type enforcements
directory '/etc/selinux/local' do
  owner   'root'
  group   'root'
  mode    '0755'
end
cookbook_file '/usr/local/bin/selinux-install-module' do
  owner   'root'
  group   'root'
  mode    '0755'
end

package 'vim'
package 'bash-completion'
package 'rsyslog'
package 'tmux'
package 'less'
package 'htop'
package 'ntp'

service 'ntpd' do
  action [:enable, :start]
end

service 'firewalld' do
  action [:disable, :stop]
  ignore_failure true
end

service 'sshd' do
  action [:enable]
end

# FIXME on Debian it's postgresql-client
package 'postgresql'

# key for our custom repositories
if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/softwarepublico.key' do
    owner 'root'
    mode 0644
  end
end

# reload node[:fqdn] to make sure it reflects the contents of /etc/hosts
# without that the variable :fqdn would not be available on first run
ruby_block 'fqdn:update' do
  block do
    node.default[:fqdn] = `hostname --fqdn`.strip
  end
  action :nothing
end

template '/etc/hosts' do
  owner 'root'
  mode  0644
  notifies :run, 'ruby_block[fqdn:update]', :immediately
end
