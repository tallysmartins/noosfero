# This cookbook installs a server rsyslog

package 'rsyslog' do
  action [:install, :upgrade]
end

template '/etc/rsyslog.d/server.conf' do
  source 'server/server.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

service 'rsyslog' do
  action [:enable, :restart]
end
