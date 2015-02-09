name "integration_server"
description "Application that manages user authentication, visual integration and gamification"

# TODO colab and mailman-api should be able to run in separate hosts at some
# point in the future
run_list 'recipe[mailman-api]', 'recipe[colab]', 'recipe[basics::nginx]', 'recipe[colab::nginx]'
