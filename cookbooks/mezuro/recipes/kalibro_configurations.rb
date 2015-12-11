# TODO: remove before define main repo
execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'kalibro-configurations'

service 'kalibro-configurations' do
  action [:enable, :start]
end

template '/etc/mezuro/kalibro-configurations/database.yml' do
  source 'kalibro_configurations/database.yml.erb'
  owner 'kalibro_configurations'
  group 'kalibro_configurations'
  mode '0600'
  notifies :restart, 'service[kalibro-configurations]'
end
