if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/mailman-api.repo' do
    owner 'root'
    mode 0644
  end
end

package 'mailman-api'
