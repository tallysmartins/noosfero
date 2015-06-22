if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/mailman-api.repo' do
    action :delete
  end
end

package 'mailman-api'

service 'mailman-api' do
  action [:enable, :start]
  supports :restart => true
end
