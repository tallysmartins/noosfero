include_recipe 'mezuro::service'

# change this to COPR repo when gets ready
execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'prezento-spb'

template '/etc/mezuro/prezento/database.yml' do
  source 'prezento/database.yml.erb'
  owner 'prezento'
  group 'prezento'
  mode '0600'
  notifies :restart, 'service[prezento.target]'
end

PREZENTO_DIR='/usr/share/mezuro/prezento'

execute 'prezento:schema' do
  command 'RAILS_ENV=production bundle exec rake db:schema:load'
  cwd PREZENTO_DIR
  user 'prezento'
end

execute 'prezento:migrate' do
  command 'RAILS_ENV=production bundle exec rake db:migrate'
  cwd PREZENTO_DIR
  user 'prezento'
  notifies :restart, 'service[prezento.target]'
end

template PREZENTO_DIR + '/config/kalibro.yml' do
  source 'prezento/kalibro.yml.erb'
  owner 'prezento'
  group 'prezento'
  mode '0644'
  notifies :restart, 'service[prezento.target]'
end

template '/etc/nginx/conf.d/prezento.conf' do
  source 'prezento/nginx.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end

