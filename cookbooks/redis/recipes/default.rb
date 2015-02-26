package 'redis'

template '/etc/redis.conf' do
  user 'root'
  group 'root'
  mode 0644

  notifies :restart, 'service[redis]'
end

service 'redis' do
  action [:enable, :start]
end
