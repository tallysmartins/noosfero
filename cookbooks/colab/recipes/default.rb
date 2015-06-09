
package 'memcached'

service 'memcached' do
  action [:enable, :start]
end

if node['platform'] == 'centos'
  cookbook_file '/etc/yum.repos.d/colab.repo' do
    owner 'root'
    mode 0644
  end
end

package 'colab'

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

execute 'create-admin-token-colab' do
  user = "admin-gitlab"
  email = "admin-gitlab@admin.com"
  password = SecureRandom.random_number.to_s

  command "echo \"from colab.accounts.models import User; User.objects.create_superuser(\'#{user}\', \'#{email}\', \'#{password}\')\" | colab-admin shell"
end

execute 'create-admin-token-gitlab' do
  user = "admin-gitlab"
  email = "admin-gitlab@admin.com"
  password = SecureRandom.random_number.to_s

  command "RAILS_ENV=production bundle exec rails runner \"User.create(name: \'#{name}\', username: \'#{name}\', email: \'#{email}\', password: \'#{password}\', admin: \'true\')\""

  cwd '/usr/lib/gitlab'
  user 'git'
end

template '/etc/colab/settings.d/01-apps.yaml' do
  owner  'root'
  group  'colab'
  mode   0640
  notifies :restart, 'service[colab]'

  get_private_token =  lambda do
    Dir.chdir '/usr/lib/gitlab' do
      `sudo -u git RAILS_ENV=production bundle exec rails runner \"puts User.find_by_email(\'admin-gitlab@admin.com\').private_token\"`.strip
    end
  end

  variables(
    :get_private_token => get_private_token
  )
end

template '/etc/colab/settings.d/02-logging.yaml' do
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

cookbook_file '/var/lib/colab-assets/spb/logo.svg' do
  owner 'root'
  group 'root'
  mode 0644
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
