name 'database_server'
description 'Database server'
run_list *[
  'recipe[postgresql]',
  'recipe[redis]',
  'recipe[postgresql::colab]', # must come before the other apps
  'recipe[postgresql::noosfero]',
  'recipe[postgresql::gitlab]',
]
