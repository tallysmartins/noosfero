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

cookbook_file '/usr/lib/colab/lib/python2.7/site-packages/colab/static/img/logo.svg' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'execute[colab-admin:collectstatic]'
end

execute 'colab-admin migrate'
execute 'colab-admin:collectstatic' do
  command 'colab-admin collectstatic --noinput'
end

service 'colab' do
  action [:enable, :start]
  supports :restart => true
end
