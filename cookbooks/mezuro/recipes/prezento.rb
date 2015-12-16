# change this to COPR repo
execute 'download:mezuro' do
  command 'wget https://bintray.com/mezurometrics/rpm/rpm -O bintray-mezurometrics-rpm.repo'
  cwd '/etc/yum.repos.d'
  user 'root'
end

template '/etc/mezuro/prezento/database.yml' do
  source 'prezento/database.yml.erb'
  owner 'prezento'
  group 'prezento'
  mode '0600'
  notifies :restart, 'service[prezento.target]'
end

package 'prezento'

service 'prezento.target' do
  action [:enable, :start]
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

#############################################################################
# The next lines install the mezuro plugin for colab intergration           #
# This shold be removed when the plugin were install thought pkg colab-deps #
#############################################################################

git '/home/vagrant/colab-mezuro-plugin' do
  repository 'https://github.com/colab/colab-mezuro-plugin.git'
  revision 'master'
end

execute 'pip:install:plugin' do
  command '/usr/lib/colab/bin/pip install .'
  cwd '/home/vagrant/colab-mezuro-plugin'
  user 'root'
end
