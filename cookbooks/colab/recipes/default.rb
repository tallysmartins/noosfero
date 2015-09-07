
package 'memcached'

service 'memcached' do
  action [:enable, :start]
end

if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/colab.repo' do
    action :delete
  end
end

package 'colab' do
  action :upgrade
  notifies :restart, 'service[colab]'
end

directory '/etc/colab' do
  owner  'root'
  group  'root'
  mode   0755
end

directory '/var/log/colab' do
  owner  'colab'
  group  'colab'
  mode   0755
end

directory '/var/lock/colab' do
  owner 'colab'
  group 'colab'
  mode 0755
end

template '/etc/sysconfig/colab' do
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/00-database.py' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

# Creating a gitlab admin user
template '/tmp/admin-gitlab.json' do

  password = SecureRandom.random_number.to_s

  variables(
    :password => password
  )
end

execute 'create-admin-token-gitlab' do
  user = "admin-gitlab"
  email = "admin-gitlab@example.com"
  password = SecureRandom.random_number.to_s

  command "RAILS_ENV=production bundle exec rails runner \"User.create(name: \'#{user}\', username: \'#{user}\', email: \'#{email}\', password: \'#{password}\', admin: \'true\')\""

  user_exist = lambda do
    Dir.chdir '/usr/lib/gitlab' do
      `RAILS_ENV=production bundle exec rails runner \"puts User.find_by_name(\'admin-gitlab\').nil?\"`.strip
    end
  end

  not_if {user_exist.call == "false"}

  cwd '/usr/lib/gitlab'
  user 'git'
end

# Adding settings.d files
template '/etc/colab/settings.d/02-logging.py' do
  owner  'root'
  group  'colab'
  mode   0640
end

template '/etc/colab/settings.d/03-sentry.py' do
  owner  'root'
  group  'colab'
  mode   0640
end

template '/etc/colab/settings.d/memcached.py' do
  owner 'root'
  group 'colab'
  mode 0640
end

template '/etc/colab/settings.d/redis.py' do
  owner 'root'
  group 'colab'
  mode 0640
end

service 'colab' do
  action :restart
end

# Adding plugins for colab
template '/etc/colab/plugins.d/gitlab.py' do
  owner 'root'
  group 'colab'
  mode 0640
end

template '/etc/colab/plugins.d/noosfero.py' do
  owner 'root'
  group 'colab'
  mode 0640
end

template '/etc/colab/plugins.d/spb.py' do
  owner 'root'
  group 'colab'
  mode 0640
end

execute 'colab-admin migrate'

service 'colab' do
  action :restart
end

# Static files
directory '/var/lib/colab-assets/spb/' do
  owner  'root'
  group  'root'
  mode   0755
end

cookbook_file '/var/lib/colab-assets/spb/fav.ico' do
  owner 'root'
  group 'root'
  mode 0644
end

# Add mailman group to colab user
execute 'colab-mailman-group' do
  command "usermod -a -G mailman colab"
end

execute 'colab-admin migrate'
execute 'colab-admin:collectstatic' do
  command 'colab-admin collectstatic --noinput'
end

service 'colab' do
  action [:enable, :start]
  supports :restart => true
end

execute 'create-admin-token-colab' do
  command "colab-admin loaddata admin-gitlab.json"

  cwd '/tmp'
  user 'root'
end
