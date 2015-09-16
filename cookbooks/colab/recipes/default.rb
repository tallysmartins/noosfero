
package 'memcached'

service 'memcached' do
  action [:enable, :start]
end

if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/colab.repo' do
    action :delete
  end
end

# FIXME should not be needed; colab should depend on the right version of
# colab-deps
package 'colab-deps' do
  action :upgrade
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

execute 'secret-key' do
  f = '/etc/colab/secret.key'
  command "openssl rand -hex 32 -out #{f} && chown root:colab #{f} && chmod 0640 #{f}"
  not_if { File.exists?(f) }
  notifies :create, 'template[/etc/colab/settings.yaml]'
end

template '/etc/sysconfig/colab' do
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/00-database.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

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

execute 'create-admin-token-noosfero' do
  user = "admin-noosfero"
  email = "admin-noosfero@example.com"
  password = SecureRandom.random_number.to_s

  command "bundle exec rails c production <<EOF
            user = User.create(login: \'#{user}\', email: \'#{email}\', password: \'#{password}\', password_confirmation: \'#{password}\')
            user.activate
            user.generate_private_token_if_not_exist
            Environment.default.add_admin user.person
            exit
          "

  user_exist = lambda do
    Dir.chdir '/usr/lib/noosfero' do
      `RAILS_ENV=production bundle exec rails runner \"puts User.find_by_identifier(\'admin-noosdero\').nil?\"`.strip
    end
  end

  not_if {user_exist.call == "false"}

  cwd '/usr/lib/noosfero'
  user 'noosfero'
end

template '/etc/colab/settings.d/01-apps.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'

  get_gitlab_private_token =  lambda do
    Dir.chdir '/usr/lib/gitlab' do
      `sudo -u git RAILS_ENV=production bundle exec rails runner \"puts User.find_by_name(\'admin-gitlab\').private_token\"`.strip
    end
  end

  get_noosfero_private_token =  lambda do
    Dir.chdir '/usr/lib/noosfero' do
      `sudo -u noosfero RAILS_ENV=production bundle exec rails runner \"puts User.find_by_name(\'admin-noosfero\').private_token\"`.strip
    end
  end

  variables(
    :get_gitlab_private_token => get_gitlab_private_token,
    :get_noosfero_private_token => get_noosfero_private_token
  )
end

template '/etc/colab/settings.d/02-logging.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

template '/etc/colab/settings.d/03-sentry.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'
end

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
