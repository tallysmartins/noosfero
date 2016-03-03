include_recipe 'mezuro::service'

execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'kalibro-processor'

template '/etc/mezuro/kalibro-processor/database.yml' do
  source 'kalibro_processor/database.yml.erb'
  owner 'kalibro_processor'
  group 'kalibro_processor'
  mode '0600'
  notifies :restart, 'service[kalibro-processor.target]'
end

PROCESSOR_DIR='/usr/share/mezuro/kalibro-processor'

execute 'kalibro-processor:schema' do
  command 'RAILS_ENV=production bundle exec rake db:schema:load'
  cwd PROCESSOR_DIR
  user 'kalibro_processor'
end

execute 'kalibro-processor:migrate' do
  command 'RAILS_ENV=production bundle exec rake db:migrate'
  cwd PROCESSOR_DIR
  user 'kalibro_processor'
  notifies :restart, 'service[kalibro-processor.target]'
end

execute 'kalibro-processor:open_port' do
  command 'semanage port -a -t http_port_t -p tcp 82'
  user 'root'
  only_if '! semanage port -l | grep "^\(http_port_t\)\(.\)\+\(\s82,\)"'
end

template '/etc/nginx/conf.d/kalibro-processor.conf' do
  source 'kalibro_processor/nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]'
end
