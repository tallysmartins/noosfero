execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

package 'prezento'

service 'prezento' do
  action [:enable, :start]
end

template '/etc/mezuro/prezento/database.yml' do
  source 'prezento/database.yml.erb'
  owner 'prezento'
  group 'prezento'
  mode '0600'
  notifies :restart, 'service[prezento]'
end

