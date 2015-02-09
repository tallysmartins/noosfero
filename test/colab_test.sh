. $(dirname $0)/test_helper.sh

test_database_connectivity() {
  assertTrue 'colab database connectivity' 'run_on integration psql -h database -U colab < /dev/null'
}

test_colab_config_is_in_place() {
  assertTrue 'colab settings.yml is in place' 'run_on integration test -f /etc/colab/settings.yaml'
}

test_colab_running() {
  assertTrue 'colab service running' 'run_on integration pgrep -fa colab.wsgi'
}

test_colab_responds() {
  assertTrue 'colab responds' 'run_on integration curl --fail http://localhost:8001'
}

. shunit2
