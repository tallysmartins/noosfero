include_recipe 'email'

# smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
# smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key

postfix_config = {

  myhostname: node['config']['relay_hostname'],

  relay_domains: [
    node['config']['lists_hostname'],
    node['config']['external_hostname'],
  ].join(', '),

  transport_maps: 'hash:/etc/postfix/transport',

  mynetworks: '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ' + node['peers'].values.sort.join(' '),

}

execute 'postfix:relay:config' do
  command postfix_config.map { |k,v| "postconf #{k}='#{v}'" }.join(' ; ')
  notifies :reload, 'service[postfix]'
end

execute 'postfix:interfaces:all' do
  command "postconf inet_interfaces=all"
  notifies :restart, 'service[postfix]'
  only_if { `postconf -h inet_interfaces`.strip != 'all' }
end

transport = {
  node['config']['lists_hostname'] => node['peers']['integration'],
  node['config']['external_hostname'] => node['peers']['integration'],
}

file '/etc/postfix/transport' do
  owner 'root'
  group 'root'
  mode 0644
  content transport.map { |domain,ip| "#{domain}\tsmtp:[#{ip}]\n" }.join
  notifies :run, 'execute[transport:postmap]'
end

execute 'transport:postmap' do
  command "postmap /etc/postfix/transport"
  action :nothing
end

external_relay = node['config']['external_outgoing_mail_relay']
if external_relay
  execute "postconf relayhost=#{external_relay}"
else
  execute 'postconf -X relayhost'
end
