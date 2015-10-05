if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/noosfero.repo' do
    action :delete
  end
end

# FIXME should not be needed. noosfero should depend on the right version
package 'noosfero-deps' do
  action :upgrade
  notifies :restart, 'service[noosfero]'
end

package 'noosfero' do
  action :upgrade
  notifies :restart, 'service[noosfero]'
end

template '/etc/noosfero/database.yml' do
  owner 'noosfero'
  group 'noosfero'
  mode '0600'
  notifies :restart, 'service[noosfero]'
end

# create DB schema
execute 'noosfero:schema' do
  command "RAILS_ENV=production bundle exec rake db:schema:load && RAILS_ENV=production NOOSFERO_DOMAIN=#{node['config']['external_hostname']} bundle exec rake db:data:minimal"
  cwd '/usr/lib/noosfero'
  user 'noosfero'
  not_if "psql -h database -U noosfero --no-align --tuples-only -q -c 'select count(*) from profiles'", :user => 'noosfero'
  notifies :restart, 'service[noosfero]'
end

package 'noosfero-spb' do
  action :upgrade
  notifies :restart, 'service[noosfero]'
end

plugins = [
  'breadcrumbs',
  'container_block',
  'display_content',
  'people_block',
  'recent_content',
  'remote_user',
  'organization_ratings',
  'statistics',
  'sub_organizations',
  'video',
  'community_block',
]

execute 'plugins:enable' do
  command '/usr/lib/noosfero/script/noosfero-plugins enable ' + plugins.join(' ')
end

plugins_spb = [
  'software_communities',
  'gov_user',
  'spb_migrations',
]

# HACK disable plugins_spb before migrating
# FIXME fix the plugins to not depend on other pugins
execute 'noosfero:plugins_spb:disable' do
  command '/usr/lib/noosfero/script/noosfero-plugins disable ' + plugins_spb.join(' ')
end

execute 'noosfero:migrate' do
  command 'RAILS_ENV=production SCHEMA=/dev/null bundle exec rake db:migrate'
  cwd '/usr/lib/noosfero'
  user 'noosfero'
end


#FIXME: We did it, because we have to enable each plugin and migrate it separately.
plugins_spb.each do |plugin|
  execute ('plugins_spb:activate:' + plugin) do
    command '/usr/lib/noosfero/script/noosfero-plugins enable ' + plugin
  end

  execute ('plugins_spb:migrate:' + plugin) do
    command 'RAILS_ENV=production SCHEMA=/dev/null bundle exec rake db:migrate'
    cwd '/usr/lib/noosfero'
    user 'noosfero'
  end
end

execute 'plugins:activate' do
  command "RAILS_ENV=production bundle exec rake noosfero:plugins:enable_all"
  cwd '/usr/lib/noosfero'
  user 'noosfero'
  only_if 'bundle exec rake -P | grep enable_all'
end

execute 'theme:enable' do
  command 'psql -h database -U noosfero --no-align --tuples-only -q -c "update environments set theme=\'noosfero-spb-theme\' where id=1;"'
end

execute 'software:create_licenses' do
  cwd '/usr/lib/noosfero'
  command 'sudo -u noosfero bundle exec rake software:create_licenses RAILS_ENV=production'
end

cookbook_file '/etc/noosfero/unicorn.rb' do
  owner 'root'; group 'root'; mode 0644
  notifies :restart, 'service[noosfero]'
end

cookbook_file '/etc/default/noosfero' do
  owner 'root'; group 'root'; mode 0644
  source 'noosfero-default'
  notifies :restart, 'service[noosfero]'
end

package 'cronie'
service 'crond' do
  action [:enable, :start]
end

service 'noosfero' do
  action [:enable, :start]
end

service 'memcached' do
  action [:enable, :start]
end

template '/etc/nginx/conf.d/noosfero.conf' do
  owner 'root'; group 'root'; mode 0644
  source 'nginx.conf.erb'
  notifies :restart, 'service[nginx]'
end

cookbook_file '/usr/lib/noosfero/config/noosfero.yml' do
  owner 'root'; group 'root'; mode 0644
  source 'noosfero.yml'
  notifies :restart, 'service[noosfero]'
end

cookbook_file "/usr/local/bin/noosfero-create-api-user" do
  mode 0755
end

execute 'create-admin-token-noosfero' do
  command [
    "RAILS_ENV=production bundle exec rails runner",
    "/usr/local/bin/noosfero-create-api-user",
    "admin-noosfero", # username
    "noosfero@localhost.localdomain", # email
  ].join(' ')
  cwd '/usr/lib/noosfero'
  user 'noosfero'
end

execute 'grant:noosfero:colab' do
  command 'psql -h database -U noosfero -c "GRANT SELECT ON users TO colab"'
end

###############################################
#  SELinux: permission to access static files noosfero
################################################

cookbook_file '/etc/selinux/local/noosfero.te' do
  notifies :run, 'execute[selinux-noosfero]'
end

execute 'selinux-noosfero' do
  command 'selinux-install-module /etc/selinux/local/noosfero.te'
  action :nothing
end
