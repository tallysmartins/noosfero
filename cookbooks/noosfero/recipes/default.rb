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
  command 'RAILS_ENV=production bundle exec rake db:schema:load && RAILS_ENV=production bundle exec rake db:data:minimal'
  cwd '/usr/lib/noosfero'
  user 'noosfero'
  not_if do
    # if the profiles table already exists, the schema was already loaded
    system("psql -h database -U noosfero --no-align --tuples-only -q -c 'select count(*) from profiles'")
  end
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
  notifies :reload, 'service[nginx]'
end
