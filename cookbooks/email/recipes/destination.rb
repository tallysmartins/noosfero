execute 'postfix::set_as_final_destination' do
  command "postconf mydestination='$myhostname, localhost.$mydomain, localhost, #{node['config']['external_hostname']}'"
  not_if "grep mydestination.*#{node['config']['external_hostname']} /etc/postfix/main.cf"
  notifies :reload, 'service[postfix]'
end
