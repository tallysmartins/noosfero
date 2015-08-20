# This cookbook installs a server rsyslog

package 'rsyslog' do
	action [:install, :upgrade]
end

template '/etc/rsyslog.conf' do
	source 'server/rsyslog.conf.erb'
	owner 'root'
	group 'root'
	mode 0755
end

service 'rsyslog' do
	action [:enable, :restart]
end