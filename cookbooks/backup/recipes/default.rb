package 'cronie'
package 'rsnapshot'

cookbook_file '/etc/rsnapshot.conf' do
  owner 'root'
  group 'root'
  mode  0644
end

cookbook_file '/usr/local/bin/backup_spb.sh' do
  owner 'root'
  group 'root'
  mode  0755
end

cookbook_file '/etc/cron.d/rsnapshot-spb' do
  owner 'root'
  group 'root'
  mode 0644
end

service 'crond' do
  action [:enable, :restart]
end

