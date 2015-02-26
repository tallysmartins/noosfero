package 'mailman'

template '/etc/mailman/mm_cfg.py' do
  owner 'root'
  group 'mailman'
  mode 0644
  notifies :restart, 'service[mailman]'
end

execute 'create-meta-list' do
  admin = node['config']['lists_admin']
  password = SecureRandom.random_number.to_s

  command "sudo -u mailman /usr/lib/mailman/bin/newlist --quiet mailman #{admin} $(openssl rand -hex 6)"

  not_if { File.exists?('/var/lib/mailman/lists/mailman') }
  notifies :restart, 'service[mailman]'
end

service 'mailman' do
  action :enable
  supports :restart => true
end

execute 'postfix:config' do
  command [
    "postconf relay_domains=#{node['config']['lists_hostname']}",
    "postconf transport_maps=hash:/etc/postfix/transport",
  ].join(' && ')
  notifies :reload, 'service[postfix]'
end

execute 'postfix:interfaces' do
  command "postconf inet_interfaces=\"$(cat /etc/hostname), localhost\""
  only_if { `postconf -h inet_interfaces`.strip == 'localhost' }
  notifies :restart, 'service[postfix]'
end

file '/etc/postfix/transport' do
  owner 'root'
  group 'root'
  mode  0644
  content "#{node['config']['lists_hostname']}  mailman:\n"
  notifies :run, 'execute[compile-postfix-transport]'
end

execute 'compile-postfix-transport' do
  command 'postmap /etc/postfix/transport'
  action :nothing
end

cookbook_file '/etc/postfix/postfix-to-mailman-centos.py' do
  owner 'root'
  group 'root'
  mode 0755
end

ruby_block 'configure-mailman-transport' do
  block do
    lines = [
      'mailman   unix  -       n       n       -       -       pipe',
      '  flags=FR user=mailman:mailman',
      '  argv=/etc/postfix/postfix-to-mailman-centos.py ${nexthop} ${user}',
    ]
    File.open('/etc/postfix/master.cf', 'a') do |f|
      lines.each do |line|
        f.puts line
      end
    end
  end
  only_if { !system('grep', '^mailman', '/etc/postfix/master.cf')}
end

