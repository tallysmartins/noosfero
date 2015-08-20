# This cookbook installs a cliente rsyslog

package 'rsyslog' do
	action [:install, :upgrade]
end

template '/etc/rsyslog.conf' do
	source "node/rsyslog.conf.erb"
	owner 'root'
	group 'root'
	mode 0755
end

service 'rsyslog' do
	action [:enable, :restart]
end