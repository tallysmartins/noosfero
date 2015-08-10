name 'server'
description 'Common configuration for all servers'
run_list 'recipe[basics]', 'recipe[firewall]', 'recipe[email::client]', 'recipe[munin::node]'
