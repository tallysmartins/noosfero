. $(dirname $0)/test_helper.sh

test_mailman_api_running() {
  assertTrue 'mailman running' 'run_on integration pgrep -fa mailman-api'
}

. shunit2

