. $(dirname $0)/test_helper.sh

test_postgresql_running() {
  assertTrue 'PostgreSQL running' 'run_on database pgrep -fa postgres'
}

. shunit2

