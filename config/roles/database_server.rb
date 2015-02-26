name 'database_server'
description 'Database server'
run_list *[
  'recipe[postgresql]',
  'recipe[postgresql::colab]',
]
