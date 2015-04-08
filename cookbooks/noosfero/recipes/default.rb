if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/noosfero.repo' do
    owner 'root'
    mode 0644
  end
end

package 'noosfero'

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

package 'noosfero-spb'

plugins = [
  'breadcrumbs',
  'container_block',
  'display_content',
  'people_block',
  'recent_content',
  'remote_user',
  'software_communities', # from noosfero-spb
  'statistics',
  'sub_organizations',
  'video',
]

execute 'plugins:enable' do
  command '/usr/lib/noosfero/script/noosfero-plugins enable ' + plugins.join(' ')
end

execute 'theme:enable' do
  command 'psql -h database -U noosfero --no-align --tuples-only -q -c "update environments set theme=\'noosfero-spb-theme\' where id=1;"'
end

template '/etc/noosfero/thin.yml' do
  owner 'root'; group 'root'; mode 0644
  notifies :restart, 'service[noosfero]'
end

cookbook_file '/etc/default/noosfero' do
  owner 'root'; group 'root'; mode 0644
  source 'noosfero-default'
  notifies :restart, 'service[noosfero]'
end

service 'noosfero' do
  action [:enable, :start]
end

template '/etc/nginx/conf.d/noosfero.conf' do
  owner 'root'; group 'root'; mode 0644
  source 'nginx.conf.erb'
  notifies :restart, 'service[nginx]'
end
