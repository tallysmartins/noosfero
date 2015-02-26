if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/gitlab.repo' do
    owner 'root'
    mode 0644
  end
end

package 'redis'
service 'redis' do
  action [:enable, :start]
end

package 'gitlab'

template '/etc/gitlab/database.yml' do
  owner 'root'
  group 'root'
  mode 0644

  notifies :run, 'execute[gitlab:setup]'
end

execute 'gitlab:setup' do
  user 'git'
  cwd '/usr/lib/gitlab'
  command 'yes yes | bundle exec rake db:setup RAILS_ENV=production'

  action :nothing
  notifies :restart, 'service[gitlab]'
end

# gitlab-shell configuration
template '/etc/gitlab-shell/config.yml' do
  source 'gitlab-shell.yml.erb'

  owner 'root'
  group 'root'
  mode 0644

  notifies :restart, 'service[gitlab]'
end

####################################################
# Run under /gitlab
####################################################

template '/etc/gitlab/gitlab.yml' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[gitlab]'
end
cookbook_file '/usr/lib/gitlab/config/initializers/gitlab_path.rb' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[gitlab]'
end
template '/etc/gitlab/unicorn.rb' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[gitlab]'
end

####################################################
# Run under /gitlab (END)
####################################################

# TODO: Remote-User authentication

service 'gitlab' do
  action :enable
  supports :restart => true
end
