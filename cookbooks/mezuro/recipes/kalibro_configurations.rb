# TODO: remove before define main repo
execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'kalibro-configurations'
package 'nginx'

service 'kalibro-configurations.target' do
  action [:enable, :start]
end

service 'nginx' do
  action [:enable, :start]
end

template '/etc/mezuro/kalibro-configurations/database.yml' do
  source 'kalibro_configurations/database.yml.erb'
  owner 'kalibro_configurations'
  group 'kalibro_configurations'
  mode '0600'
  notifies :restart, 'service[kalibro-configurations.target]'
end

CONFIGURATIONS_DIR='/usr/share/mezuro/kalibro-configurations'

execute 'kalibro-configurations:schema' do
  command 'RAILS_ENV=production bundle exec rake db:schema:load'
  cwd CONFIGURATIONS_DIR
  user 'kalibro_configurations'
end

execute 'kalibro-configurations:migrate' do
  command 'RAILS_ENV=production bundle exec rake db:migrate'
  cwd CONFIGURATIONS_DIR
  user 'kalibro_configurations'
  notifies :restart, 'service[kalibro-configurations.target]'
end

template '/etc/nginx/conf.d/kalibro-configurations.conf' do
  source 'kalibro_configurations/nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]'
end
