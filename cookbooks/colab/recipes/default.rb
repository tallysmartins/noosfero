# TODO colab and mailman-api should be able to run in separate hosts at some
# point in the future
include_recipe 'mailman-api'

if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/colab.repo' do
    owner 'root'
    mode 0644
  end
end

package 'colab'

service 'colab' do
  action :start
end
