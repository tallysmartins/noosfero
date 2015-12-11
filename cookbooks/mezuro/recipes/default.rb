# Install kalibro configuration
# TODO: change the repo
execute 'download:repo' do
  command 'wget https://copr.fedoraproject.org/coprs/ribeiro/athos-spb/repo/epel-7/ribeiro-athos-spb-epel-7.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'kalibro-configurations-deps'
package 'kalibro-configurations'
package 'kalibro-processor'

service 'kalibro_configurations' do
  action [:enable, :start]
end

template '/etc/kalibro-configurations/database.yml' do
  source 'kalibro_configurations/database.yml.erb'
  owner 'kalibro_configurations'
  group 'kalibro_configurations'
  mode '0600'
  notifies :restart, 'service[kalibro_configurations]'
end

template '/etc/kalibro-processor/database.yml' do
  source 'kalibro_processor/database.yml.erb'
  owner 'kalibro_processor'
  group 'kalibro_processor'
  mode '0600'
  action :nothing
  #notifies :restart, 'service[kalibro_processor]'
end

