if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/mailman.repo' do
    action :delete
  end
end

package 'fcgiwrap'
package 'spawn-fcgi'

#######################################################################
# SELinux: allow nginx to connect to the fcgiwrap socket
#######################################################################
cookbook_file '/etc/selinux/local/spb_mailman.te' do
  notifies :run, 'execute[selinux-mailman]'
end
execute 'selinux-mailman' do
  command 'selinux-install-module /etc/selinux/local/spb_mailman.te'
  action :nothing
end
#######################################################################

hostname = node['config']['lists_hostname']
template "/etc/nginx/conf.d/#{hostname}.conf" do
  source 'mailman.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end

cookbook_file '/etc/sysconfig/spawn-fcgi' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[spawn-fcgi]'
end

group 'apache' do
  action 'manage'
  append true
  members ['nginx']
  notifies :restart, 'service[nginx]'
end

service 'spawn-fcgi' do
  action [:enable, :start]
  supports :restart => true
end
