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
