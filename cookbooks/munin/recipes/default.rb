package 'munin'

template '/etc/munin/conf.d/hosts.conf'

package 'nginx'
service 'nginx' do
  supports :reload => true
end
cookbook_file '/etc/nginx/default.d/munin.conf' do
  source 'nginx.conf'
  notifies :reload, 'service[nginx]'
end
