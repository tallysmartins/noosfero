package 'vim'
package 'bash-completion'
package 'rsyslog'

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
