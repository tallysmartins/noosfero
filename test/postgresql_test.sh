. $(dirname $0)/test_helper.sh

test_postgresql_running() {
  assertTrue 'PostgreSQL running' 'run_on database pgrep -fa postgres'
}

test_colab_database_created() {
  assertTrue 'colab database created in PostgreSQL' 'run_on database sudo -u postgres -i psql colab < /dev/null'
}

. shunit2

