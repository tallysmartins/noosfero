template '/etc/nginx/conf.d/colab.conf' do
  owner 'root'
  group 'root'
  mode  0644
  notifies :restart, 'service[nginx]'
end
