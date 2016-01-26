
package 'memcached'

service 'memcached' do
  action [:enable, :start]
end

if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/colab.repo' do
    action :delete
  end
end

# remove link left behind by old colab packages
file '/usr/share/nginx/colab' do
  action :delete
end

package 'colab' do
  action :upgrade
  notifies :restart, 'service[colab]'
end

package 'colab-spb-theme' do
  action :upgrade
  notifies :restart, 'service[colab]'
end

package 'colab-spb-plugin' do
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

execute 'secret-key' do
  f = '/etc/colab/secret.key'
  command "openssl rand -hex 32 -out #{f} && chown root:colab #{f} && chmod 0640 #{f}"
  not_if { File.exists?(f) }
  notifies :create, 'template[/etc/colab/settings.d/00-custom_settings.py]'
end

template '/etc/colab/gunicorn.py' do
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/00-custom_settings.py' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/01-database.py' do
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
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/04-memcached.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/05-celery.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/06-raven-settings.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
end

# Adding plugins for colab
template '/etc/colab/plugins.d/gitlab.py' do
  owner 'root'
  group 'colab'
  mode 0640
  get_private_token =  lambda do
    Dir.chdir '/usr/lib/gitlab' do
      `sudo -u git RAILS_ENV=production bundle exec rails runner \"puts User.find_by_name(\'admin-gitlab\').private_token\"`.strip
    end
  end

  variables(
    :get_private_token => get_private_token
  )

  notifies :restart, 'service[colab]'
end

template '/etc/colab/plugins.d/noosfero.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
  get_private_token = lambda do
    `psql --tuples-only --host database --user colab -c "select private_token from users where login = 'admin-noosfero'" noosfero`.strip
  end
  variables(:get_private_token => get_private_token)
end

template '/etc/colab/plugins.d/spb.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/plugins.d/sentry_client.py' do
  owner 'root'
  group 'colab'
  mode 0640
  notifies :restart, 'service[colab]'
end

execute 'colab-admin migrate'

# Adding widgets for colab
cookbook_file '/etc/colab/widgets.d/dashboard.py' do
  owner 'root'
  group 'colab'
  mode 0640

  notifies :restart, 'service[colab]'
end

cookbook_file '/etc/colab/widgets.d/profile.py' do
  owner 'root'
  group 'colab'
  mode 0640

  notifies :restart, 'service[colab]'
end

# Static files
directory '/var/lib/colab/assets/spb/' do
  owner  'root'
  group  'root'
  mode   0755
end

cookbook_file '/var/lib/colab/assets/spb/fav.ico' do
  owner 'root'
  group 'root'
  mode 0644
end

# Add mailman group to colab user
execute 'colab-mailman-group' do
  command "usermod -a -G mailman colab"
end

# Collect static is here instead of colab.spec because
#   plugins might provide their own static files, as
#   the package don't know about installed plugins
#   collectstatic needs to run after package install
#   and plugins instantiated. Same for migrate.
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
