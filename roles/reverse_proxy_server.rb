name 'database_server'
description 'Reverse proxy server'
run_list 'recipe[basics::nginx]', 'recipe[reverse_proxy]', 'recipe[reverse_proxy::mailman]'
