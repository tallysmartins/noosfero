package 'iptables-services'

service 'iptables' do
  action :enable
  supports :restart => true
end

template '/etc/sysconfig/iptables' do
  owner 'root'
  group 'root'
  mode  0644
  notifies :restart, 'service[iptables]'
end

cookbook_file "/etc/nginx/#{node['config']['external_hostname']}.crt" do
  owner 'root'
  group 'root'
  mode 0600
  notifies :restart, 'service[nginx]'
end

cookbook_file "/etc/sysctl.d/ip_forward.conf" do
  owner 'root'
  group 'root'
  mode 0644
end

execute 'sysctl -w net.ipv4.ip_forward=1'

cookbook_file "/etc/nginx/#{node['config']['external_hostname']}.key" do
  owner 'root'
  group 'root'
  mode 0600
  notifies :restart, 'service[nginx]'
end

template '/etc/nginx/conf.d/reverse_proxy.conf' do
  owner 'root'
  group 'root'
  mode  0644
  notifies :restart, 'service[nginx]'
end
