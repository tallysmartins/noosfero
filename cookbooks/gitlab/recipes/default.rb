if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/gitlab.repo' do
    action :delete
  end
end

package 'gitlab' do
  action :upgrade
  notifies :restart, 'service[gitlab]'
end


template '/etc/gitlab/database.yml' do
  owner 'root'
  group 'root'
  mode 0644

  notifies :run, 'execute[gitlab:setup]', :immediately
end

execute 'gitlab:setup' do
  user 'git'
  cwd '/usr/lib/gitlab'
  command 'yes yes | bundle exec rake db:setup RAILS_ENV=production && touch /var/lib/gitlab/setup.done'
  not_if { File.exists?('/var/lib/gitlab/setup.done') }

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

# gitlab redis configuration
template '/usr/lib/gitlab/config/resque.yml' do
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

execute 'fix-relative-url-for-assets' do
  command 'sed -i \'s/# config.relative_url_root = "\/gitlab"/config.relative_url_root = "\/gitlab"/\' /usr/lib/gitlab/config/application.rb'
  only_if 'grep -q "# config.relative_url_root" /usr/lib/gitlab/config/application.rb'
  notifies :run, 'execute[precompile-assets]'
end

execute 'change-cache-owner' do
  command 'chown -R git:git /usr/lib/gitlab/tmp/cache'
  only_if 'ls -l /usr/lib/gitlab/tmp/cache | grep root'
end

execute 'change-assets-owner' do
  command 'chown -R git:git /usr/lib/gitlab/public/assets'
  only_if 'ls -l /usr/lib/gitlab/public/assets | grep root'
end

execute 'change-gitlab-assets-owner' do
  command 'chown -R git:git /var/lib/gitlab-assets'
  only_if 'ls -l /var/lib/gitlab-assets | grep root'
end

execute 'precompile-assets' do
  user 'git'
  cwd '/usr/lib/gitlab'
  command 'bundle exec rake assets:precompile RAILS_ENV=production'
  action :nothing
end
