name 'database_server'
description 'Database server'
run_list *[
  'recipe[postgresql]',
  'recipe[redis]',
  'recipe[postgresql::colab]',
  'recipe[postgresql::gitlab]',
  'recipe[postgresql::noosfero]',
]
