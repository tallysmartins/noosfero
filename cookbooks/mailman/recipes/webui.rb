if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/mailman.repo' do
    owner 'root'
    mode 0644
  end
end

package 'fcgiwrap'
package 'spawn-fcgi'

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

service 'spawn-fcgi' do
  action [:enable, :start]
  supports :restart => true
end
