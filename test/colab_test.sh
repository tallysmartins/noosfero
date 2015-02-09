. $(dirname $0)/test_helper.sh

test_colab_config_is_in_place() {
  assertTrue 'colab settings.yml is in place' 'run_on colab test -f /etc/colab/settings.yml'
}

test_colab_installed_and_running() {
  assertTrue 'colab service running' 'run_on colab pgrep -fa colab.wsgi'
}

. shunit2
