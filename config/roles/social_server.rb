name 'database_server'
description 'Social networking server'
run_list *[
  'recipe[basics::nginx]',
  'recipe[noosfero]'
]
