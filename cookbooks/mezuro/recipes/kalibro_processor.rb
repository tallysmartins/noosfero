execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

template '/etc/mezuro/kalibro-processor/database.yml' do
  source 'kalibro_processor/database.yml.erb'
  owner 'kalibro_processor'
  group 'kalibro_processor'
  mode '0600'
  notifies :restart, 'service[kalibro-processor.target]'
end

package 'kalibro-processor'

service 'kalibro-processor.target' do
  action [:enable, :start]
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
