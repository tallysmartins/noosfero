name 'mezuro_server'
description 'Mezuro server'
run_list *[
  'recipe[mezuro::kalibro_processor]',
  'recipe[mezuro::kalibro_configurations]'
]
