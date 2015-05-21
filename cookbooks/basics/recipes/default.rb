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

cookbook_file '/usr/local/bin/selinux-enabled' do
  owner   'root'
  group   'root'
  mode    '0755'
end

execute 'setenforce Enforcing' do
  only_if 'selinux-enabled'
end
execute 'setsebool httpd_can_network_connect 1' do
  only_if 'selinux-enabled'
end
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

cookbook_file '/usr/local/bin/is-a-container' do
  owner   'root'
  group   'root'
  mode    '0755'
end
service 'ntpd' do
  action [:enable, :start]
  not_if 'is-a-container'
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

template '/etc/hosts' do
  owner 'root'
  mode  0644
end
