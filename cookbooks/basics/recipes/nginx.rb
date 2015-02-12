cookbook_file '/etc/yum.repos.d/nginx.repo' do
  owner 'root'
  group 'root'
  mode  0644
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
  supports :restart => true
end
