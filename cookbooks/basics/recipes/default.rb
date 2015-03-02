package 'vim'
package 'bash-completion'
package 'rsyslog'
package 'tmux'
package 'less'

# FIXME on Debian it's postgresql-client
package 'postgresql'

# enable EPEL repository by default
package 'epel-release'

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
