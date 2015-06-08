name "integration_server"
description "Server that runs COLAB (user authentication, visual integration and gamification), mailman (mailing lists), and Gitlab (git repositories)"

# TODO colab and mailman-api should be able to run in separate hosts at some
# point in the future
run_list *[
  'recipe[basics::nginx]',
  'recipe[mailman-api]',
  'recipe[mailman]',
  'recipe[mailman::webui]',
  'recipe[colab]',
  'recipe[colab::nginx]',
  'recipe[gitlab]',
  'recipe[backup]',
]
