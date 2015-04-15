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
cookbook_file '/etc/gitlab/unicorn.rb' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[gitlab]'
end

####################################################
# Run under /gitlab (END)
####################################################

# serve static files with nginx
template '/etc/nginx/conf.d/gitlab.conf' do
  source 'nginx.conf.erb'
  mode 0644
  notifies :reload, 'service[nginx]'
end

service 'gitlab' do
  action :enable
  supports :restart => true
end


####################################################
#  SELinux: allow gitlab to use '/tmp'
####################################################

cookbook_file '/etc/selinux/local/gitlab.te' do
  notifies :run, 'execute[selinux-gitlab]'
end
execute 'selinux-gitlab' do
  command 'selinux-install-module /etc/selinux/local/gitlab.te'
  action :nothing
end


####################################################
#  SELinux: allow nginx to use gitlab upstream
####################################################

cookbook_file '/etc/selinux/local/nginx.te' do
  notifies :run, 'execute[selinux-nginx]'
end
execute 'selinux-nginx' do
  command 'selinux-install-module /etc/selinux/local/nginx.te'
  action :nothing
end

