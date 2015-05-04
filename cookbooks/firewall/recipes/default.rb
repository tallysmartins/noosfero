
package 'iptables-services'

service 'iptables' do
  action [:enable, :start]
  supports :restart => true
end

template '/etc/sysconfig/iptables' do
  owner 'root'
  group 'root'
  mode  0644
  notifies :restart, 'service[iptables]'
end
