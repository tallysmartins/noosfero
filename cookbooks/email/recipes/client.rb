include_recipe 'email'

execute 'postfix:configrelay' do
  command "postconf relayhost=[#{node['peers']['email']}]"
  notifies :reload, 'service[postfix]'

  # not on the relay host itself
  not_if { node.hostname == 'email' }
end
