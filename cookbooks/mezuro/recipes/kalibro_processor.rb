execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'kalibro-processor'

service 'kalibro-processor.target' do
  action [:enable, :start]
end

template '/etc/mezuro/kalibro-processor/database.yml' do
  source 'kalibro_processor/database.yml.erb'
  owner 'kalibro_processor'
  group 'kalibro_processor'
  mode '0600'
  notifies :restart, 'service[kalibro-processor.target]'
end

